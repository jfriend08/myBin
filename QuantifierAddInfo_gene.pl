#!/usr/bin/perl -w
# usage: QuantifierAddInfo_dev.pl <Exon Expression.txt>
# example: QuantifierAddInfo_dev.pl OFT25_exonGeneExpr.txt > ./OFT25_exonGeneExpr_info.txt

#Note: this is based on the knownGeneAnnotationExonCompositeModel.interval at /home/asboner/annotations/human/hg19/ucsc/
#Note: the exon info is based on the kgXref.txt file at the same directory of /home/asboner/annotations/human/hg19/ucsc/

#Todo: can be able to asign differernt kgXref.txt at different directory
#Todo: can recognize whether this is exon or gene expression automatically, and add the info

use 5.010;

my $expression_file=shift;
# my $anno_dir="/aslab_scratch001/asboner_dat/PeterTest/Annotation/QuantifierAddInfo/";
my $anno_dir="/athena/sbonerlab/store/ys486/Annotation/QuantifierAddInfo/";
my $anno_file="QuantifierAddInfo_gene.txt";

my %anno_hash=();
my @finalReport;

###############################################################

if (!$expression_file){
    print "+++++++++++++++++++++++++++++++++++++++++++++++++++++\nnot enought parameters\n";
    print "usage: QuantifierAddInfo_gene.pl <Gene Expression.txt>\n";
    print "example: QuantifierAddInfo_gene.pl ES220_pf_geneExpr.txt > ./ES220_pf_geneExpr_info.txt\n";
    print "this is based on the $anno_dir $anno_file\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
    exit;
}

###############################################################

open (EXPRFILE, $expression_file) or die "cannot open file: $expression_file";
@expression = <EXPRFILE>;
close EXPRFILE;

###############################################################

my $pwd = "getcwd";
chdir("$anno_dir");
open (KGFILE, $anno_file) or die "cannot open file: $anno_file";
@annos = <KGFILE>;
close KGFILE;
chdir($pwd);

###############################################################

for ($i=0; $i<@annos; $i++){
	chomp $annos[$i];
	my @rowElemtents=split '\t', $annos[$i];
	my $refId=$rowElemtents[0];
	my $geneName=$rowElemtents[1];
	my $strand=$rowElemtents[2];
	my $description=$rowElemtents[3];
	# print "$refId\t($geneName, $strand, $description)\n";
	@{$anno_hash{$refId}}=($refId, $geneName, $strand, $description);
}

###############################################################

for ($i=0; $i<@expression; $i++){
	chomp $expression[$i];
	my @rowElemtents=split "\t", $expression[$i];
	my $expressionRefId=$rowElemtents[0];
	my $expressionValue=$rowElemtents[1];
	my $matchedRefId = ${anno_hash{$expressionRefId}}[0];
	my $matchedGeneName = ${anno_hash{$expressionRefId}}[1];
	my $matchedStrand = ${anno_hash{$expressionRefId}}[2];
	my $matchedDescription = ${anno_hash{$expressionRefId}}[3];

	$str=join("\t", $matchedRefId, $matchedGeneName, $matchedStrand, $matchedDescription, $expressionValue);
	push(@finalReport, $str);
}

###############################################################

for ($i=0; $i<@finalReport; $i++){
	print "$finalReport[$i]\n";
}
















