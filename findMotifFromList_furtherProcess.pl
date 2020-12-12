#!/usr/bin/perl -w
#use strict;
# this is the further process after findMotifFromList. 
# You can get idea whether TFs are up or down regulated, and what are the group of up/down-regulated target

# usage: findMotifFromList_furtherProcess.pl <differential gene list> <# of the fold-change column> <MotifTarget_result file> 

# example: findMotif.pl SBRCTvsRest_1FC005P_1047genes.txt [CG][CA]GGAA[GA] Y N
# example: findMotifFromList.pl SBRCT_TF_motifList.txt SBRCTvsRest_1FC005P_1047genes.txt Y N

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed

use 5.010;
use Cwd;

my $genelist_file = shift;
my $column_FoldChange=shift;
my $MotifTargetFile=shift;

my @genelist=();
my @AoH=();
#my @upRegulatedHitElements=();
#my @upRegulatedHitElements_values=();
#my @downRegulatedHitElements=();
#my @downRegulatedHitElements_values=();
my %hash=();

open (DIFFFILE, $genelist_file) or die "cannot open file $genelist_file";
@genelist = <DIFFFILE>;
for ($i=0;$i<@genelist;$i++){
    chomp $genelist[$i];
    my @elements=split ("\t",$genelist[$i]);
    my $key=$elements[0];
    my $local_geneID=$elements[1];
    
    my $array = [];    #create new anonymous array ref
    push (@$array, $elements[$column_FoldChange-1]);
    $hash{$key} = $array;   # add
    $hash{$local_geneID} = $array;   # add
}
################################################################################################

open (MOTIFFILE, $MotifTargetFile) or die "cannot open file $MotifTargetFile";
@motiflist = <MOTIFFILE>;
chomp $motiflist[0];
my @header=split("\t", $motiflist[0]);
push(@header, "TF_foldChange","Num_upTargets", "avg_upTargets_foldChange", "upTargets", "Num_downTargets", "avg_downTarget_foldChange", "downTargets");
my $header=join ("\t",@header);
print "$header\n";

for ($i=1;$i<@motiflist;$i++){
    chomp $motiflist[$i];
    #print "$motiflist[$i]\n";
    my @elements=split ("\t",$motiflist[$i]);
    if ($elements[6]){  #make sure there is hitted genes
        my $all_hitBlock=$elements[6];
        my @hit_element=split("[:#]", $all_hitBlock);
        my @upRegulatedHitElements=();
        my @upRegulatedHitElements_values=();
        my @downRegulatedHitElements=();
        my @downRegulatedHitElements_values=();

        for ($gene=1; $gene<@hit_element; $gene++){
            #print "$hit_element[$gene]\t";
            if (${$hash{$hit_element[$gene]}}[0]>0){
                #print "$hit_element[$gene]\t ${$hash{$hit_element[$gene]}}[0]\n";         
                push (@upRegulatedHitElements, $hit_element[$gene]);
                push (@upRegulatedHitElements_values, ${$hash{$hit_element[$gene]}}[0]);
            }
            if (${$hash{$hit_element[$gene]}}[0]<0){
                #print "$hit_element[$gene]\t ${$hash{$hit_element[$gene]}}[0]\n";         
                push (@downRegulatedHitElements, $hit_element[$gene]);
                push (@downRegulatedHitElements_values, ${$hash{$hit_element[$gene]}}[0]);
            }
            $gene++;
        }
        push (@elements, ${$hash{$elements[1]}}[0], scalar @upRegulatedHitElements, mean(@upRegulatedHitElements_values), join ("#", @upRegulatedHitElements), scalar @downRegulatedHitElements, mean(@downRegulatedHitElements_values), join ("#", @downRegulatedHitElements)  );        
    }
    
    $elements=join ("\t", @elements);        
    print "$elements\n";
    
}


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
exit;

################################################################################################
#HoA
#the way to access the data
#print "@{$hash{'SERPINI1'}}\n";
#print "@{$hash{'205352_at'}}\n";
#print "${$hash{'SERPINI1'}}[0]\n";

# print "Hash content\n";
# foreach $k (keys %hash) {
#    foreach (@{$hash{$k}}) {
#       print " $k : $_";
#    }
#    print "\n";
# }
################################################################################################
#AoH
# open (DIFFFILE, $genelist_file) or die "cannot open file $genelist_file";
# @genelist = <DIFFFILE>;
# for ($i=0;$i<@genelist;$i++){
#     $rec = {};
#     chomp $genelist[$i];
#     my @elements=split ("\t",$genelist[$i]);
#     my $key=$elements[0];
#     my $local_geneID=$elements[1];
#     $rec->{$key} = $elements[$column_FoldChange-1];
#     $rec->{$local_geneID} = $elements[$column_FoldChange-1];
#     push @AoH, $rec;
# }

# for $href ( @AoH ) {
#     for $role ( keys %$href ) {
#          print "$role=$href->{$role}\n";
#     }
#     print "=================\n";
# }

# for $i ( 0 .. $#AoH ) {
#     print "$i is { ";
#     for $role ( keys %{ $AoH[$i] } ) {
#          print "$role=$AoH[$i]{$role} ";
#     }
#     print "}\n";
# }
################################################################################################


