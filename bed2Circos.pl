#!/usr/bin/perl -w
##	this is part of the code for circos pipeline
##	the purpose of this code is to select region of interest from chimeric.sam file

use Cwd;
my $chiFile = shift;



open (CHIM, $chiFile) or die "cannot open file: $chiFile";
@chifile = <CHIM>;
close CHIM;

for (my $i=0; $i<@chifile; $i++){
	# print"$i\n";
	chomp $chifile[$i];
	@elm=split("\t",$chifile[$i]);	
	# my $name=changeName($elm[0]);
	@ elm2=split("chr",$elm[0]);
    my $newName="hs".$elm2[1];
	print"$newName $elm[1] $elm[2] $elm[3]\n";
}

sub changeName{
    my ($name)=@_ ;
    # substr($name, 1, 3)='hs';
    # return $name ;        
    @ elm=split("chr",$name);
    my $newName="hs".$elm[0];
    # if ($newName=~m/hsX/){
    #     $newName='hsx';
        
    # }
    return $newName;
 }