#!/usr/bin/perl -w
# usage: QuantifierAddInfo_dev.pl <Exon Expression.txt>
# example:  Methy2BedAddInfo.pl SDHBnegvsASandSBRCT_Probelist_merge500_moreThan2_ucscGenes.bed SDHBnegvsASandSBRCT_2FC1FC0.01Padj_14966_probelist.txt SDHBnegvsASandSBRCT_Probelist_merge500_moreThan2_Info.bed 1 27


use 5.010;
use Cwd;

my $Bed_file=shift;
my $Methy_probe_file=shift;
my $Bed_Info_file=shift;
my $Methy_IDcolumn=shift;
my $Methy_FCcolumn=shift;
my $kgXref_dir="/home/asboner/annotations/human/hg19/ucsc";
my $kgXref_file="kgXref.txt.2010.10.13";
#my $kgXref_file="kgXref.txt";

my %MethyFileHash=();
my %kgXref_hash=();
my %BedInfo_hash=();
my @BedFile=();
my @kgXref=();
my @BedInfoFile=();

my $ucscID2Symbol_previous='';
my $ucscID2Title_previous='';
my $previousSymbol='';

###############################################################

if (!$Bed_file | !$Methy_probe_file | !$Methy_FCcolumn){
    print "+++++++++++++++++++++++++++++++++++++++++++++++++++++\nnot enought parameters";
    print "usage: QuantifierAddInfo_dev.pl <Exon Expression.txt>\n";
    print "example: QuantifierAddInfo_dev.pl OFT25_exonGeneExpr.txt > ./OFT25_exonGeneExpr_info.txt\n";
    print "this is based on the knownGeneAnnotationExonCompositeModel.interval and kgXref.txt at /home/asboner/annotations/human/hg19/ucsc/\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
    exit;
}

###############################################################

open (EXPRFILE, $Bed_file) or die "cannot open file: $Bed_file";
@BedFile = <EXPRFILE>;
close EXPRFILE;

# @BedFile=uniq(@BedFile_tmp);
# my $tmp1=@BedFile_tmp;
# my $tmp2=@BedFile;
# print "$tmp1 $tmp2\n";

# exit;

###############################################################

my $pwd = getcwd;
chdir("$kgXref_dir");
open (KGFILE, $kgXref_file) or die "cannot open file: $kgXref_file";
@kgXref = <KGFILE>;
close KGFILE;
chdir($pwd);

for ($i=0; $i<@kgXref; $i++){
	chomp $kgXref[$i];
	my @rowkgXrefElements=split '\t', $kgXref[$i];
	# my $kgXref_ID=$rowkgXrefElements[0];
	# my $kgXref_Symbol=$rowkgXrefElements[4];
	# my $kgXref_Title=$rowkgXrefElements[7];
	# $kgXref_hash{$kgXref_ID}=($kgXref_Symbol, $kgXref_Title);
	$kgXref_hash{$rowkgXrefElements[0]}=join ("\t", $rowkgXrefElements[4], $rowkgXrefElements[7]);  #ucscID --> ucscSymbol <tab> ucscTitle
	#$kgXref_hash{$rowkgXrefElements[0]}=join ("\t", $rowkgXrefElements[4], $rowkgXrefElements[7]);  #ucscID --> ucscSymbol <tab> ucscTitle
}


###############################################################

open (METHYFILE, $Methy_probe_file) or die "cannot open file: $Methy_probe_file";
@MethyFile = <METHYFILE>;
close METHYFILE;

for ($i=0; $i<@MethyFile; $i++){
	chomp $MethyFile[$i];
	my @Methy_elements=split("\t", $MethyFile[$i]);
	#my $MethyID=$Methy_elements[$Methy_IDcolumn-1];
	#my $MethyFC=$Methy_elements[$Methy_FCcolumn-1];
	$MethyFileHash{$Methy_elements[$Methy_IDcolumn-1]} = $Methy_elements[$Methy_FCcolumn-1];  #MethyID --> ProbeFC
}

###############################################################

open (BEDINFOFILE, $Bed_Info_file) or die "cannot open file: $Bed_Info_file";
@BEDInfoFile = <BEDINFOFILE>;
close BEDINFOFILE;

for ($i=0; $i<@BEDInfoFile; $i++){
	chomp $BEDInfoFile[$i];
	my @BedInfo_elements=split("\t", $BEDInfoFile[$i]);
	my $location_ID=$BedInfo_elements[0].$BedInfo_elements[1].$BedInfo_elements[2];
	$BedInfo_hash{$location_ID}=$BedInfo_elements[3]; #something like chr11.102187949.102188564 --> cg14481222;cg05338083;cg23565749;cg16837326;cg04279695;cg16705383;cg10659575;cg21915672;cg24882097;cg20358655
}



###############################################################
my $header=0;

for ($i=0; $i<@BedFile; $i++){
	my $ucscID2Symbol='';
	my $ucscID2Title='';
	my @current_methyFC_array='';
	chomp $BedFile[$i];
	my @BedFile_elements=split("\t",$BedFile[$i]);
	my @GeneID_elements=split("[|]",$BedFile_elements[3]);
	my $transcript_interval=$BedFile_elements[0].":".$BedFile_elements[1]."-".$BedFile_elements[2];
	my $MethyProbes_interval=$BedFile_elements[6].":".$BedFile_elements[7]."-".$BedFile_elements[8];
	my $methyProbes_interval_key=$BedFile_elements[6].$BedFile_elements[7].$BedFile_elements[8];	
	my $num_enrichedMethy=$BedFile_elements[9];	
	#id2symbol, id2title
	for ($ids=0; $ids<@GeneID_elements; $ids++){
		my @tmp_kgXref_elements=split("\t", $kgXref_hash{$GeneID_elements[$ids]});		
		if ($ucscID2Symbol_previous !~ m/^$tmp_kgXref_elements[0]/){		
			if ($ucscID2Symbol =~ m/[|]/){
				$ucscID2Symbol=join("|",$ucscID2Symbol,$tmp_kgXref_elements[0]);
				$ucscID2Title=join("|",$ucscID2Title,$tmp_kgXref_elements[1]);
			}
			else {
				$ucscID2Symbol=$tmp_kgXref_elements[0];
				$ucscID2Title=$tmp_kgXref_elements[1];
			}			
		}
		else{
			$ucscID2Symbol=$ucscID2Symbol_previous;
			$ucscID2Title=$ucscID2Title_previous;
		}
		$ucscID2Symbol_previous=$tmp_kgXref_elements[0];
		$ucscID2Title_previous=$tmp_kgXref_elements[1];
	}
	#id2FC
	my @Bed_Info_elements=split(",", $BedInfo_hash{$methyProbes_interval_key});  # but they said would be ";"
	for ($ids=0; $ids<@Bed_Info_elements; $ids++){
		push(@current_methyFC_array, $MethyFileHash{$Bed_Info_elements[$ids]});
	}
	shift @current_methyFC_array;
	my $current_methyFC_mean=mean(@current_methyFC_array);
	if ($header==0){
		print "ucscID\tucscSymbol\tucscTitle\ttranscript_interval\tMethyProbes\tmean_methyFC\tMethyProbes_interval\tnum_Methy\n";
		$header=1;
	}
	
	if ($ucscID2Symbol !~ m/^$previousSymbol$/){
		print "$BedFile_elements[3]\t$ucscID2Symbol\t$ucscID2Title\t$transcript_interval\t$BedInfo_hash{$methyProbes_interval_key}\t$current_methyFC_mean\t$MethyProbes_interval\t$num_enrichedMethy\n";
	}	
	$previousSymbol=$ucscID2Symbol;
}

###############################################################
sub mean {
    my @array = @_; # save the array passed to this function
    my $sum=0; # create a variable to hold the sum of the array's values
    foreach (@array) { $sum += $_; } # add each element of the array 
    if (@array==0){
        return "NA";
    }
    else{
        return $sum/@array; # divide sum by the number of elements in the
    }    
}

sub uniq {
    my %seen = ();
    my @r = ();
    foreach my $a (@_) {
        unless ($seen{$a}) {
            push @r, $a;
            $seen{$a} = 1;
        }
    }
    return @r;
}