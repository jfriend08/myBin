#!/usr/bin/perl -w
use 5.010;
use Cwd;

my $file=shift;
my %AnnoFile=();
my %TrueFalse=();

#################################################################################

open (FILE, $file) or die "cannot open $file";
my @tmp_file = <FILE>;
close FILE;
for ($i=0; $i<@tmp_file; $i++){
    chomp $tmp_file[$i];
    my @everyRwoElements=split("\t",$tmp_file[$i]);
    $TrueFalse{"$everyRwoElements[0]"} = "$everyRwoElements[1]";

    # #print "$everyRwoElements[0]\$everyRwoElements[1]\n";
    # if ($AnnoFile{$everyRwoElements[0]}){
    #     #print "$AnnoFile{$everyRwoElements[0]}\n";
    #     print "$everyRwoElements[0]\t$AnnoFile{$everyRwoElements[0]}\t$everyRwoElements[1]\n";
    # }
}

#################################################################################
#making hash from annotation file
my $pwd = getcwd;
chdir("/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc");
open (IDNAME, "SEF22_geneExpr_Info.txt") or die "cannot open IDNAME file";
my @tmp_name2ID = <IDNAME>;
close IDNAME;
for ($i=0; $i<@tmp_name2ID; $i++){
    chomp $tmp_name2ID[$i];
    my @everyRwoElements=split("\t",$tmp_name2ID[$i]);
    if ( ($TrueFalse{$everyRwoElements[1]}) && ($TrueFalse{$everyRwoElements[1]}>0) ){
        print "$everyRwoElements[0]\t$everyRwoElements[1]\tTRUE\tFALSE\n";

    }
    elsif ( ($TrueFalse{$everyRwoElements[1]}) && ($TrueFalse{$everyRwoElements[1]}<0) ){
        print "$everyRwoElements[0]\t$everyRwoElements[1]\tFALSE\tTRUE\n";

    }
    else{
        print "$everyRwoElements[0]\t$everyRwoElements[1]\tFALSE\tFALSE\n";

    }



    # $AnnoFile{"$everyRwoElements[1]"} = "$everyRwoElements[0]" ;
}
chdir($pwd);

#################################################################################

