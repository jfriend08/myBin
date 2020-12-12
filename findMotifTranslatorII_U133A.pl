#!/usr/bin/perl -w

# usage: findMotifTranslatorII.pl <differential gene list>
# example: findMotifTranslatorII.pl EwingvsRest_2FC005P_1809genes.tx

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed

use 5.010;
use Cwd;
#use List::MoreUtils qw(firstidx);

my $genelist = shift;
print "genelist is: $genelist\n";
my $annoDir="/aslab_scratch001/asboner_dat/PeterTest/test_Samples/MotifProject";
my $annot_file="fullHOCOMOCO2U133A.txt";

my @correct_TF=();
my %name2ID =();

open (GENELIST_FILE, $genelist) or die "cannot open $genelist";
my @genelist_file = <GENELIST_FILE>;
# for ($i=0;$i<@genelist_file;$i++){
#     chomp $genelist_file[$i];
#     my @genelist_elements=split("\t", $genelist_file[$i]);
#     if ($name2ID{$genelist_elements[1]}){
#         print "$name2ID{$genelist_elements[1]}\n";
#     }

# }
close GENELIST_FILE;

############################################################################################################################################
# read in the annotation list
my $pwd = getcwd;
chdir("$annoDir");
open (ANNO_FILE, $annot_file) or die "cannot open $annot_file";
my @Ho2U133A_file = <ANNO_FILE>;
for ($i=1; $i<@Ho2U133A_file;$i++){
    chomp $Ho2U133A_file[$i];
    #print "$Ho2U133A_file[$i]\n";
    my @elements=split("\t", $Ho2U133A_file[$i]);
    #print "@elements\n";
    if ($elements[1] && $elements[2]){
        $name2ID{"$elements[2]"}=join ("\t", $elements[0], $elements[1], $elements[2]);
    }
    
}
close ANNO_FILE;
chdir($pwd);
# print "move to dir: $pwd\n";

# for my $key (keys %name2ID){
#     my $value = $name2ID{$key};
#     print "$key\t$value\n";
# }
# exit;
############################################################################################################################################

for ($i=0;$i<@genelist_file;$i++){
    chomp $genelist_file[$i];
    my @genelist_elements=split("\t", $genelist_file[$i]);
    #print "$genelist_elements[1]\n";
    if ($name2ID{$genelist_elements[1]}){
        print "$name2ID{$genelist_elements[1]}\n";
    }

}

exit;

############################################################################################################################################


############################################################################################################################################
# my $pwd = getcwd;
# chdir("/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc");
# #my @header=0;
# open (IDNAME, "SEF22_geneExpr_Info.txt") or die "cannot open IDNAME file";
# my @tmp_name2ID = <IDNAME>;
# for ($i=0; $i<@tmp_name2ID; $i++){
#     chomp $tmp_name2ID[$i];
#     $name2ID[$i]=$tmp_name2ID[$i]
# }
# chdir($pwd);
# ############################################################################################################################################
# print "HOCOMOCO_TFname\tUCSC_name\tUCSC_ID\n";
# for ($i=0; $i<@correct_TF; $i++){
#     #print "$correct_TF[$i]\n";
#     for ($j=0; $j<@name2ID; $j++){
#         my @test =split("\t", $name2ID[$j]);
#         chomp @test ;
#         if ($test[1] =~ m/^$correct_TF[$i]$/ || $test[1] =~ m/^$correct_TF[$i]\|/ || $test[1] =~ m/\|correct_TF[$i]$/){            
#             $correct_TF[$i]=join ("\t",$correct_TF[$i], $test[1], $test[0]);
#             #print "$correct_TF[$i]\t$test[1]\t$test[0]\n";
#         }        
#     }    
# }

# for ($i=0; $i<@correct_TF; $i++){
#     print "$correct_TF[$i]\n";
# }



