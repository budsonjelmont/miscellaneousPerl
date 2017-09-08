#!/usr/bin/perl

use strict;

open ALLPHOS, "DEPOD_201301_human_active_phosphatases_preproc.txt" or die $!;

my %sym2UP = ();
while(!eof(ALLPHOS)){
	my $line = readline(ALLPHOS);
	my @tokens = split(/\t/,$line);
	$sym2UP{$tokens[4]} = $tokens[6];
}
close ALLPHOS;

open HUGO, "C:/Users/superuser/Documents/Downloaded DBs/HUGO.txt" or die $!;
while(!eof(HUGO)){
	my $line = readline(HUGO);
	my @tokens = split(/\t/,$line);
	if(!exists $sym2UP{$tokens[1]}){
		$sym2UP{$tokens[1]} = $tokens[15];
	}
	my @otherNames = split(/,/,$tokens[5]);
	foreach(@otherNames){
		my $sym = $_;
		if(substr($sym,0,1) eq " "){
				$sym = substr($sym,1,length($sym)-1);
				print $sym."\n";
		}
		if(!exists $sym2UP{$sym}){
			$sym2UP{$sym} = $tokens[15];
		}
	}
}
close HUGO;	
	
open FILE, "DEPOD_201301_human_phosphatase-substrate_preproc.txt" or die $!;
open OUT, ">DEPOD_201301_human_phosphatase-substrate_preproc_parsedSubstrates.txt" or die $!;

while(!eof(FILE)){
	my $line = readline(FILE);
	$line =~ s/"|'//g;
	my @tokens=split(/\t/,$line);
	if($tokens[3] =~ /(Human)/){
		#print $tokens[3]."\n";
		$tokens[4] =~ s/Tyr-/Y/g;
		$tokens[4] =~ s/Ser-/S/g;
		$tokens[4] =~ s/Thr-/T/g;
		my @substrates=split(/,/,$tokens[4]);
		foreach (@substrates){
			my $site = $_;
			my $residue;
			my $sitenum;
			if(substr($site,0,1) eq " "){
				$site = substr($site,1,length($site)-1);
				print $site."\n";
			}
			my $residue = substr($site,0,1);
			my $sitenum = substr($site,1,length($site)-1);
			if($_ =~ /N\/A/){
				if(exists $sym2UP{$tokens[1]}){
					#print OUT $tokens[0]."\t".$tokens[1]."\t"."\t".$tokens[6];
					print OUT $sym2UP{$tokens[0]}."\t".$sym2UP{$tokens[1]}."\t"."\t"."P"."\t".$tokens[6];
				}
			} else {
				if(exists $sym2UP{$tokens[1]}){
					#print OUT $tokens[0]."\t".$tokens[1]."\t".$_."\t".$tokens[6];
					print OUT $sym2UP{$tokens[0]}."\t".$sym2UP{$tokens[1]}."\t".$residue."\t".$sitenum."\t"."P"."\t".$tokens[6];
				}
			}
		}
	}
}