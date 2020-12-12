#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use Cwd;

##	this this the code serching SNP based on IMPACT gene list, and is pattern matching based on gene symbol and chromosome
##	Usage: SNP_report.pl <output directpory> <begin of IMPACT> <end of IMPACT> <patern>
##	example:SNP_report.pl /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/samtools_snps/SNP_SUM/mytest 0 1 PED*.txt

my $outdir = shift;
my $impact_begin = shift;
my $impact_end = shift;
my $patern= shift;
my $con1 = "stop_gained";my $con2 = "frameshift_variant";my $con3 = "stop_lost";
my $con4 = "inframe_insertion";my $con5 = "inframe_deletion";my $con6 = "missense_variant";
my @elm=(); my $name;
my $paternToSearch;

#################### read IMPACT file ####################
my $pwd = getcwd;
chdir("/aslab_scratch001/asboner_dat/PeterTest/Annotation/IMPACT");
open (IMPACT, "IMPACT_list_Info.txt") or die "cannot open anno file";  # this is the annotation file that random.chromosome were excluded
my @impact = <IMPACT>;
close IMPACT;
chdir($pwd);
#################### read IMPACT file ####################
if ($patern !~ m/^$/){$paternToSearch= "$patern"."*"."txt";}
else {$paternToSearch= "*".".txt";}
print "paternToSearch = $paternToSearch\n";
my @files = glob("$paternToSearch");
# print "@files\n";
# my @files = glob("*.txt");
# foreach my $line(@impact){
for (my $k=$impact_begin; $k<$impact_end; $k++)	{
	my $line = $impact[$k];
	chomp $line;@elm=split("\t", $line);
	$name="SYMBOL=".$elm[3].";"; my $chr=$elm[4].":";
	my $filename=$elm[3]."_SUM.txt";
	print "$filename\n";
	open (OUT1, ">$outdir/$filename") or die "cannot open $filename: $!";	
	foreach my $file_line(@files){
		open(FILE, $file_line);
		my @file=<FILE>;
		close FILE;	
		my @file_elm=split("_", $file_line);
		# print ">>$file_elm[0]\n";
		print OUT1 ">>$file_elm[0]\n";
		
		for (my $i=0; $i<@file; $i++){
			chomp $file[$i];
			if($file[$i]=~m/$name/ && $file[$i]=~m/$chr/){
				if($file[$i]=~m/$con1|$con2|$con3|$con4|$con5|$con6/){
					# print "$file[$i]\n";	
					print OUT1 "$file[$i]\n";	
				}				
			}
		}		
	}
	# close OUT1;

}



# my @files = glob("*.txt");
# foreach my $file (@files){
# 	open(FILE, $file);
# 	my @file=<FILE>;
# 	close FILE;	
# 	foreach my $line(@impact){
# 		chomp $line;
# 		@elm=split("\t", $line);
# 		$name="SYMBOL=".$elm[0].";"; my $chr=$elm[1].":";
		
# 		my $filename=$elm[0]."_".$file_elm[0]."_SUM.txt";
# 		print "$filename\n";
# 		open (OUT1, ">$outdir/$filename") or die "cannot open $filename: $!";	
# 		print OUT1 "$file\n";

# 		for (my $i=0; $i<@file; $i++){
# 			chomp $file[$i];
# 			if($file[$i]=~m/$name/ && $file[$i]=~m/$chr/){
# 				if($file[$i]=~m/$con1|$con2|$con3|$con4|$con5|$con6/){
# 					print OUT1 "$file[$i]\n";	
# 				}				
# 			}
# 		}
# 		close OUT1;

		
# 	}

# }