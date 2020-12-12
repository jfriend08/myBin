#!/usr/bin/perl -w
#use strict;
# usage: Methy2GeneExprMatcher.pl <diffMethy probe List> <differential gene list> <how upstream you want> <logFC start column # in diffMethy list>
# example: Methy2GeneExprMatcher.pl SDHBnegvsGIST_KITandSDHBpos_3FC_1FC01Padj_10752_probelist.txt PEDvsAKIT_1FC01P_470genes.txt 4000 26
#Methy2GeneExprMatcher.pl SDHBnegvsGIST_KITandSDHBpos_3FC_1FC01Padj_10752_probelist.txt GISTvsRESR_1FC01Padjust_AllInfo_526genes.txt 4000 26
#Methy2GeneExprMatcher.pl SDHBnegvsGIST_KITandSDHBpos_2.5FC_1FC01Padj_14061_probelist.txt GISTvsRESR_1FC01Padjust_AllInfo_526genes.txt 4000 26

#Todo: this code is not flexible with the format of genelist. As I change the column, sample name ect, the code will get troubles. 

use 5.010;
use Cwd;

my $MethyFile = shift;
my $diffGeneFile = shift;
my $upstreamInterval=shift;
my $logFC_StartColumn=shift;
#my $run_diff_twoBitToFa=shift;
#my $run_all_twoBitToFa=shift;
#my $diff_motifHits=0;
#my $numBiggerThanMotifHits=0;
#my $p_valueSelectTimes=2000;
#print "num_selection\tTF\tmotif_seq\tnum_diffList\tnum_motifHits\tp_value\thit_gene\n";

my @MethyProbeIDandLocation=();
my @diffGeneIDandLocation=();
my $diffGeneID=();
my $diffGeneStrain=();
my $diffGeneSymbole=();
my $diffGeneLogFC=();
my $diffGenePvalue=();
my $diffGeneChromosome=();
my $diffGeneStart=();
my $diffGeneEnd=();

my $diffMethyID=();
my $diffMethyChromosome=();
my $diffMethyHit=();
my $diffMethyLogFC=();
my $diffMethyPvalue=();

my %matchedList=();

open (OUT1, ">MatchedList5.txt") or die "cannot open 1: $!";
open (OUT2, ">notMatchedList5.txt") or die "cannot open 2: $!";

#my @diffgenelist=0;
#my @matchList=0;
#my @super_fafile=0;
#my @super_allfafile=0;
#my @super_diffgenelist=0;
#my %annohash =();
#my @MotifList=();
#my @MotifListName=();

############################################################################################################################################

open (METHY, $MethyFile) or die "cannot open file $MethyFile";
my @MethyList = <METHY>;
for ($i=0;$i<@MethyList;$i++){
    chomp $MethyList[$i];
    my @tmp=split ("\t",$MethyList[$i]);
    $tmp[1] = "chr".$tmp[1];
    $MethyProbeIDandLocation[$i]=join ("#", $tmp[0], $tmp[1], $tmp[2], $tmp[$logFC_StartColumn], $tmp[$logFC_StartColumn+2]); #ID, Chromosome, Location, logFC, adjustP
    #print "$MethyProbeIDandLocation[$i]\n";
}
close METHY;

#close;
open (GENE, $diffGeneFile) or die "cannot open file $diffGeneFile";
my @diffGeneList = <GENE>;
for ($i=0;$i<@diffGeneList;$i++){
    chomp $diffGeneList[$i];
    my @tmp=split ("\t",$diffGeneList[$i]);
    my @tmp_location=split(" ",$tmp[12]);
    #print $tmp_location[1],"\n";
    #print "$tmp[0], $tmp_location[0], $tmp_location[1], $tmp[14], $tmp[101], $tmp[103]\n";
    $diffGeneIDandLocation[$i]=join ("#", $tmp[0], $tmp_location[0], $tmp_location[1], $tmp[14], $tmp[101], $tmp[103]); #ID, Location, strain, GeneSymbole, logFC, adjustP

}
close GENE;

#print "pass\n";
############################################################################################################################################
print OUT2 "diffGeneID\tdiffGeneStrain\tdiffGeneSymbole\tdiffGeneLogFC\tdiffGenePvalue\tdiffGeneChromosome\tdiffGeneStart\tdiffGeneEnd\n";
for ($i=1; $i<@diffGeneIDandLocation; $i++){
    $whetherMatched=0;

    my @tmp_diffGeneINFO=split("#",$diffGeneIDandLocation[$i]);
    $diffGeneID=$tmp_diffGeneINFO[0];
    $diffGeneStrain=$tmp_diffGeneINFO[2];
    $diffGeneSymbole=$tmp_diffGeneINFO[3];
    $diffGeneLogFC=$tmp_diffGeneINFO[4];
    $diffGenePvalue=$tmp_diffGeneINFO[5];
    my @tmp_location=split /[:-]+/, $tmp_diffGeneINFO[1];
    #print "$tmp_location[0]\t$tmp_location[1]\t$tmp_location[2]\n";
    #exit;

    if ($diffGeneStrain=~m/\+/){
        #print "$diffGeneStrain\t$tmp_location[0]\t$tmp_location[1]\t$tmp_location[2]\n";
        $diffGeneChromosome=$tmp_location[0];
        $diffGeneStart=$tmp_location[1]-$upstreamInterval;
        $diffGeneEnd=$tmp_location[2];
        #print "$diffGeneChromosome\n$diffGeneStart\n$diffGeneEnd\n";
    }
    if ($diffGeneStrain=~m/\-/){
        #print "$diffGeneStrain\t$tmp_location[0]\t$tmp_location[1]\t$tmp_location[2]\n";
        $diffGeneChromosome=$tmp_location[0];
        $diffGeneStart=$tmp_location[1];
        $diffGeneEnd=$tmp_location[2]+$upstreamInterval;
        #print "$diffGeneChromosome\n$diffGeneStart\n$diffGeneEnd\n";
    }
    #print "$diffGeneID\t$diffGeneStrain\t$diffGeneSymbole\t$diffGeneLogFC\t$diffGenePvalue\t$diffGeneChromosome\t$diffGeneStart\t$diffGeneEnd\n";
    my $tmp_key=join ("\t",$diffGeneID,$diffGeneStrain,$diffGeneSymbole,$diffGeneLogFC,$diffGenePvalue,$diffGeneChromosome,$diffGeneStart,$diffGeneEnd);
    for ($j=0; $j<@MethyProbeIDandLocation; $j++){
        my @tmp_diffMethyINFO=split("#",$MethyProbeIDandLocation[$j]);
        $diffMethyID=$tmp_diffMethyINFO[0];
        $diffMethyChromosome=$tmp_diffMethyINFO[1];
        $diffMethyHit=$tmp_diffMethyINFO[2];
        $diffMethyLogFC=$tmp_diffMethyINFO[3];
        $diffMethyPvalue=$tmp_diffMethyINFO[4];
        #print"hi~$diffMethyChromosome\t$diffGeneChromosome\t$diffMethyHit\t$diffGeneStart\t$diffMethyHit\t$diffGeneEnd\n";
        
        if ( ($diffMethyChromosome=~m/^$diffGeneChromosome$/) && ($diffMethyHit>$diffGeneStart) && ($diffMethyHit<$diffGeneEnd) ){            
            #print "$diffMethyID\t$diffMethyChromosome\t$diffMethyHit\t$diffMethyLogFC\t$diffMethyPvalue\n";
            push (@{$matchedList{$tmp_key}},join("\t",$diffMethyID,$diffMethyChromosome,$diffMethyHit,$diffMethyLogFC,$diffMethyPvalue));
            $whetherMatched=1;
        }          
    }

    if ($whetherMatched==0){
        print OUT2 "$tmp_key\n";
    }    
}

############################################################################################################################################

print OUT1 "diffGeneID\tdiffGeneStrain\tdiffGeneSymbole\tdiffGeneLogFC\tdiffGenePvalue\tdiffGeneChromosome\tdiffGeneStart\tdiffGeneEnd\tdiffMethyLogFC\tdiffMethyPvalue\tdiffMethyID\n";
for my $key (keys %matchedList)
{
    my @value= @{$matchedList{$key}};
    my $MethyFC="";
    my $MethyP="";
    my $MethyID="";
    foreach $line (@value)
    {
         my @tmp_elemets=split("\t", $line);
         $MethyFC=join ("|", $MethyFC, $tmp_elemets[3]);
         $MethyP=join ("|", $MethyP, $tmp_elemets[4]);
         $MethyID=join ("|", $MethyID, $tmp_elemets[0]);         
    }
    print OUT1 "$key\t$MethyFC\t$MethyP\t$MethyID\n"
}

close OUT1;
close OUT2;

exit;










