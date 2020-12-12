#!/usr/bin/perl -w
use 5.010;
use Cwd;

my $gff3file = shift;

open (GFF3FILE, $gff3file) or die "cannot open file $gff3file";
    @gff3 = <GFF3FILE>;
close GFF3FILE;


@gff3 = grep (!/#/,@gff3);
@gff3 = grep (!/miRNA_primary_transcript/,@gff3);

for ($i=0; $i<@gff3; $i++){
    chomp $gff3[$i];
    #print "$gff3[$i]\n";
    my @row_elements=split ("\t", $gff3[$i]);
    my @Nine_column_elements=split(";", $row_elements[8]);
    my @miR_Names=split("=", $Nine_column_elements[2]);
    print "$miR_Names[1]\t$row_elements[0]\t$row_elements[6]\t$row_elements[3]\t$row_elements[4]\t1\t$row_elements[3]\t$row_elements[4]\n";

}




#interval format: ID, chromosome, strain, start, end, # of exons, exon starts(in common), exon ends(in common). 
#gff3 format: chromosome, ?, miRNA, miR start, miR ends, ?, strain, ?, ID-Alias-Name-Derives_from