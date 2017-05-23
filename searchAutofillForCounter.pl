# Script to recursively search an archive of stored autofill output files (currently located at E:/XMLinput/old
# on all quantitation nodes) and return the paths to folders containing a quant file containing a user-specified
# counter # from Peptide Depot.

use strict;
use warnings;

my $pathToOld=$ARGV[0];
our $counter=$ARGV[1]; # make counter global so it is visible inside process_files

sub process_files {

	my $path = shift;
	
	# Open the directory.
	opendir (DIR, $path)
		or die "Unable to open $path: $!";

	# Read in the files. Generally you don't want to process 
	# the '.' and '..' files, so use grep() to take them out.
	my @files = grep { !/^\.{1,2}$/ } readdir (DIR);

	# Close the directory.
	closedir (DIR);

	#  At this point you will have a list of filenames
	#  without full paths ('filename' rather than
	#  '/home/count0/filename', for example)
	#  You will probably have a much easier time if you make
	#  sure all of these files include the full path,
	#  so here we will use map() to tack it on.
	#  (note that this could also be chained with the grep
	#  mentioned above, during the readdir() ).
	@files = map { $path . "/" . $_ } @files;

	for (@files) {

		# If the file is a directory
		if (-d $_) {
			# Recurse. Make a new call to process_files()
			# using a new directory we just found.
			process_files ($_);

		# If it isn't a directory, check to see if it's an autofill output file,
		# which are named 'completeLabelFree[x].txt' or 'completeSILAC[x].txt'.
		# And if it is, open the file and iterate through the first column
		# looking for a match to the counter #
		} else {
			if($_ =~ /complete/) {
				open my $fh, "<", $_ or die "Could not open '$_' $!\n";
				while (my $line = <$fh>) {
					chomp $line;
					my @parsed = split(/\t/,$line);
					my $firstCol = $parsed[0];
					# If you've got a match, print the path and line #, then terminate the loop
					if($counter eq $firstCol){
						print "MATCH: $firstCol\n";
						print "$_, line $.\n";
						close $fh;
						last;
					}
				}
				close $fh;
			}
		}
	}
}

# call the recursive function
process_files($pathToOld)