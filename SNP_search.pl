#!/usr/bin/perl -w

## code was modified to collect sample names that if they have same location of SNP
## code was modified to save the filename with the threshold value

use strict; # Tells Perl to show errors if any of our code is ambiguous
use warnings; # Tells Perl to show warnings on anything that might not work as expected
use IO::File; # A Perl module that can help us read/write files in a safe way
use Getopt::Long qw( GetOptions );
use Pod::Usage qw( pod2usage );
use File::Basename;
use Scalar::Util qw(looks_like_number);

my $MAF_default=0.0001;

# Check for missing or crappy arguments
unless( @ARGV and $ARGV[0] =~ m/^-/ ) {
    pod2usage( -verbose => 0, -message => "$0: Missing or invalid arguments!\n", -exitval => 2 );
}

my ( $help) = ( 0);
my ( $mafdir, $geneName, $allEffectByGeneName, $genelist);
GetOptions(
    'help!' => \$help,    
    'input-maf-dir=s' => \$mafdir,
    'geneName=s' => \$geneName,    
    'genelist=s' => \$genelist,    
    'allEffectByGeneName=s' => \$allEffectByGeneName,
);


InputCorrect( $help, $mafdir, $geneName);
my @maf_files = glob("$mafdir/*.maf");


if (defined($geneName)) {SearchByGeneName($geneName, \@maf_files);}
elsif (defined($allEffectByGeneName)) {SearchAllEffects($allEffectByGeneName, \@maf_files);}
elsif (defined($genelist)) { open (FILE1, $genelist) or die "cannot open $genelist: $!"; my @everyGene = <FILE1>; close FILE1;
		foreach my $thisGene (@everyGene){chomp $thisGene; print "$thisGene\n"; SearchByGeneName($thisGene, \@maf_files);}	    
}




sub InputCorrect{
	my ( $help, $mafdir, $geneName)= @_;
	if ($help==1){
		print "\nUsage: perl $0 --help\n";
		print "perl $0 --input-maf-dir [Options]\n\n";
		print 
		"--help              		Print out the instructions\n",
		"--input-maf-dir     		Directory to maf files, required\n",
		"--geneName          		Searching by GeneName\n",
		"--geneList          		Searching by GeneList\n",
		"--allEffectByGeneName		Searching allEffects by GeneName\n\n";		
		exit;
	}
	elsif (!defined($mafdir)){print "ERROR: --input-maf-dir required\n"; exit;}
	
	print "Inputs are correct, continue ...\n";
}



sub SearchByGeneName{
	my ($geneName, $ref_maf_files)=@_;
	my @maf_files=@$ref_maf_files;		
	foreach my $file (@maf_files){
		my $basename=basename($file);
		print "$basename\n" ;
		open (FILE1, $file) or die "cannot open $file: $!";
		my @cur_mafFile = <FILE1>;
		close FILE1;
		
		foreach my $line (@cur_mafFile){
			my @elm=split(/\t/, $line );        		
			my($Hugo_Symbol,$Entrez_Gene_Id,$Center,$NCBI_Build,$Chromosome,$Start_Position,$End_Position,$Strand
				, $Variant_Classification,$Variant_Type,$Reference_Allele,$Tumor_Seq_Allele1,$Tumor_Seq_Allele2,$dbSNP_RS,$dbSNP_Val_Status,$Tumor_Sample_Barcode
				, $Matched_Norm_Sample_Barcode,$Match_Norm_Seq_Allele1,$Match_Norm_Seq_Allele2,$Tumor_Validation_Allele1, $Tumor_Validation_Allele2,$Match_Norm_Validation_Allele1
				, $Match_Norm_Validation_Allele2, $Verification_Status, $Validation_Status,$Mutation_Status,$Sequencing_Phase,$Sequence_Source,$Validation_Method, $Score,$BAM_File
				, $Sequencer,$Tumor_Sample_UUID,$Matched_Norm_Sample_UUID,$HGVS, $HGVSp, $Transcript_ID, $Exon_Number, $t_depth, $t_ref_count, $t_alt_count, $n_depth, $n_ref_count
				, $n_alt_count, $all_effects, $Allele, $Gene, $Feature, $Feature_type, $Consequence, $cDNA_position, $CDS_position, $Protein_position, $Amino_acids, $Codons	
				, $Existing_variation, $AA_MAF, $EA_MAF, $ALLELE_NUM, $RefSeq, $EXON, $INTRON, $MOTIF_NAME, $MOTIF_POS, $HIGH_INF_POS, $MOTIF_SCORE_CHANGE, $DISTANCE, $STRAND
				, $CLIN_SIG, $CANONICAL, $SYMBOL, $SYMBOL_SOURCE, $SIFT, $PolyPhen, $GMAF, $BIOTYPE, $ENSP, $DOMAINS, $CCDS, $HGVSc, $HGVSp_II, $AFR_MAF, $AMR_MAF, $ASN_MAF, $EUR_MAF
				, $PUBMED, $HGNC_ID, $SWISSPROT, $TREMBL, $UNIPARC, $SOMATIC, $HGVSp_Short) = split(/\t/, $line );  
			
			
			if ( ( !defined ($dbSNP_RS)||$dbSNP_RS !~ m/rs[0-9]+/) && defined($Hugo_Symbol) && $Hugo_Symbol =~ m/^$geneName$/ ){
				print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";
			}
			elsif ( ( !defined ($dbSNP_RS)||$dbSNP_RS !~ m/rs[0-9]+/) && defined($SYMBOL) && $SYMBOL =~ m/^$geneName$/){
				print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";
			}
			elsif ( ($dbSNP_RS) && ($dbSNP_RS =~ m/rs[0-9]+/) && defined($SYMBOL) && $SYMBOL =~ m/^$geneName$/){								
				if ($GMAF){
					my @tmp_maf=split(":", $GMAF); my $GMAF_val = sprintf("%f", $tmp_maf[1]);										
					if ($GMAF_val<$MAF_default){						
						print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";							
					}
				}
				elsif (!$GMAF) {					
					print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";							
				}				
			}
		}		
		print "\n\n";
	}	
}


sub SearchAllEffects{
	my ($geneName, $ref_maf_files)=@_;
	my @maf_files=@$ref_maf_files;		
	foreach my $file (@maf_files){
		my $basename=basename($file);
		print "$basename\n" ;
		open (FILE1, $file) or die "cannot open $file: $!";
		my @cur_mafFile = <FILE1>;
		close FILE1;
		
		foreach my $line (@cur_mafFile){
			my @elm=split(/\t/, $line );        		
			my($Hugo_Symbol,$Entrez_Gene_Id,$Center,$NCBI_Build,$Chromosome,$Start_Position,$End_Position,$Strand
				, $Variant_Classification,$Variant_Type,$Reference_Allele,$Tumor_Seq_Allele1,$Tumor_Seq_Allele2,$dbSNP_RS,$dbSNP_Val_Status,$Tumor_Sample_Barcode
				, $Matched_Norm_Sample_Barcode,$Match_Norm_Seq_Allele1,$Match_Norm_Seq_Allele2,$Tumor_Validation_Allele1, $Tumor_Validation_Allele2,$Match_Norm_Validation_Allele1
				, $Match_Norm_Validation_Allele2, $Verification_Status, $Validation_Status,$Mutation_Status,$Sequencing_Phase,$Sequence_Source,$Validation_Method, $Score,$BAM_File
				, $Sequencer,$Tumor_Sample_UUID,$Matched_Norm_Sample_UUID,$HGVS, $HGVSp, $Transcript_ID, $Exon_Number, $t_depth, $t_ref_count, $t_alt_count, $n_depth, $n_ref_count
				, $n_alt_count, $all_effects, $Allele, $Gene, $Feature, $Feature_type, $Consequence, $cDNA_position, $CDS_position, $Protein_position, $Amino_acids, $Codons	
				, $Existing_variation, $AA_MAF, $EA_MAF, $ALLELE_NUM, $RefSeq, $EXON, $INTRON, $MOTIF_NAME, $MOTIF_POS, $HIGH_INF_POS, $MOTIF_SCORE_CHANGE, $DISTANCE, $STRAND
				, $CLIN_SIG, $CANONICAL, $SYMBOL, $SYMBOL_SOURCE, $SIFT, $PolyPhen, $GMAF, $BIOTYPE, $ENSP, $DOMAINS, $CCDS, $HGVSc, $HGVSp_II, $AFR_MAF, $AMR_MAF, $ASN_MAF, $EUR_MAF
				, $PUBMED, $HGNC_ID, $SWISSPROT, $TREMBL, $UNIPARC, $SOMATIC, $HGVSp_Short) = split(/\t/, $line );  
			

			if ( $all_effects && ( !defined ($dbSNP_RS)||$dbSNP_RS !~ m/rs[0-9]+/) && defined($Hugo_Symbol) && $all_effects =~ m/$geneName/ ){
				print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";
			}
			elsif ( $all_effects && ( !defined ($dbSNP_RS)||$dbSNP_RS !~ m/rs[0-9]+/) && defined($SYMBOL) && $all_effects =~ m/$geneName/){
				print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";
			}
			elsif ( $all_effects && ($dbSNP_RS) && ($dbSNP_RS =~ m/rs[0-9]+/) && defined($SYMBOL) && $all_effects =~ m/$geneName/){								
				if ($GMAF){
					my @tmp_maf=split(":", $GMAF); my $GMAF_val = sprintf("%f", $tmp_maf[1]);										
					if ($GMAF_val<$MAF_default){						
						print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";							
					}
				}
				elsif (!$GMAF) {					
					print "$Hugo_Symbol\t$Chromosome\t$Start_Position\t$End_Position\t$Strand\t$Variant_Classification\t$dbSNP_RS\t$Reference_Allele\t$Tumor_Seq_Allele1\t$Tumor_Seq_Allele2\t$all_effects\tcDNA_position\t$Consequence\t$Amino_acids\t$Codons\t$CLIN_SIG\t$GMAF\t$PUBMED\n";							
				}				
			}
		}		
		print "\n\n";
	}	
}



