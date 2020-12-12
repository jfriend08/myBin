#!/usr/bin/perl -w
use 5.010;
use Cwd;

my $file = shift;
my @array=();

open (FILE, $file) or die "cannot open file $file";
    @Interesting_results = <FILE>;
close FILE;

for ($i=0; $i<@Interesting_results; $i++){
    chomp $Interesting_results[$i];
    @elements=split("\t", $Interesting_results[$i]);

    if ($elements[1] =~ m/FOXP2/){
        @targetedGenes=split("#", $elements[6]);
        for ($j=0; $j<@targetedGenes; $j++){
            @Genes=split(":", $targetedGenes[$j]);
            print "$Genes[0]\n";
            #push (@array,$Genes[0]);
        }
        
    }
}


#print join("\n", uniq(@array)), "\n";


sub uniq {
    return keys %{{ map { $_ => 1 } @_ }};
}

#/KIT|PROM1|FOXP1|FOXP2|FOXP4|ETV1/ 
