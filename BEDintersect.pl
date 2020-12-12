#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use Cwd;

my $paternToSearch=();
my %super_hash=();

#################### read IMPACT file ####################
$paternToSearch= "*"."noT_noPair_q40_D800.txt";
my @files = glob("$paternToSearch");

for (my $i=0; $i<@files; $i++){
	open (FILE, "$files[$i]") or die "cannot open: $!";	
	my @currentFile=<FILE>;
	close FILE;
	for (my $line=0; $line<@currentFile; $line++){
		chomp $currentFile[$line];
		my @elm=split("\t", $currentFile[$line]);
		my $curKey=join("\t", @elm);
		if($super_hash{$curKey}){
			$super_hash{$curKey}=$super_hash{$curKey}+1;
		}
		else{
			$super_hash{$curKey}=1;
		}
	}
}


for my $key (keys %super_hash){
	my $value= $super_hash{$key};
	print "$key\t$value\n";
}