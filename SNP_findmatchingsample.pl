#!/usr/bin/perl -w

## Goal: based on the bed formatted input to find the matching sample

use strict;
use warnings;
use Getopt::Std;
use Cwd;

( scalar( @ARGV ) == 1 ) or die "Usage: perl $0 <input bed file>\n";
my ($input_bed) = @ARGV;

my @samples = glob("*");
my %sum_hash=();
my %ref_hash=();

open (BED, $input_bed) or die "cannot open file: $input_bed"; 	
my @bed = <BED>;
close BED;

for (my $i=0; $i<@samples; $i++){
	open (FILE1, "./$samples[$i]/$samples[$i]_germ_snp_vep.maf_noRS_vep.maf") or die "cannot open anno file"; 	
	my @cur_maf=<FILE1>;
	close FILE1;
	open (FILE2, "./$samples[$i]/$samples[$i]_somatic_snp_vep.maf_noRS_vep.maf") or die "cannot open anno file"; 	
	my @cur_maf2=<FILE2>;
	close FILE2;
	push @cur_maf, @cur_maf2;	
	matching (\@bed,\@cur_maf, $samples[$i]);
}

print "Chromosome\tStart\tEnd\tHugo_Symbol\tFeature\tNum_MatchingSample\tName_MatchingSample\tRef_Tallel1_Tallel2\n";
foreach my $line(@bed){
	chomp $line;
	my @elm=split("\t", $line);
	my $key=join("_", $elm[0], $elm[1]);
	print "$line\t$sum_hash{$key}\t$ref_hash{$key}\n"
}

######################################################

sub matching{
	my ($bed_ref, $maf_ref, $samplename)=@_;
	my @local_bed=@$bed_ref;
	my @local_maf=@$maf_ref;
	for (my $bed_idx=0; $bed_idx<@local_bed; $bed_idx++){
		my @bed_elm=split("\t", $local_bed[$bed_idx]);
		my $bed_chr=$bed_elm[0];
		my $bed_loci=$bed_elm[1];
		for (my $maf_idx=0; $maf_idx<@local_maf; $maf_idx++){
			my @maf_elm=split("\t",$local_maf[$maf_idx]);
			my $maf_chr=$maf_elm[4];
			my $maf_loci=$maf_elm[5];
			my $maf_ref_allel=$maf_elm[10];
			my $maf_ref_Tallel_1=$maf_elm[11];
			my $maf_ref_Tallel_2=$maf_elm[12];

			if ($bed_chr =~ m/$maf_chr/ && $bed_loci==$maf_loci){
				# print "$samplename\n";
				my $tmp_key=join("_",$bed_chr, $bed_loci);
				if ($sum_hash{$tmp_key}){
					$sum_hash{$tmp_key}=join("_", $sum_hash{$tmp_key}, $samplename);					
				}
				else{
					$sum_hash{$tmp_key}=$samplename;
					$ref_hash{$tmp_key}=join("_", $maf_ref_allel, $maf_ref_Tallel_1, $maf_ref_Tallel_2);
				}				
			}

		}
	}
	# my $maf_elm=split("\t", );
	

}