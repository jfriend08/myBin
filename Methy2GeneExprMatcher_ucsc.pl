#!/usr/bin/perl -w
#use strict;
# usage: Methy2GeneExprMatcher_ucsc.pl <diffMethy probe List> <differential gene list> <how upstream you want> <logFC start column # in diffMethy list>
# example: Methy2GeneExprMatcher_ucsc.pl SDHBnegvsGIST_KITandSDHBpos_2.5FC_1FC01Padj_14061_probelist.txt PEDvsAllOthers_1FC2FC01Padjust_1041genes.txt 4000 26
# example: Methy2GeneExprMatcher_ucsc.pl SDHBnegvsASandSBRCT_2FC1FC0.01Padj_14966_probelist.txt PEDvsAllOthers_1FC2FC01Padjust_1041genes.txt 4000 26
# example: Methy2GeneExprMatcher_ucsc.pl SDHBpos_AKITvsASandSBRCT_1FC0.01Padj_4845_probelist.txt PEDvsAllOthers_1FC2FC01Padjust_1041genes.txt 4000 26
#Todo: this code is not flexible with the format of genelist. As I change the column, sample name ect, the code will get troubles. 
#Todo: maybe need to add one variable to specify the column of logFC in <differential gene list>

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

open (OUT1, ">SDHBpos_AKITvsASandSBRCT4845_on_PEDvsAllOthers1041genes_MatchedList.txt") or die "cannot open 1: $!";
open (OUT2, ">SDHBpos_AKITvsASandSBRCT4845_on_PEDvsAllOthers1041genes_notMatchedList.txt") or die "cannot open 2: $!";

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

my $pwd = getcwd;
chdir("/pbtech_mounts/fdlab_store003/fdlab/annotations/human/hg19/ucsc/2013.09.10");
#my @header=0;
open (ANNOFILE, "knownGeneAnnotationTranscriptCompositeModel_nh_2013.09.10.interval") or die "cannot open anno file";
@annofile = <ANNOFILE>;
my @tmp_annofile=@annofile;
@annofile = grep (!/chrM/,@annofile);  #exclude the transcript from chrM, there are 19 transcripts in this case.
chdir($pwd);
for ($i=0; $i<@annofile; $i++){
    chomp $annofile[$i];
    my @tmp=split ("\t",$annofile[$i]);
    $annohash{$tmp[0]} = join ("\t", $tmp[2], $tmp[1], $tmp[3], $tmp[4], $tmp[5], $tmp[6], $tmp[7]); #make hash. key is ID, vaslue: strain, chromosome, start, end, exon starts, exon ends
}

open (GENE, $diffGeneFile) or die "cannot open file $diffGeneFile";
my @diffGeneList = <GENE>;
@diffGeneList = grep (!/(uc004coq.4|uc022bqo.2|uc004cor.1|uc004cos.5|uc022bqp.1|uc022bqq.1|uc022bqr.1|uc031tga.1|uc022bqs.1|uc011mfi.2|uc022bqt.1|uc031tgb.1|uc022bqu.2|uc004cov.5|uc004cow.2|uc004cox.4|uc022bqv.1|uc022bqw.1|uc022bqx.1|uc004coz.1)/,@diffGeneList);
for ($i=0;$i<@diffGeneList;$i++){
    chomp $diffGeneList[$i];
    my @tmp=split ("\t",$diffGeneList[$i]);
    #print "@tmp\n";
    my @matchedGeneInfo = split("\t", $annohash{$tmp[1]});
    #print "@matchedGeneInfo\n";
    $diffGeneIDandLocation[$i]=join ("#", $tmp[1], $tmp[0], $matchedGeneInfo[1], $matchedGeneInfo[0], $matchedGeneInfo[2], $matchedGeneInfo[3], $tmp[58], $tmp[60]); #ID, Symbol,chromosome, strain, start, end, logFC, padjust
    #$diffGeneIDandLocation[$i]=join ("#", $tmp[1], $tmp_location[0], $tmp_location[1], $tmp[14], $tmp[101], $tmp[103]); #ID, Location, strain, GeneSymbole, logFC, adjustP
    #print "$diffGeneIDandLocation[$i]\n";
}
close GENE;
#exit;
#print "pass\n";
############################################################################################################################################
print OUT2 "diffGeneID\tdiffGeneStrain\tdiffGeneSymbole\tdiffGeneLogFC\tdiffGenePvalue\tdiffGeneChromosome\tdiffGeneStart\tdiffGeneEnd\n";
for ($i=1; $i<@diffGeneIDandLocation; $i++){
    $whetherMatched=0;
    my @tmp_diffGeneINFO=split("#",$diffGeneIDandLocation[$i]); #ID, Symbol,chromosome, strain, start, end, logFC, padjust
    $diffGeneID=$tmp_diffGeneINFO[0];
    $diffGeneSymbole=$tmp_diffGeneINFO[1];
    $diffGeneChromosome=$tmp_diffGeneINFO[2];
    $diffGeneStrain=$tmp_diffGeneINFO[3];
    $diffGeneStart=$tmp_diffGeneINFO[4];
    $diffGeneEnd=$tmp_diffGeneINFO[5];
    $diffGeneLogFC=$tmp_diffGeneINFO[5];
    $diffGenePvalue=$tmp_diffGeneINFO[6];

    #my @tmp_location=split /[:-]+/, $tmp_diffGeneINFO[1];
    #print "$tmp_location[0]\t$tmp_location[1]\t$tmp_location[2]\n";
    #exit;

    if ($diffGeneStrain=~m/\+/){
        #print "$diffGeneStrain\t$tmp_location[0]\t$tmp_location[1]\t$tmp_location[2]\n";
        $diffGeneChromosome=$diffGeneChromosome;
        $diffGeneStart=$diffGeneStart-$upstreamInterval;
        $diffGeneEnd=$diffGeneEnd;
        #print "$diffGeneChromosome\n$diffGeneStart\n$diffGeneEnd\n";
    }
    if ($diffGeneStrain=~m/\-/){
        #print "$diffGeneStrain\t$tmp_location[0]\t$tmp_location[1]\t$tmp_location[2]\n";
        $diffGeneChromosome=$diffGeneChromosome;
        $diffGeneStart=$diffGeneStart;
        $diffGeneEnd=$diffGeneEnd+$upstreamInterval;
        #print "$diffGeneChromosome\n$diffGeneStart\n$diffGeneEnd\n";
    }
    #print "$diffGeneID\t$diffGeneStrain\t$diffGeneSymbole\t$diffGeneLogFC\t$diffGenePvalue\t$diffGeneChromosome\t$diffGeneStart\t$diffGeneEnd\n";
    my $tmp_key=join ("\t",$diffGeneID,$diffGeneStrain,$diffGeneSymbole,$diffGeneLogFC,$diffGenePvalue,$diffGeneChromosome,$diffGeneStart,$diffGeneEnd);
    #print "hi~$tmp_key\n";
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










