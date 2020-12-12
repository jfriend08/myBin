#!/usr/bin/perl -w
#use strict;
# this is the further process for attaching methylation-matching results to diffGenelist
# usage: findMotifFromList_addMatchInfo2genelist.pl <differential gene list> <MatchedList.txt1_local> <MatchedList.txt2_global1> <MatchedList.txt3_global2>

# example: findMotifFromList_addMatchInfo2genelist.pl PEDvsAllOthers_1FC2FC01Padjust_1041genes.txt SDHBnegvsGISTKITandSDHBpos14061_on_PEDvsAllOthers1041genes_MatchedList.txt SDHBnegvsASandSBRCT14966_on_PEDvsAllOthers1041genes_MatchedList.txt SDHBpos_AKITvsASandSBRCT4845_on_PEDvsAllOthers1041genes_MatchedList.txt> PEDvsAllOthers1041_MatchedInfoAdd.txt

use 5.010;
use Cwd;

my $genelist_file = shift;
my $Local_matchList=shift;
my $Global_matchList1=shift;
my $Global_matchList2=shift;

my @genelist=();
my %geneList_hash=();
my @MatchList1=();
my %MatchList1_hash=();
my @MatchList2=();
my %MatchList2_hash=();
my @MatchList3=();
my %MatchList3_hash=();

################################################################################################
open (DIFFFILE, $genelist_file) or die "cannot open file $genelist_file";
@genelist = <DIFFFILE>;
close DIFFFILE;
for ($i=0;$i<@genelist;$i++){
    chomp $genelist[$i];
    my @elements=split ("\t",$genelist[$i]);
    my $key=$elements[1];
    $geneList_hash{$key}=$genelist[$i];    
}

################################################################################################
open (MATCH1, $Local_matchList) or die "cannot open file $Local_matchList";
@MatchList1 = <MATCH1>;
close MATCH1;
for ($i=1;$i<@MatchList1;$i++){
    chomp $MatchList1[$i];
    my @elements=split ("\t",$MatchList1[$i]);
    my $key=$elements[0];
    $MatchList1_hash{$key}=$MatchList1[$i];    
    # if ($i==@MatchList1-1){
    #     print "$Local_matchList: $i\n";
    # }
}

################################################################################################
open (MATCH2, $Global_matchList1) or die "cannot open file $Global_matchList1";
@MatchList2 = <MATCH2>;
close MATCH2;
for ($i=1;$i<@MatchList2;$i++){
    chomp $MatchList2[$i];
    my @elements=split ("\t",$MatchList2[$i]);
    my $key=$elements[0];
    $MatchList2_hash{$key}=$MatchList2[$i];    
    # if ($i==@MatchList2-1){
    #     print "$Global_matchList1: $i\n";
    # }
}

################################################################################################
open (MATCH3, $Global_matchList2) or die "cannot open file $Global_matchList2";
@MatchList3 = <MATCH3>;
close MATCH3;
for ($i=1;$i<@MatchList3;$i++){
    chomp $MatchList3[$i];
    my @elements=split ("\t",$MatchList3[$i]);
    my $key=$elements[0];
    $MatchList3_hash{$key}=$MatchList3[$i];    
    # if ($i==@MatchList3-1){
    #     print "$Global_matchList2: $i\n";
    # }
}
################################################################################################
for my $geneList_key (keys %geneList_hash){
    ########## for MatchList1 ##########
    if ($MatchList1_hash{$geneList_key}){
        my @tmp_array=split("\t",$MatchList1_hash{$geneList_key});
        my @all_FCelements=split("[|]",$tmp_array[8]);
        shift @all_FCelements;
        $geneList_hash{$geneList_key}=join ("\t", $geneList_hash{$geneList_key}, mean(@all_FCelements));
    }
    else{
        $geneList_hash{$geneList_key}=join ("\t", $geneList_hash{$geneList_key}, 0);
    }
    ########## for MatchList2 ##########
    if ($MatchList2_hash{$geneList_key}){
        my @tmp_array=split("\t",$MatchList2_hash{$geneList_key});
        my @all_FCelements=split("[|]",$tmp_array[8]);
        shift @all_FCelements;
        $geneList_hash{$geneList_key}=join ("\t", $geneList_hash{$geneList_key}, mean(@all_FCelements));
    }
    else{
        $geneList_hash{$geneList_key}=join ("\t", $geneList_hash{$geneList_key}, 0);
    }
    ########## for MatchList3 ##########
    if ($MatchList3_hash{$geneList_key}){
        my @tmp_array=split("\t",$MatchList3_hash{$geneList_key});
        my @all_FCelements=split("[|]",$tmp_array[8]);
        shift @all_FCelements;
        $geneList_hash{$geneList_key}=join ("\t", $geneList_hash{$geneList_key}, mean(@all_FCelements));

    }
    else{
        $geneList_hash{$geneList_key}=join ("\t", $geneList_hash{$geneList_key}, 0);
    }
}
################################################################################################

for my $geneList_key (keys %geneList_hash){
    print "$geneList_hash{$geneList_key}\n";
}

################################################################################################
sub mean {
    my @array = @_; # save the array passed to this function
    my $sum=0; # create a variable to hold the sum of the array's values
    foreach (@array) { $sum += $_; } # add each element of the array 
    # to the sum
    if (@array==0){
        return "NA";
    }
    else{
        return $sum/@array; # divide sum by the number of elements in the
        # array to find the mean
    }    
}

