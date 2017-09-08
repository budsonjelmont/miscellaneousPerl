#!/usr/bin/perl

use strict;

open FILE, "C:/Users/superuser/Documents/Downloaded DBs/DEPOD/DEPOD_201301_human_active_phosphatases.txt" or die $!;
open OUT, ">DEPOD_201301_human_active_phosphatases_preproc.txt" or die $!;

while(!eof(FILE)){
	my $line = readline(FILE);
	$line =~ s/"|'//g;
	print OUT $line;
}