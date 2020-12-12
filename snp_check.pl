#!/usr/bin/perl
# this is the code that input the bed format file and check whether other sample have this snp also
# input: chrM    10411   10411   MT-ND5  5'Flank 1
use strict;
use warnings;
use Getopt::Std;
use Cwd;

my $chckingFile_die="/zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/samtools_snps/OUTfiles";
( scalar( @ARGV ) == 1 ) or die "";
my ($input_bed) = @ARGV;

open (FILE, $input_bed) or die "cannot open bed file"; 
my @bedfile = <FILE>;
close FILE;

my @checkfiles = glob("$chckingFile_die/*_SUM.txt");
for (my $i=0; $i<@checkfiles; $i++){
    chomp $checkfiles[$i];
    open (FILE, $checkfiles[$i]) or die "cannot open file"; 
    print "$checkfiles[$i]\n";
    my @currentFile=<FILE>;
    close FILE;
    for (my $bed_idx=0; $bed_idx<@bedfile; $bed_idx++){
        chomp $bedfile[$bed_idx];
        my @elm=split ("\t", $bedfile[$bed_idx]);
        print "@elm\n";
        if ($elm[0] =~ m/chr/){
            print "@elm\n";
        }
    }

}