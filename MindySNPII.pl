#!/usr/bin/perl -w

use 5.010;
use Cwd;
my %allMotifs=();

############################################################################################################################################

open (SNP_FILE, "AllSnpDatabase.hg19.TXDB.noutr.splic.ori.small.motif.txt") or die "cannot open HO2UCSC_FILE";
my @snp_file = <SNP_FILE>;
close SNP_FILE; 
for ($i=0; $i<@snp_file;$i++){
    chomp $snp_file[$i];
    my @elements=split("\t", $snp_file[$i]);
    #print "$elements[13]\n";
    my @tmp_motifs=split(",", $elements[13]);
    #print "@tmp_motifs\n";
    for ($j=0; $j<@tmp_motifs; $j++){
        #my @motif=split("_", $tmp_motifs[$j]);
        #print "$motif[0]\n";
        push (@{$allMotifs{$tmp_motifs[$j]}},join(":", $elements[0],$elements[12]),);
        
    }
}
for my $key (keys %allMotifs){
    #print "$key\t";
    my @value = @{$allMotifs{$key}};
    foreach $line (@value){
        my @element=split (":", $line);
        print "$key\t";
        print "$element[1]\n";
    }
    #print "\n";    
}

exit;
