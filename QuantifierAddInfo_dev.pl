#!/usr/bin/perl -w
# usage: QuantifierAddInfo_dev.pl <Exon Expression.txt>
# example: QuantifierAddInfo_dev.pl OFT25_exonGeneExpr.txt > ./OFT25_exonGeneExpr_info.txt

#Note: this is based on the knownGeneAnnotationExonCompositeModel.interval at /home/asboner/annotations/human/hg19/ucsc/
#Note: the exon info is based on the kgXref.txt file at the same directory of /home/asboner/annotations/human/hg19/ucsc/

#Todo: can be able to asign differernt kgXref.txt at different directory
#Todo: can recognize whether this is exon or gene expression automatically, and add the info

use 5.010;

my $expression_file=shift;
# my $kgXref_dir="/aslab_scratch001/asboner_dat/PeterTest/Annotation/transcripts";
my $kgXref_dir="/athena/sbonerlab/store/ys486/Annotation/transcripts";
my $kgXref_file="kgXref.txt";
my $ifExonExpr=0;
my $entrysize='';

my %kgXref_hash=();
my %matchedExon_hash=();
my $matchedSymbols='';

###############################################################

if (!$expression_file){
    print "+++++++++++++++++++++++++++++++++++++++++++++++++++++\nnot enought parameters\n";
    print "usage: QuantifierAddInfo_dev.pl <Exon Expression.txt>\n";
    print "example: QuantifierAddInfo_dev.pl OFT25_exonGeneExpr.txt > ./OFT25_exonGeneExpr_info.txt\n";
    print "this is based on the knownGeneAnnotationExonCompositeModel.interval and kgXref.txt at /home/asboner/annotations/human/hg19/ucsc/\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
    exit;
}

###############################################################

open (EXPRFILE, $expression_file) or die "cannot open file: $expression_file";
@expression = <EXPRFILE>;
$entrysize = @expression;
close EXPRFILE;

###############################################################

my $pwd = "getcwd";
chdir("$kgXref_dir");
open (KGFILE, $kgXref_file) or die "cannot open file: $kgXref_file";
@kgXref = <KGFILE>;
close KGFILE;
chdir($pwd);

###############################################################

for ($i=0; $i<@kgXref; $i++){
	chomp $kgXref[$i];
	my @rowkgXrefElements=split '\t', $kgXref[$i];
	my $kgXref_ID=$rowkgXrefElements[0];
	my $kgXref_Symbol=$rowkgXrefElements[4];
	my $kgXref_Title=$rowkgXrefElements[7];
	# print "$kgXref_ID ==> $kgXref_Symbol ==> $kgXref_Title\n";
	@{$kgXref_hash{$kgXref_ID}}=($kgXref_Symbol, $kgXref_Title);
}

###############################################################

if ($expression[0]=~m/_/){       # todo: add else function for quantifierAddInfo for gene expression
	$ifExonExpr=1;
	for ($i=0; $i<@expression; $i++){
		chomp $expression[$i];
		my $matchedSymbols='';
		my $matchedTitles='';
		my @rowElemtents=split "\t", $expression[$i];
		# print "@rowElemtents\n";
		my @tmp_allIDs=split '[\|_]', $rowElemtents[0];		
		my @tmp=split '_',$rowElemtents[0]; 
		my $expression_ID=$tmp[0];
		my $expression_exonnumber=join('', split('\.', $tmp_allIDs[-1]));
		my $expression_exprValue=$rowElemtents[1];
		my @intronInfo = split('\.', $tmp_allIDs[-1]);
		my $additionalInfo = $intronInfo[0];
		# print "$expression_ID\t$expression_exonnumber\t$expression_exprValue\n";
		for ($id_index=0; $id_index< @tmp_allIDs-1; $id_index++){
			if ($kgXref_hash{$tmp_allIDs[$id_index]}){
				if ($matchedSymbols !~ m/$matchedSymbols, ${$kgXref_hash{$tmp_allIDs[$id_index]}}[0]/){
					$matchedSymbols=join("|", $matchedSymbols, ${$kgXref_hash{$tmp_allIDs[$id_index]}}[0]);
					$matchedTitles=join("|", $matchedTitles, ${$kgXref_hash{$tmp_allIDs[$id_index]}}[1]);
				}
			}
		}
		push(@{$matchedExon_hash{$expression_ID}},join("\t", $rowElemtents[0], $matchedSymbols, $expression_exonnumber, $matchedTitles, $expression_exprValue, $additionalInfo));
	}
}

###############################################################

if ($ifExonExpr==1){
	print "this is exon expression\ntotal entry:$entrysize\n";
}

for my $key (keys %matchedExon_hash){
	my @values=@{$matchedExon_hash{$key}};
	for ($i=0; $i<@values; $i++){
		print "$values[$i]\n";
	}
}
















