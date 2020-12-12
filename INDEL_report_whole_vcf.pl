#!/usr/bin/perl -w

## this is the tool that input all maf files and output the mutations on IMPACT genes


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
my ( $MU_REF, $vcfdir, $outdir, $IMPACTstart, $IMPACTend);
$IMPACTstart=0; ## start from the first impact genes
$IMPACTend=340;	## start from the last impact genes
my @impact; ## to store the impact genes
my @vcf_files; ## to store all the vcf files
my $range_window=1000;

GetOptions(
    'help!' => \$help,
    'path-to-ref=s' => \$MU_REF,
    'input-vcf-dir=s' => \$vcfdir,
    'output-dir=s' => \$outdir,
    'impact-start=s' => \$IMPACTstart,
    'impact-end=s' => \$IMPACTend,
);


InputCorrect( $help, $vcfdir, $outdir, $IMPACTstart, $IMPACTend);

@vcf_files = glob("$vcfdir/*.vcf");

readIMPACT();

SearchPromisingMutationsII();






## check the whether input is correct. If not, exit.
sub InputCorrect{
	my ( $help, $vcfdir, $outdir, $IMPACTstart, $IMPACTend)= @_;
	if ($help==1){
		print "\nUsage: perl $0 --help\n";
		print "perl $0 --input-vcf-dir --output-dir [Options]\n\n";
		print 
		"--help              		Print out the instructions\n",
		"--path-to-ref			Full path to ref file\n",
		"--input-vcf-dir     		Directory to maf files, required\n",
		"--output-dir          		Output directory\n",
		"--impact-start          	The start of the IMPACT genes\n",
		"--impact-end			The end of the IMPACT genes\n\n";		
		exit;
	}
	elsif (!defined($MU_REF)){print "ERROR: --path-to-ref required\n"; exit;}
	elsif (!defined($vcfdir)){print "ERROR: --input-vcf-dir required\n"; exit;}
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


sub SearchPromisingMutationsII{
	for (my $i=$IMPACTstart; $i<$IMPACTend; $i++){
		my $line = $impact[$i];
		chomp $line; my @elm=split("\t", $line);
		my $name="SYMBOL=".$elm[3].";"; my $chr=$elm[4].":";
		my $IMPACTSymbol = $elm[3];
		my $filename=$elm[3]."_SUM.txt";
		print "$filename\n";
		open (OUT1, ">$outdir/$filename") or die "cannot open $filename: $!";

		foreach my $file (@vcf_files){
			my $basename=basename($file);
			open (FILE1, $file) or die "cannot open $file: $!";
			my @cur_vcfFile = <FILE1>;
			close FILE1;
			print OUT1 ">>$basename\n";
			foreach my $line (@cur_vcfFile){
				chomp $line;

				next if ($line =~ m/^\#/); #skip header

				#for pindel-vcf format
				my($CHROM, $POS, $ID, $REF, $ALT, $QUAL, $FILTER, $INFO, $FORMAT, $SAMPLE) = split(/\t/, $line );

				#print if match
				print OUT1  "$IMPACTSymbol\t$line\n" if (performMatching($CHROM, $POS, $impact[$i] )==1);

			}
		}
		close OUT1;

	}
}



## if the GMAF is lower than MAF_default or there is just no GMAF, return 1. else return 0
sub MAFinRange{
	my $GMAF= shift;
	if ($GMAF){
		my @tmp_maf=split("[:,]", $GMAF); my $GMAF_val = sprintf("%f", $tmp_maf[1]);
		return $GMAF_val<$MAF_default ? 1:0;
	}
	elsif (!$GMAF){
		return 1;
	}
}

## so start to perform the matching: 1. by genename 2. by interval. Return 1 if there is a match
sub performMatching{
	my($CHROM, $POS, $impact )=@_;
	my ($idx, $impactGeneName1, $impactID,$impactGeneName2,$impactChr,$impactStrain,$impactStart,$impactEnd)=split(/\t/, $impact);

	## interval matching. Note: there is a range_window
	if ( defined($CHROM) && $CHROM=~m/^$impactChr$/ && $POS >= $impactStart-$range_window && $POS <= $impactEnd+$range_window ){
		return 1 ;
	}
	## nothing matched to genename or interval
	else {return 0;}

}





