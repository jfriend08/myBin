#!/usr/bin/perl -w
use 5.010;
use Cwd;
# use Cwd;
# my $directory = shift;
# my $samFile = shift;
# my $sortedBamFile = shift;
# my $gfrFile = shift;
# my @transcript1=0;
# my @transcript2=0;
# my $match_string='';  #to store few sequence at the fusion junction
# my %matchSeq_list=(); #to store few sequence at the fusion junction
# my %Location1=();
# my %Location2=();
my $file1="CINSARC_67list.txt";
my $file2="HuGene-1_0-st-v1.na33.2.hg19.probeset.csv";
my @confinedAnno=(); 

open (LISTFILE, $file1) or die "cannot open file: $file1";
@listfile = <LISTFILE>;
close LISTFILE;

$filename1 = "Simple_CINSARC_list.txt";
open (OUT1, ">$filename1") or die "cannot open $filename1: $!";
print OUT1 "GeneSymbol\tProbeset\tChromosome\tLocation\tStartPoint\n";
for ($i=0; $i<@listfile; $i++){
    chomp $listfile[$i];
    my @test=split (/ +/,$listfile[$i]); #means one or more spaces       
    print OUT1 "$test[0]\t$test[1]\t$test[2]\t$test[3]\t$test[4]\n";
}
close OUT1;










