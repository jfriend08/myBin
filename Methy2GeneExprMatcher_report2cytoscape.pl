#!/usr/bin/perl -w
#use strict;
# usage: Methy2GeneExprMatcher_report2cytoscape.pl <MatchedList>
# example: Methy2GeneExprMatcher_report2cytoscape.pl MatchedList5_forPEDvsAKIT542list.txt > MatchedList5_forPEDvsAKIT542list_2cytoscape.txt

# Note: this code is baed on the output data structure from Methy2GeneExprMatcher.pl

# ToDo: The 

use 5.010;
use Cwd;

my $MethyMatchedFile = shift;

open (MATCHFILE, $MethyMatchedFile) or die "cannot open file $MethyMatchedFile";
my @MethyMatchList = <MATCHFILE>;
close MATCHFILE;

print "Symbol\tmeanMethyLogFC\n";
for ($i=1;$i<@MethyMatchList;$i++){
    chomp $MethyMatchList[$i];
    my @tmp_MatchedElements=split ("\t",$MethyMatchList[$i]);
    my $current_geneSymbol=$tmp_MatchedElements[2];
    my $current_MatchedMethyFoldChangeList=$tmp_MatchedElements[8];
    my @current_All_MatchMethyFoldChanges=split ("[|]", $current_MatchedMethyFoldChangeList);
    shift @current_All_MatchMethyFoldChanges;
    my $Mean_MethyLogFC= mean(@current_All_MatchMethyFoldChanges);
    print "$current_geneSymbol\t$Mean_MethyLogFC\n";
}


sub mean {
    my @array = @_;
    my $sum=0;
    foreach (@array) { $sum += $_; }
    if (@array==0){
        return "NA";
    }
    else{
        return $sum/@array;
    }    
}


exit;



