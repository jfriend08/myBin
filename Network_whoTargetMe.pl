#!/usr/bin/perl -w
use 5.010;
use Cwd;

my $file = shift;

open (FILE, $file) or die "cannot open file $file";
    @Interesting_results = <FILE>;
close FILE;

for ($i=0; $i<@Interesting_results; $i++){
    chomp $Interesting_results[$i];
    if ($Interesting_results[$i] =~ m/PROM1/){
        @elements=split("\t", $Interesting_results[$i]);
        print "$elements[1]\n";
        
    }

}



#/KIT|PROM1|FOXP1|FOXP2|FOXP4|ETV1/ 
