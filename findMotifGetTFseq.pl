#!/usr/bin/perl -w

# usage: findMotifTranslatorII.pl <TF list>
# example: findMotifGetTFseq.pl diffTF_from542list.txt > diffTF_from542list_bindingMotif.txt

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed


####
# findMotifGetTFseq.pl Ewing_TFs.txt > output
# less Ewing_TFs.txt:

# genelist is: EwingvsRest_2FC005P_1809genes.txt
# NR0B1   NR0B1   uc004dcf.4
# PO3F2   POU3F2  uc003ppe.3

# less output:
# JUN	JUN	uc001cze.3	.[AG]TGAGTCA
# JUN	JUN	uc001cze.3	[AC]TGAGTCA[CT]
###

use 5.010;
use Cwd;

my $TFlistFILE = shift;
#my $curr_pwd= ""
#my $All_TF_motifFILE = shift;

my $annoDir="/aslab_scratch001/asboner_dat/PeterTest/Annotation";
$All_TF_motifFILE="fullAll_TF_bindingMotif_concised.txt";

my @correct_TF=();
my %name2ID =();



############################################################################################################################################

my $pwd = getcwd;
chdir("$annoDir");
open (ALLTFMOTIF_FILE, $All_TF_motifFILE) or die "cannot open $All_TF_motifFILE";
my @All_TF_motif = <ALLTFMOTIF_FILE>;
close ALLTFMOTIF_FILE;
# for ($i=0;$i<@All_TF_motif;$i++){
#     chomp $All_TF_motif[$i];
#     my @motif_elements=split("\t", $All_TF_motif[$i]);
    
# }

chdir("$pwd");

############################################################################################################################################
open (TFLIST_FILE, $TFlistFILE) or die "cannot open $TFlistFILE";
my @TFlist = <TFLIST_FILE>;
close TFLIST_FILE;
for ($i=1; $i<@TFlist;$i++){
    chomp $TFlist[$i];
    my @TFelements=split("\t", $TFlist[$i]);
    for ($j=1; $j<@All_TF_motif; $j++){
        chomp $All_TF_motif[$j];
        my @motif_elements=split("\t", $All_TF_motif[$j]);
        if ($motif_elements[0] =~ m/^$TFelements[0]$/){
            print "$TFelements[0]\t$TFelements[1]\t$TFelements[2]\t$motif_elements[1]\n";
        }

    }
}

############################################################################################################################################





exit;
