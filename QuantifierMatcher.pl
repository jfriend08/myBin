#!/usr/bin/perl -w
# usage: QuantifierMatcher.pl <SDHBnegvsASandSBRCT_ucscGenes_Info.bed>
# example: QuantifierMatcher.pl SDHBnegvsASandSBRCT_ucscGenes_Info.bed

#Note: When doing Methylation enrichment, the interval file and geneID in the ucscGenes_Info.bed may not be the sample as the geneExpr file from mrfQuantifier
#Note: So this is the code to do the matching so we can use the matched ID extract the gene expression

use 5.010;
use Cwd;

my $ucscGenes_Info_bed_file=shift;
my $quantifier_dir="/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/geneExpr";
my $quantifier_file="SI6126_geneExpr_Info.txt";

my @ucscGenes_Info_bed='';
my @quantifier='';
my $symbol='';

###############################################################

if (!$ucscGenes_Info_bed_file){
    print "+++++++++++++++++++++++++++++++++++++++++++++++++++++\nnot enought parameters";
    print "usage: QuantifierAddInfo_dev.pl <Exon Expression.txt>\n";
    print "example: QuantifierAddInfo_dev.pl OFT25_exonGeneExpr.txt > ./OFT25_exonGeneExpr_info.txt\n";
    print "this is based on the knownGeneAnnotationExonCompositeModel.interval and kgXref.txt at /home/asboner/annotations/human/hg19/ucsc/\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
    exit;
}

###############################################################

open (INFOBED, $ucscGenes_Info_bed_file) or die "cannot open file: $ucscGenes_Info_bed_file";
@ucscGenes_Info_bed = <INFOBED>;
close INFOBED;

###############################################################

my $pwd = getcwd;
chdir("$quantifier_dir");
open (QUANTIFIER, $quantifier_file) or die "cannot open file: $quantifier_file";
@quantifier = <QUANTIFIER>;
close QUANTIFIER;
chdir($pwd);

###############################################################

for ($i=0; $i<@ucscGenes_Info_bed; $i++){
	chomp $ucscGenes_Info_bed[$i];
	#print "$ucscGenes_Info_bed[$i]\n";
	my @Info_elements=split ("\t", $ucscGenes_Info_bed[$i]);
	my @Info_ID_elements=split("\t", $Info_elements[0]);
	$symbol=$Info_elements[1];
	for ($k=0; $k<@quantifier; $k++){
		my @quantifier_elements=split("\t",$quantifier[$k]);
		if ($Info_ID_elements[1]){
			if ( ($quantifier_elements[1] =~ m/^$symbol$/) | ($quantifier_elements[0]=~ m/$Info_ID_elements[0]/) |($quantifier_elements[0]=~ m/$Info_ID_elements[1]/) ){
				print "$ucscGenes_Info_bed[$i]\t$quantifier_elements[0]\n";
			}
		}
		else{
			if ( ($quantifier_elements[1] =~ m/^$symbol$/) | ($quantifier_elements[0]=~ m/$Info_ID_elements[0]/) ){
				print "$ucscGenes_Info_bed[$i]\t$quantifier_elements[0]\n";
			}
		}

		
			
	}
}


#| ($quantifier[$k] =~ $Info_ID_elements[$j]