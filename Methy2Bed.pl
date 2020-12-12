#!/usr/bin/perl -w

#   this is the code transforming methylation probe list data into bed format for each of the probes
#   the output of this code will sorted Bed. Sorted by chromosome first, then location
#   usage:      Methy2Bed.pl <probelist.txt> <column of chromosome> <column of location> <column of probeID> <interval/2 to plus at the front and end of probes>
#   example:    Methy2Bed.pl SDHBnegvsASandSBRCT_2FC1FC0.01Padj_14966_probelist.txt 2 3 1 50 >test.txt

use 5.010;
use Cwd;

my $file2edit = shift;
my $chr_column= shift;
my $position_column= shift;
my $id_column= shift;
my $interval=shift;

my @File2edit= ();
my %collectArray=();

$chr_column=$chr_column-1;
$position_column= $position_column-1;
$id_column= $id_column-1;

open (ANNOFILE, $file2edit) or die "cannot open file $file2edit";
    @File2edit = <ANNOFILE>;
close ANNOFILE;

for ($i=0; $i<@File2edit; $i++){
    chomp $File2edit[$i];
    my @file_elements=split("\t", $File2edit[$i]);
    #print "$file_elements[$chr_column]\t$file_elements[$position_column]\t$file_elements[$id_column]\n";
    my $position_start=$file_elements[$position_column]-$interval/2;
    my $position_end=$file_elements[$position_column]+$interval/2;
    #print "$position_start $position_end  $file_elements[$position_column]\n";
    my $chromosome=$file_elements[$chr_column];
    #my $chromosome="chr".$file_elements[$chr_column];
    #print "$chromosome\t$position_start\t$position_end\t$file_elements[$id_column]\n";
    push (@{$collectArray{"key"}}, ["$chromosome","$position_start","$position_end","$file_elements[$id_column]"]);    
}

for my $key (keys %collectArray){
    my @value = @{$collectArray{$key}};
    @value = sort {$a->[0] <=> $b->[0]|| $a->[1] <=> $b->[1]} @value;
    for $aref (@value){
        my $chromosomeII="chr".@$aref[0];
        print "$chromosomeII\t@$aref[1]\t@$aref[2]\t@$aref[3]\t@$aref[3]\n";
    }
}

#for my $key (keys %matchSeq_list){
#for my $key (keys %FJR){
#    my $value = $matchSeq_list{$key};
##    my $value2 = $matchSeq_list2{$key};
#    print "$key\n";
#    for $aref (@{$FJR{$key}}){
        #print "$key\t@$aref\n";
    #}
##    print "$key\t$value2\n";
#}
