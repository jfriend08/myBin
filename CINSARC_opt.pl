#!/usr/bin/perl -w
use 5.010;
use Cwd;
# use Cwd;
# my $directory = shift;
# my $samFile = shift;
# my $sortedBamFile = shift;
# my $gfrFile = shift;
# my @transcript1=0;
# my @transcript2=0;
# my $match_string='';  #to store few sequence at the fusion junction
# my %matchSeq_list=(); #to store few sequence at the fusion junction
# my %Location1=();
# my %Location2=();
my $file1="CINSARC_67list.txt";
my $file2="HuGene-1_0-st-v1.na33.2.hg19.probeset.csv";
my @confinedAnno=(); 

open (LISTFILE, $file1) or die "cannot open file: $file1";
@listfile = <LISTFILE>;
close LISTFILE;

open (ANNOFILE, $file2) or die "cannot open file: $file2";
@annofile = <ANNOFILE>;
close ANNOFILE;
for ($i=0; $i<@annofile; $i++){
	chomp $annofile[$i];
	my @test= split(",", $annofile[$i]);
	$confinedAnno[$i]=join("\t",$test[0],$test[6],$test[9]);
}

$filename1 = "CINSARC2HuGene.txt";
open (OUT1, ">$filename1") or die "cannot open $filename1: $!";
print OUT1 "CINSARC_gene\tprobeset_id\ttranscript_cluster_id\tgene_assignment\n";
for ($i=0; $i<@listfile; $i++){
    my $tmp_store= 0;
    chomp $listfile[$i];
    my @test=split (/ +/,$listfile[$i]); #means one or more spaces       
    for ($j=0; $j<@confinedAnno; $j++){
    	if ($confinedAnno[$j] =~ m/\s$test[0]\s/){
    		my @test_anno=split ("\t", $confinedAnno[$j]);    	
    		if ($tmp_store !~ /$test_anno[1]/){    		
    			$tmp_store=$test_anno[1];
    			my $tmp1=substr $test_anno[0], 1, -1;
    			my $tmp2=substr $test_anno[1], 1, -1;
    			my $tmp3=substr $test_anno[2], 1, -1;
    			print OUT1 "$test[0]\t$tmp1\t$tmp2\t$tmp3\n";
    		}
    		
    	}
    }
}
close OUT1;










