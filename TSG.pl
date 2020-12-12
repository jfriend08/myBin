#!/usr/bin/perl -w
use 5.010;
use Cwd;

my $file = shift;

my @TSG_results=();
my %TSG_hash=();
# my $name_column= shift;
# my $geneExpr_column= shift;
# my $Methy1_column= shift;
# my $Methy2_column= shift;
# my $Methy3_column= shift;

# open (FILE, $file) or die "cannot open file $file";
#     @TSG = <FILE>;
# close FILE;

# for ($i=1; $i<@TSG; $i++){
#     chomp $TSG[$i];
#     my @elements=split("\t", $TSG[$i]);
#     print ">$elements[1]_$elements[2]\n$elements[9]\n";

# }



open (FILE, $file) or die "cannot open file $file";
    @TSG_results = <FILE>;
close FILE;

my $tmpMatchLength=0;
my $tmpName=();
#the blat reslute start from row 6
for ($i=5; $i<@TSG_results; $i++){
    chomp $TSG_results[$i];
    my @elements=split("\t", $TSG_results[$i]);
    my $matched_length=$elements[0];    
    my $strain=$elements[8];
    my $name=$elements[9];
    my $chr=$elements[13];
    my $start=$elements[15];
    my $end=$elements[16];
    my $seqlength=$elements[11]-$elements[10];
    
    if (!$TSG_hash{$name}){
        $tmpMatchLength=0;
    }

    if ($tmpMatchLength<$matched_length){
        $TSG_hash{$name}=join ("\t", $name, $chr, $strain, $start, $end);
        $tmpMatchLength=$matched_length;
    }
    

    
    # $tmpName=$name;
    
    # if ($tmp =~ m/$name/){

    # }
    
    # print "$matched_length\t$name\t$chr\t$start\t$end\t$seqlength\t$strain\n";

}


for my $key (keys %TSG_hash)
{
    print "$TSG_hash{$key}\n";
}

exit;




