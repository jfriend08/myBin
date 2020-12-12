#!/usr/bin/perl -w

# usage: findMotifWhoBindMeFromList_shortseq.pl <list of short seq>
# example: findMotifWhoBindMeFromList_shortseq.pl VGF_motifs.txt
# Input:    <name>  <short seq> <discription>
#           CHGA    ttcagcaccgcggacagcgcc   intron

use strict;
use 5.010;
use Cwd;

my $shortseqlist = shift;
my @all_motiffile=();
open (FILE, $shortseqlist) or die "cannot open file";
my @shortseqfile = <FILE>;
close FILE;

############# read in the annotation motif file #############
my $pwd = getcwd;
chdir("/aslab_scratch001/asboner_dat/PeterTest/Annotation");
open (MOTIFFILE, "fullAll_TF_bindingMotif_noDuplicate.txt") or die "cannot open anno file";
@all_motiffile = <MOTIFFILE>;
close MOTIFFILE;
chdir($pwd);
############################################################

for (my $i=1; $i<@all_motiffile; $i++){
    chomp $all_motiffile[$i];
    my @elm=split("\t", $all_motiffile[$i]);
    my $cur_name=$elm[0];
    my $cur_motif=$elm[1];   
    for (my $idx=0; $idx<@shortseqfile; $idx++) {
        my $longer="NNNNNNNNNNNNN".$shortseqfile[$idx]."NNNNNNNNNNNNN";
        if($longer =~ m/$cur_motif/ig){
            print "$cur_name\t$cur_motif\t$shortseqfile[$idx]\n" ;
        }
    }
}
