#!/usr/bin/perl -w

# usage: findMotifGetTFseq.pl <TF list><All_TF_bindingMotif_seq>
# example: findMotifTranslatorII.pl EwingvsRest_2FC005P_1809genes.tx

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed

use 5.010;
use Cwd;
my $loopstart=shift;
my $loopend=shift;
my $HUFILE = "HuGene_ID2Symbol.txt";
my $U133AFILE = "U133AallGene.txt";
#my $All_TF_motifFILE = shift;

#my @correct_TF=();
#my %name2ID =();
############################################################################################################################################

open (HUGENE_FILE, $HUFILE) or die "cannot open $HUFILE";
my @HuGene = <HUGENE_FILE>;
 for ($i=0;$i<@HuGene;$i++){
     chomp $HuGene[$i];
     #print "$HuGene[$i]";
     #my @motif_elements=split("\t", $All_TF_motif[$i]);
    
}
close HUGENE_FILE;
############################################################################################################################################

open (U133A_FILE, $U133AFILE) or die "cannot open $U133AFILE";
my @U133A = <U133A_FILE>;
 for ($i=0;$i<@U133A;$i++){
     chomp $U133A[$i];
}
close U133A_FILE;
############################################################################################################################################
my $previousID="";
for ($i=$loopstart; $i<$loopend; $i++){
    my @U133A_rowElement=split("\t",$U133A[$i]);
    my $tmp_U133AgeneID=$U133A_rowElement[0];
    my $tmp_U133AgeneName=$U133A_rowElement[1];
    my @tmp=split("[pq]",$U133A_rowElement[2]);
    my $tmp_U133AgeneLocation=$tmp[0];
    #print "hi!";
    #print "$tmp_U133AgeneName\t$tmp_U133AgeneLocation\t";
    for ($j=1; $j<@HuGene; $j++){
        my @HuGene_rowElement=split("\t",$HuGene[$j]);
        my $tmp_HuGene_geneID=$HuGene_rowElement[0];
        my $tmp_HuGene_geneName=$HuGene_rowElement[1];
        my $tmp_HuGene_geneLocation=$HuGene_rowElement[3];
        #print "$tmp_HuGene_geneName\t$tmp_HuGene_geneLocation\n";
        if (($tmp_U133AgeneName!~m/---/) && ($tmp_HuGene_geneName!~ m/---/) && ($tmp_HuGene_geneLocation =~m/^$tmp_U133AgeneLocation$/) && ($previousID !~m/$tmp_HuGene_geneID/)){
            $previousID=$tmp_HuGene_geneID;
            if (($tmp_HuGene_geneName =~ m/^$tmp_U133AgeneName\s/) | ($tmp_HuGene_geneName =~ m/\s$tmp_U133AgeneName\s/) | ($tmp_HuGene_geneName =~ m/\s$tmp_U133AgeneName$/)){
                print "$tmp_U133AgeneID\t$tmp_U133AgeneName\t$tmp_U133AgeneLocation\t$tmp_HuGene_geneID\t$tmp_HuGene_geneName\t$tmp_HuGene_geneLocation\n";
            }
        }
    }
}
exit;

############################################################################################################################################

open (TFLIST_FILE, $TFlistFILE) or die "cannot open $TFlistFILE";
my @TFlist = <TFLIST_FILE>;
for ($i=1; $i<@TFlist;$i++){
    chomp $TFlist[$i];
    my @TFelements=split("\t", $TFlist[$i]);
    for ($j=1; $j<@All_TF_motif; $j++){
        chomp $All_TF_motif[$j];
        my @motif_elements=split("\t", $All_TF_motif[$j]);
        if ($motif_elements[0] =~ m/^$TFelements[0]$/){
            my @motif_elements=split("\t", $All_TF_motif[$j]);
            #print "$motif_elements[0]\n";
            print "$TFelements[0]\t$TFelements[1]\t$TFelements[2]\t$motif_elements[1]\n";
        }

    }
}


############################################################################################################################################



exit;
