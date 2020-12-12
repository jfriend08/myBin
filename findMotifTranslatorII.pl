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

my $annoDir="/aslab_scratch001/asboner_dat/PeterTest/Annotation";
my $annot_file="fullHOCOMOCO2ucscIII.txt";
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
my %name2ID =();
############################################################################################################################################
my $pwd = getcwd;
chdir("$annoDir");
open (HO2UCSC_FILE, "fullHOCOMOCO2ucscIII.txt") or die "cannot open HO2UCSC_FILE";
my @Ho2Ucsc_file = <HO2UCSC_FILE>;
for ($i=1; $i<@Ho2Ucsc_file;$i++){
    chomp $Ho2Ucsc_file[$i];
    my @elements=split("\t", $Ho2Ucsc_file[$i]);
    #print "$elements[0] $elements[1] $elements[2]\n";
    #print "$i\n";

    $name2ID{"$elements[2]"}=join ("\t", $elements[0], $elements[1], $elements[2]);
}

close HO2UCSC_FILE;
chdir($pwd);
# for my $key (keys %name2ID){
#     my $value = $name2ID{$key};
#     print "$value\n";
# }
 #exit;

############################################################################################################################################

open (GENELIST_FILE, $genelist) or die "cannot open $genelist";
my @genelist_file = <GENELIST_FILE>;
for ($i=0;$i<@genelist_file;$i++){
    chomp $genelist_file[$i];
    my @genelist_elements=split("\t", $genelist_file[$i]);
    if ($name2ID{$genelist_elements[1]}){
        print "$name2ID{$genelist_elements[1]}\n";
    }

}

exit;
############################################################################################################################################
print "hello1~\n";
$pwd = getcwd;
chdir("/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc");
#my @header=0;
open (IDNAME, "SEF22_geneExpr_Info.txt") or die "cannot open IDNAME file";
my @tmp_name2ID = <IDNAME>;
for ($i=0; $i<@tmp_name2ID; $i++){
    chomp $tmp_name2ID[$i];
    $name2ID[$i]=$tmp_name2ID[$i]
}
chdir($pwd);
############################################################################################################################################
print "hello2~\n";
for ($i=0; $i<@correct_TF; $i++){
    #print "$correct_TF[$i]\n";
    for ($j=0; $j<@name2ID; $j++){
        my @test =split("\t", $name2ID[$j]);
        chomp @test ;
        print "$test[3]\n";
        if ($test[1] =~ m/^$correct_TF[$i]$/ || $test[1] =~ m/^$correct_TF[$i]\|/ || $test[1] =~ m/\|correct_TF[$i]$/){            
            $correct_TF[$i]=join ("\t",$correct_TF[$i], $test[1], $test[0], $test[3]);
            print "$correct_TF[$i]\t$test[1]\t$test[0]\n";
        }        
    }    
}
print "hello3~\n";
for ($i=0; $i<@correct_TF; $i++){
    if ($i==0){
        print "HOCOMOCO_TFname\tUCSC_name\tUCSC_ID\n";
    }
    print "hi~ $correct_TF[$i]\n";
}



