#!/usr/bin/perl -w

## this is the tool that input all maf files and output the mutations on IMPACT genes
## Difference between v1 and v2 is mainly the column for GMAF became different

use strict; # Tells Perl to show errors if any of our code is ambiguous
use warnings; # Tells Perl to show warnings on anything that might not work as expected
use IO::File; # A Perl module that can help us read/write files in a safe way
use Getopt::Long qw( GetOptions );
use Pod::Usage qw( pod2usage );
use File::Basename;
use Scalar::Util qw(looks_like_number);
use Cwd;

my $MAF_default=0.01;


unless( @ARGV and $ARGV[0] =~ m/^-/ ) {
    pod2usage( -verbose => 0, -message => "$0: Missing or invalid arguments!\n", -exitval => 2 );
}

my ( $help) = ( 0);
my ( $MU_REF, $mafdir, $outdir, $IMPACTstart, $IMPACTend);
$IMPACTstart=0; ## start from the first impact genes
$IMPACTend=340;	## start from the last impact genes
my @impact; ## to store the impact genes
my @maf_files; ## to store all the maf files
my $range_window=1000;

GetOptions(
    'help!' => \$help,
    'path-to-ref=s' => \$MU_REF,
    'input-maf-dir=s' => \$mafdir,
    'output-dir=s' => \$outdir,
    'impact-start=s' => \$IMPACTstart,
    'impact-end=s' => \$IMPACTend,
);


InputCorrect( $help, $mafdir, $outdir, $IMPACTstart, $IMPACTend);

@maf_files = glob("$mafdir/*.maf");
print "hi\n";
readIMPACT();
print scalar(@impact),"\n";

SearchPromisingMutationsII();






## check the whether input is correct. If not, exit.
sub InputCorrect{
	my ( $help, $mafdir, $outdir, $IMPACTstart, $IMPACTend)= @_;
	if ($help==1){
		print "\nUsage: perl $0 --help\n";
		print "perl $0 --input-maf-dir --output-dir [Options]\n\n";
		print
		"--help              		Print out the instructions\n",
		"--path-to-ref					Full path to ref file",
		"--input-maf-dir     		Directory to maf files, required\n",
		"--output-dir          		Output directory\n",
		"--impact-start          	The start of the IMPACT genes\n",
		"--impact-end				The end of the IMPACT genes\n\n";
		exit;
	}
	elsif (!defined($MU_REF)){print "ERROR: --path-to-ref required\n"; exit;}
	elsif (!defined($mafdir)){print "ERROR: --input-maf-dir required\n"; exit;}
	elsif (!defined($outdir)){print "ERROR: --output-dir required\n"; exit;}

	print "Inputs are correct, continue ...\n";
	print "$IMPACTstart\t$IMPACTend\n";
}

## read in the IMPACT list
sub readIMPACT{
	my $pwd = getcwd;
	# chdir("/aslab_scratch001/asboner_dat/PeterTest/Annotation/IMPACT");
	open (IMPACT, $MU_REF) or die "cannot open anno file";  # this is the annotation file that random.chromosome were excluded
	@impact = <IMPACT>;
	close IMPACT;
	chdir($pwd);
}

sub printArray(){
	my ( @array)= @_;
	foreach my $line(@array){
		print "$line\n";
	}
}




sub SearchPromisingMutations{

	foreach my $file (@maf_files){
		my $basename=basename($file);
		open (FILE1, $file) or die "cannot open $file: $!";
		my @cur_mafFile = <FILE1>;
		close FILE1;

		foreach my $line (@cur_mafFile){
			chomp $line;
			#new version
			my($Hugo_Symbol,$Entrez_Gene_Id,$Center,$NCBI_Build,$Chromosome,$Start_Position,$End_Position,$Strand,$Variant_Classification,
				$Variant_Type,$Reference_Allele,$Tumor_Seq_Allele1,$Tumor_Seq_Allele2,$dbSNP_RS,$dbSNP_Val_Status,$Tumor_Sample_Barcode,
				$Matched_Norm_Sample_Barcode,$Match_Norm_Seq_Allele1,$Match_Norm_Seq_Allele2,$Tumor_Validation_Allele1,$Tumor_Validation_Allele2,
				$Match_Norm_Validation_Allele1,$Match_Norm_Validation_Allele2,$Verification_Status,$Validation_Status,$Mutation_Status,
				$Sequencing_Phase,$Sequence_Source,$Validation_Method,$Score,$BAM_File,$Sequencer,$Tumor_Sample_UUID,$Matched_Norm_Sample_UUID,
				$HGVSc,$HGVSp,$HGVSp_Short,$Transcript_ID,$Exon_Number,$t_depth,$t_ref_count,$t_alt_count,$n_depth,$n_ref_count,$n_alt_count,
				$all_effects,$Allele,$Gene,$Feature,$Feature_type,$Consequence,$cDNA_position,$CDS_position,$Protein_position,$Amino_acids,
				$Codons,$Existing_variation,$ALLELE_NUM,$DISTANCE,$STRAND,$SYMBOL,$SYMBOL_SOURCE,$HGNC_ID,$BIOTYPE,$CANONICAL,$CCDS,$ENSP,$SWISSPROT,
				$TREMBL,$UNIPARC,$RefSeq,$SIFT,$PolyPhen,$EXON,$INTRON,$DOMAINS,$GMAF,$AFR_MAF,$AMR_MAF,$ASN_MAF,$EAS_MAF,$EUR_MAF,$SAS_MAF,$AA_MAF,
				$EA_MAF,$CLIN_SIG,$SOMATIC,$PUBMED,$MOTIF_NAME,$MOTIF_POS,$HIGH_INF_POS,$MOTIF_SCORE_CHANGE,$IMPACT,$PICK,$VARIANT_CLASS,$TSL,
				$HGVS_OFFSET,$PHENO) = split(/\t/, $line );
			#previous version
			# my($Hugo_Symbol,$Entrez_Gene_Id,$Center,$NCBI_Build,$Chromosome,$Start_Position,$End_Position,$Strand
			# 	, $Variant_Classification,$Variant_Type,$Reference_Allele,$Tumor_Seq_Allele1,$Tumor_Seq_Allele2,$dbSNP_RS,$dbSNP_Val_Status,$Tumor_Sample_Barcode
			# 	, $Matched_Norm_Sample_Barcode,$Match_Norm_Seq_Allele1,$Match_Norm_Seq_Allele2,$Tumor_Validation_Allele1, $Tumor_Validation_Allele2,$Match_Norm_Validation_Allele1
			# 	, $Match_Norm_Validation_Allele2, $Verification_Status, $Validation_Status,$Mutation_Status,$Sequencing_Phase,$Sequence_Source,$Validation_Method, $Score,$BAM_File
			# 	, $Sequencer,$Tumor_Sample_UUID,$Matched_Norm_Sample_UUID,$HGVS, $HGVSp, $Transcript_ID, $Exon_Number, $t_depth, $t_ref_count, $t_alt_count, $n_depth, $n_ref_count
			# 	, $n_alt_count, $all_effects, $Allele, $Gene, $Feature, $Feature_type, $Consequence, $cDNA_position, $CDS_position, $Protein_position, $Amino_acids, $Codons	
			# 	, $Existing_variation, $AA_MAF, $EA_MAF, $ALLELE_NUM, $RefSeq, $EXON, $INTRON, $MOTIF_NAME, $MOTIF_POS, $HIGH_INF_POS, $MOTIF_SCORE_CHANGE, $DISTANCE, $STRAND
			# 	, $CLIN_SIG, $CANONICAL, $SYMBOL, $SYMBOL_SOURCE, $SIFT, $PolyPhen, $GMAF, $BIOTYPE, $ENSP, $DOMAINS, $CCDS, $HGVSc, $HGVSp_II, $AFR_MAF, $AMR_MAF, $ASN_MAF, $EUR_MAF
			# 	, $PUBMED, $HGNC_ID, $SWISSPROT, $TREMBL, $UNIPARC, $SOMATIC, $HGVSp_Short) = split(/\t/, $line );

			for (my $i=$IMPACTstart; $i<$IMPACTend; $i++){
				## this means there is either novel or no rsID
				if ( !defined($dbSNP_RS) || $dbSNP_RS!~ m/rs[0-9]+/){
					## so start to perform the matching: 1. by genename 2. by interval
					for (my $i=$IMPACTstart; $i<$IMPACTend; $i++){
						print OUT1 "$line\n" if (performMatching($Hugo_Symbol, $SYMBOL, $Chromosome, $Start_Position, $impact[$i] )==1);
					}
				}
				## so there is a maf number
				elsif ( $dbSNP_RS=~ m/rs[0-9]+/ && MAFinRange($GMAF)==1){
					for (my $i=$IMPACTstart; $i<$IMPACTend; $i++){
						print OUT1 "$line\n" if (performMatching($Hugo_Symbol, $SYMBOL, $Chromosome, $Start_Position, $impact[$i] )==1);
					}
				}
			}
		}
		close OUT1;
	}
}

sub SearchPromisingMutationsII{
	for (my $i=$IMPACTstart; $i<$IMPACTend; $i++){
		my $headerPrinted = 0;
		my $line = $impact[$i];
		chomp $line; my @elm=split("\t", $line);
		my $name="SYMBOL=".$elm[3].";"; my $chr=$elm[4].":";
		my $filename=$elm[3]."_SUM.txt";
		print "$filename\n";
		open (OUT1, ">$outdir/$filename") or die "cannot open $filename: $!";

		foreach my $file (@maf_files){
			my $lineCount = 0;
			my %columnToIndexMap;
			my $basename=basename($file);
			open (FILE1, $file) or die "cannot open $file: $!";
			my @cur_mafFile = <FILE1>;
			close FILE1;

			# print "Processing: $basename\n";
			foreach my $line (@cur_mafFile){
				chomp $line;
				# print "$lineCount\n";
				if ($lineCount == 0) {
					#do nothing. it's version info
				}
				elsif ($lineCount == 1) {
					if ($headerPrinted == 0){
						print OUT1 "##$line\n";
						$headerPrinted = 1;
					}
					print OUT1 ">>$basename\n";

					my @columns = split(/\t/, $line );
					my $index = 0;
					for my $column (@columns){
						$columnToIndexMap{$column} = $index;
						$index += 1;
					}
				}
				else {
					#new version --> not limit to sameversion of maf
					my @lineElems = split(/\t/, $line );
					# #new version
					# my($Hugo_Symbol,$Entrez_Gene_Id,$Center,$NCBI_Build,$Chromosome,$Start_Position,$End_Position,$Strand,$Variant_Classification,
					# 	$Variant_Type,$Reference_Allele,$Tumor_Seq_Allele1,$Tumor_Seq_Allele2,$dbSNP_RS,$dbSNP_Val_Status,$Tumor_Sample_Barcode,
					# 	$Matched_Norm_Sample_Barcode,$Match_Norm_Seq_Allele1,$Match_Norm_Seq_Allele2,$Tumor_Validation_Allele1,$Tumor_Validation_Allele2,
					# 	$Match_Norm_Validation_Allele1,$Match_Norm_Validation_Allele2,$Verification_Status,$Validation_Status,$Mutation_Status,
					# 	$Sequencing_Phase,$Sequence_Source,$Validation_Method,$Score,$BAM_File,$Sequencer,$Tumor_Sample_UUID,$Matched_Norm_Sample_UUID,
					# 	$HGVSc,$HGVSp,$HGVSp_Short,$Transcript_ID,$Exon_Number,$t_depth,$t_ref_count,$t_alt_count,$n_depth,$n_ref_count,$n_alt_count,
					# 	$all_effects,$Allele,$Gene,$Feature,$Feature_type,$Consequence,$cDNA_position,$CDS_position,$Protein_position,$Amino_acids,
					# 	$Codons,$Existing_variation,$ALLELE_NUM,$DISTANCE,$STRAND,$SYMBOL,$SYMBOL_SOURCE,$HGNC_ID,$BIOTYPE,$CANONICAL,$CCDS,$ENSP,$SWISSPROT,
					# 	$TREMBL,$UNIPARC,$RefSeq,$SIFT,$PolyPhen,$EXON,$INTRON,$DOMAINS,$GMAF,$AFR_MAF,$AMR_MAF,$ASN_MAF,$EAS_MAF,$EUR_MAF,$SAS_MAF,$AA_MAF,
					# 	$EA_MAF,$CLIN_SIG,$SOMATIC,$PUBMED,$MOTIF_NAME,$MOTIF_POS,$HIGH_INF_POS,$MOTIF_SCORE_CHANGE,$IMPACT,$PICK,$VARIANT_CLASS,$TSL,
					# 	$HGVS_OFFSET,$PHENO) = split(/\t/, $line );

					#previous version
					# my($Hugo_Symbol,$Entrez_Gene_Id,$Center,$NCBI_Build,$Chromosome,$Start_Position,$End_Position,$Strand
					# 	, $Variant_Classification,$Variant_Type,$Reference_Allele,$Tumor_Seq_Allele1,$Tumor_Seq_Allele2,$dbSNP_RS,$dbSNP_Val_Status,$Tumor_Sample_Barcode
					# 	, $Matched_Norm_Sample_Barcode,$Match_Norm_Seq_Allele1,$Match_Norm_Seq_Allele2,$Tumor_Validation_Allele1, $Tumor_Validation_Allele2,$Match_Norm_Validation_Allele1
					# 	, $Match_Norm_Validation_Allele2, $Verification_Status, $Validation_Status,$Mutation_Status,$Sequencing_Phase,$Sequence_Source,$Validation_Method, $Score,$BAM_File
					# 	, $Sequencer,$Tumor_Sample_UUID,$Matched_Norm_Sample_UUID,$HGVS, $HGVSp, $Transcript_ID, $Exon_Number, $t_depth, $t_ref_count, $t_alt_count, $n_depth, $n_ref_count
					# 	, $n_alt_count, $all_effects, $Allele, $Gene, $Feature, $Feature_type, $Consequence, $cDNA_position, $CDS_position, $Protein_position, $Amino_acids, $Codons
					# 	, $Existing_variation, $AA_MAF, $EA_MAF, $ALLELE_NUM, $RefSeq, $EXON, $INTRON, $MOTIF_NAME, $MOTIF_POS, $HIGH_INF_POS, $MOTIF_SCORE_CHANGE, $DISTANCE, $STRAND
					# 	, $CLIN_SIG, $CANONICAL, $SYMBOL, $SYMBOL_SOURCE, $SIFT, $PolyPhen, $GMAF, $BIOTYPE, $ENSP, $DOMAINS, $CCDS, $HGVSc, $HGVSp_II, $AFR_MAF, $AMR_MAF, $ASN_MAF, $EUR_MAF
					# 	, $PUBMED, $HGNC_ID, $SWISSPROT, $TREMBL, $UNIPARC, $SOMATIC, $HGVSp_Short) = split(/\t/, $line );

					my $dbSNP_RS = $lineElems[$columnToIndexMap{"dbSNP_RS"}];
					my $GMAF = scalar @lineElems > 97 ?
										CalculateGMAF($lineElems[$columnToIndexMap{"ExAC_AF"}], $lineElems[$columnToIndexMap{"AF"}])
										: $lineElems[$columnToIndexMap{"GMAF"}];
					my $Hugo_Symbol = $lineElems[$columnToIndexMap{"Hugo_Symbol"}];
					my $SYMBOL = $lineElems[$columnToIndexMap{"SYMBOL"}];
					my $Chromosome = $lineElems[$columnToIndexMap{"Chromosome"}];
					my $Start_Position = $lineElems[$columnToIndexMap{"Start_Position"}];

					# print "$dbSNP_RS\t$GMAF\t$Hugo_Symbol\t$SYMBOL\t$Chromosome\t$Start_Position\n";
					if ( !defined($dbSNP_RS) || $dbSNP_RS !~ m/rs[0-9]+/){
						## so start to perform the matching: 1. by genename 2. by interval
						print OUT1  "$line\n" if (performMatching($Hugo_Symbol, $SYMBOL, $Chromosome, $Start_Position, $impact[$i] )==1);
					}
						## so there is a maf number,
					elsif ( $dbSNP_RS =~ m/rs[0-9]+/ && MAFinRange($GMAF)==1){
						print OUT1  "$line\n" if (performMatching($Hugo_Symbol, $SYMBOL, $Chromosome, $Start_Position, $impact[$i] )==1);
					}
				}
				$lineCount += 1;
			}
		}
		close OUT1;

	}
}

sub CalculateGMAF{
	#getting two source of allele frequency and calculate the average
	my($ExAC_AF, $AF) = @_;
	my $mafsum = 0;
	my $validCount = 0;

	if ($ExAC_AF) {
		$mafsum += $ExAC_AF;
		$validCount += 1;
	}

	if ($AF) {
		my @tmp_maf=split("[:,]", $AF);
		$mafsum += $tmp_maf[1];
		$validCount += 1;
	}
	return $validCount == 0 ? 0 : $mafsum/$validCount;
}

## if the GMAF is lower than MAF_default or there is just no GMAF, return 1. else return 0
sub MAFinRange{
	my $GMAF= shift;
	if ($GMAF){
		my @tmp_maf=split("[:,]", $GMAF);
		my $GMAF_val = 0;
		if (scalar @tmp_maf > 1) {
			$GMAF_val = sprintf("%f", $tmp_maf[1]);
		}
		else {
			$GMAF_val = sprintf("%f", $tmp_maf[0]);
		}
		return $GMAF_val<$MAF_default ? 1:0;
	}
	elsif (!$GMAF){
		return 1;
	}
}

## so start to perform the matching: 1. by genename 2. by interval. Return 1 if there is a match
sub performMatching{
	my($Hugo_Symbol, $SYMBOL, $Chromosome, $Start_Position, $impact )=@_;
	my ($idx, $impactGeneName1, $impactID,$impactGeneName2,$impactChr,$impactStrain,$impactStart,$impactEnd)=split(/\t/, $impact);

	# ## name matching --> this may be in accurate
	# if ( $Hugo_Symbol =~ m/^$impactGeneName1$/ || (defined($SYMBOL) && $SYMBOL =~ m/^$impactGeneName1$/) ) {
	# 	return 1 ;
	# }

	$Chromosome =~ s/chr|CHR|Chr//ig;
	$impactChr =~ s/chr|CHR|Chr//ig;

	## interval matching. Note: there is a range_window
	if ( defined($Chromosome) && $Chromosome=~m/^$impactChr$/ && $Start_Position >= $impactStart-$range_window && $Start_Position <= $impactEnd+$range_window ){
		return 1 ;
	}
	## nothing matched to genename or interval
	else {return 0;}

}





