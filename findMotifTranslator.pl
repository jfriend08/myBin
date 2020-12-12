#!/usr/bin/perl -w
#use strict;
# usage: findMotif.pl <name of differential gene list> <motif sequence> <want to run two_BitToFa for diff_list> <want to run two_BitToFa for all transcripts>
# example: findMotif.pl SBRCTvsRest_1FC005P_1047genes.txt [CG][CA]GGAA[GA] Y N

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed

use 5.010;
use Cwd;
#use List::MoreUtils qw(firstidx);

# my $genelist = shift;
# my $motif = shift;
# print "motif is: $motif\n";
# my $run_diff_twoBitToFa=shift;
# my $run_all_twoBitToFa=shift;
# my $diff_motifHits=0;
# my $numBiggerThanMotifHits=0;
# my $p_valueSelectTimes=2000;
# print "p_valueSelectTimes is: $p_valueSelectTimes\n\n";

my @correct_TF=();
# my @diffgenelist=0;
# my @matchList=0;
# my @super_fafile=0;
# my @super_allfafile=0;
# my @super_diffgenelist=0;
my @name2ID =();
############################################################################################################################################

open (TF_FILE, "HOCOMOCOv9_full_TRANSFAC.txt") or die "cannot open TF_FILE";
my @Tf_file = <TF_FILE>;
my @all_TF_names=grep (/BF/,@Tf_file);
#print scalar(@all_TF_names), "---all\n";
@all_TF_names=grep (/_HUMAN/,@all_TF_names);
for ($i=0;$i<@all_TF_names;$i++){
    chomp $all_TF_names[$i];
    my @tmp_allTFs=split (" ", $all_TF_names[$i]);  # file is seperated by one space
    my @test=split("_", $tmp_allTFs[1]);
    $correct_TF[$i]=$test[0];
    #print "$correct_TF[$i]\n";

}


############################################################################################################################################
my $pwd = getcwd;
chdir("/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc");
#my @header=0;
open (IDNAME, "SEF22_geneExpr_Info.txt") or die "cannot open IDNAME file";
my @tmp_name2ID = <IDNAME>;
for ($i=0; $i<@tmp_name2ID; $i++){
    chomp $tmp_name2ID[$i];
    $name2ID[$i]=$tmp_name2ID[$i];
}
chdir($pwd);
############################################################################################################################################
print "HOCOMOCO_TFname\tucsc_name\tucsc_ID\n";
for ($i=0; $i<@correct_TF; $i++){
    #print "$correct_TF[$i]\n";
    for ($j=0; $j<@name2ID; $j++){
        my @test =split("\t", $name2ID[$j]);
        chomp @test ;
        if ($test[1] =~ m/^$correct_TF[$i]$/ || $test[1] =~ m/^$correct_TF[$i]\|/ || $test[1] =~ m/\|correct_TF[$i]$/){            
            $correct_TF[$i]=join ("\t",$correct_TF[$i], $test[1], $test[0]);  #for ucsc
            #$correct_TF[$i]=join ("\t",$correct_TF[$i], $test[0], $test[1]);   #for U133A
            #print "$correct_TF[$i]\t$test[1]\t$test[0]\n";
        }        
    }    
}

for ($i=0; $i<@correct_TF; $i++){
    print "$correct_TF[$i]\n";
}



