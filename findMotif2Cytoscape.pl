#!/usr/bin/perl -w
#use strict;
# usage: findMotif2Cytoscape.pl <find motif report>
# example: findMotif2Cytoscape.pl SBRCT_diffTF_findMotif.txt

use 5.010;
use Cwd;

my $reportfile = shift;
# my $genelist = shift;
# my $run_diff_twoBitToFa=shift;
# my $run_all_twoBitToFa=shift;
# my $diff_motifHits=0;
# my $numBiggerThanMotifHits=0;
# my $p_valueSelectTimes=2000;
print "Input motif report file: $reportfile\n";

# my @annofile=0;
# my @diffgenelist=0;
# my @matchList=0;
# my @super_fafile=0;
# my @super_allfafile=0;
# my @super_diffgenelist=0;
# my %annohash =();
# my @MotifList=();
# my @MotifListName=();

open (MOTIFFILE, $reportfile) or die "cannot open file $reportfile";
my @MotifReport = <MOTIFFILE>;
close MOTIFFILE;
my $header=0;
for ($i=1;$i<@MotifReport;$i++){
    if ($i==1 && $header==0){
        print "SourceInteraction\tBindingMotif\tTotalDiffGenes\thitRatio\tp_value\tTargetInteraction\n";
        my $header=1;
    }
    
    chomp $MotifReport[$i];
    my @motif_elements=split ("\t", $MotifReport[$i]);
    my $hitRatio=$motif_elements[4]/$motif_elements[3];
    if (!$motif_elements[6]){
        print "$motif_elements[1]\t$motif_elements[2]\t$motif_elements[3]\t$hitRatio\t$motif_elements[5]\n";
    }

    if ($motif_elements[6]){

        my @hit_element1=split("#", $motif_elements[6]);        

        #my @hit_element_number=split("#[A-Z0-9]*[\|\-]*[A-Z0-9]*:", $motif_elements[6]);        

        #my @hit_element1=split(":[0-9]+\\|", $motif_elements[6]);        
        #my @hit_element1_number=split("[A-Z0-9]*[\|\-]*[A-Z0-9]*:", $motif_elements[6]);        
        #print "@hit_element1\n";
        
        for ($j=1; $j<@hit_element1; $j++){
        my @hit_element2=split(":", $hit_element1[$j]);
        #print "$hit_element2[0] $hit_element2[1] ";
        print "$motif_elements[1]\t$motif_elements[2]\t$motif_elements[3]\t$hitRatio\t$motif_elements[5]\t$hit_element2[0]\t$hit_element2[1]\n";
        }
        
    }
    
    
}
exit;
