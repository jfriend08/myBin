#!/usr/bin/perl -w

## code was modified to collect sample names that if they have same location of SNP
## code was modified to save the filename with the threshold value

use strict;
use warnings;
use Getopt::Std;
use Cwd;

my $MAF_threshold = shift;
my $smalltest_threshold = shift;
my $value_format = shift;
my $out_dir = shift;

print"$MAF_threshold\n$smalltest_threshold\n$value_format\n$out_dir\n";

if (!$MAF_threshold || !$smalltest_threshold || !$value_format || !$out_dir){
    print "Not enought parameter\n";
    print "Usage:\tSNP_reportII.pl\t<MAF_threshold>\t<smalltest_threshold>\t<valueFormat Y/N>\t<out_dir>\n";
    print "Example:\tSNP_reportII.pl 0.05 0.05 N /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BWA/proc_10062014\n";
    exit;
}

my $maf_val;
my $otherelse;
my @array_lowMAF=();
my %location_hash=();
my %location_sample_hash=();
my %Sample_hash=();
my %Summary_hash=();
my @Summary_header=();
my $sampleName_cur;
my $tot_sample_Size=0;

my @files = glob("*_SUM.txt");
foreach my $eachfilename(@files){
	# my $eachfilename = $files[0];
	chomp $eachfilename; my @fileNameelm=split("_", $eachfilename);	
	print "$fileNameelm[0]\n";
	push (@Summary_header, $fileNameelm[0]);
	open (FILE, "$eachfilename") or die "cannot open anno file"; 
	my @file = <FILE>;
	close FILE;
	my $file_size= scalar (@file);	
	for (my $i=0; $i<@file; $i++){
		if ($file[$i] =~ m/>>/){
			chomp $file[$i];
			# print "$file[$i]\n";
			$sampleName_cur =  $file[$i]; @{$Sample_hash{$sampleName_cur}}=();
			$tot_sample_Size++;
		}
		elsif ($file[$i] !~ m/>>/){			
			if($file[$i] =~ m/(rs\d*)(.*)MAF=(\d*\.?\d*);(.*)/g){
				my @file_line_elem = split ("\t", $file[$i]);
				if($3 eq ""){
					push(@array_lowMAF, $file_line_elem[1]."_".$1);

				}
				elsif ($3 < $MAF_threshold) {										
					push(@array_lowMAF, $file_line_elem[1]."_".$1);
				}				
			}			
			elsif ($file[$i] !~ m/MAF|rs\d+/){
				my @file_line_elem = split ("\t", $file[$i]);
				push(@array_lowMAF, $file_line_elem[1]);
			}
		}		
		
		if($i >= $file_size-1){
			if (scalar (@array_lowMAF)>0){
				my @unique_lowMAF=uniq(@array_lowMAF);
				@{$Sample_hash{$sampleName_cur}}=@unique_lowMAF;
				assign_location_hash (@unique_lowMAF);

				# print "CurrntName: $sampleName_cur\n";
				assign_location_sampleName_hash(\@unique_lowMAF, $sampleName_cur);
				
				@array_lowMAF=();$sampleName_cur="";
			}
		}		
		elsif ($file[$i+1] =~ m/>>/ && scalar (@array_lowMAF)>0){						
			my @unique_lowMAF=uniq(@array_lowMAF);			
			@{$Sample_hash{$sampleName_cur}}=@unique_lowMAF;
			assign_location_hash (@unique_lowMAF);

			# print "CurrntName: $sampleName_cur\n";
			assign_location_sampleName_hash(\@unique_lowMAF, $sampleName_cur);

			@array_lowMAF=();$sampleName_cur="";
		}

		
	}	

	for my $key (keys %Sample_hash){
		my @tmp_array=();
		print "$key\t";		
		my @array = @{$Sample_hash{$key}};
		if(scalar(@array)==0){
			print "\n";
			push (@{$Summary_hash{$key}}, "") ;
		}
		elsif(scalar(@array)>0) {
			foreach my $location (@array){			
				my $ratio = $location_hash{$location}/$tot_sample_Size;
				if ($ratio<$smalltest_threshold){
					

					if (@{$location_sample_hash{$location}}){
						for (my $tmp_idx=0; $tmp_idx<@{$location_sample_hash{$location}}; $tmp_idx++){
							if (${$location_sample_hash{$location}}[$tmp_idx] =~ m/\>/){
								my @tmp_array= split(">>",${$location_sample_hash{$location}}[$tmp_idx]) ;
								${$location_sample_hash{$location}}[$tmp_idx]=$tmp_array[1];	
							}
							
						}	
					}
					
					if($location_sample_hash{$location}){
						my $SampleName=join("_",@{$location_sample_hash{$location}});	
						$location=$location."_".$SampleName;
					}
					
					
					
					push(@tmp_array, $location);				

				}			
			}			
			my $all_loc = ">chr".join(">chr", @tmp_array);
			if($all_loc!~ m/^>chr$/){
				print "$all_loc\n";

				push (@{$Summary_hash{$key}}, "$all_loc") ;
			}
			else {print"\n";push (@{$Summary_hash{$key}}, "") ;}			
		}		
	}

	

	%Sample_hash=();%location_hash=();%location_sample_hash=();$tot_sample_Size=0;
}

my $filename;
if($value_format=~m/N/){$filename="SNP_Summary_"."$MAF_threshold"."_"."$smalltest_threshold".".txt";}
elsif($value_format=~m/Y/){$filename="SNP_valueSummary_"."$MAF_threshold"."_"."$smalltest_threshold".".txt";}

open (OUT1, ">$out_dir/$filename") or die "cannot open $filename: $!";	
my $header=join("\t", @Summary_header);
print OUT1 "\t$header\n";
for my $sum_key (keys %Summary_hash){	
	if($value_format=~m/Y/){
		my @curArray = @{$Summary_hash{$sum_key}};
		for (my $i=0; $i<@curArray; $i++){
			if ($curArray[$i] =~ m/^$/){$curArray[$i] = 0 ;}
			elsif ($curArray[$i] =~ m/rs\d*/ ){$curArray[$i] = 5 ;}
			else {$curArray[$i] = 10 ;}
		}
		@{$Summary_hash{$sum_key}} = @curArray;
	}
	my $eachelement=join("\t", @{$Summary_hash{$sum_key}} );
	print OUT1 "$sum_key\t$eachelement\n";
}
close OUT1;


sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

#### to store the frequency of varient amoung all sample ####
sub assign_location_hash {
	my(@uniq_lowMAF) = @_;
	foreach my $each_location(@uniq_lowMAF){
		if(!$location_hash{$each_location}){
			$location_hash{$each_location} = 1;
		}
		else{
			$location_hash{$each_location}++;	
		}
	}
}

#### to store the frequency of varient amoung all sample ####
sub assign_location_sampleName_hash {	
	my($x1, $x2) = @_;
	my @uniq_lowMAF=@$x1;
	my $SampleName=$x2;
	# print "hi~$SampleName\n";
	# print "@uniq_lowMAF\n";
	foreach my $each_location(@uniq_lowMAF){		
		push (@{$location_sample_hash{$each_location}}, "$SampleName") ;
	}
}
	




