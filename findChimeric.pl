#!/usr/bin/perl -w
##	this is part of the code for circos pipeline
##	the purpose of this code is to select region of interest from chimeric.sam file

use Cwd;
my $chiFile = shift;
my $listFile= shift;
my %chimeric=();
my @IDlist=();
my @uniqID=();



open (CHIM, $chiFile) or die "cannot open file: $chiFile";
@chifile = <CHIM>;
close CHIM;

open (LIST, $listFile) or die "cannot open file: $listFile";
@listfile = <LIST>;
close LIST;

for (my $j=0; $j<@listfile; $j++){
	chomp $listfile[$j];
	my @listelm=split("\t", $listfile[$j]); ## 0:gene ; 1:chr; 2:start; 3:end
	for (my $i=0; $i<@chifile; $i++){
		chomp $chifile[$i];
		my @elm=split("\t",$chifile[$i]); 
		if (($elm[2]=~ m/$listelm[1]/) && ($elm[3]> $listelm[2])&& ($elm[3]< $listelm[3])){
			# print "$chifile[$i]\n";
			# push (@{$chifile[0]},$chifile[$i]);    #inter case => push to Location1
			# push (@{$chimeric{$elm[0]}},join("\t",$chifile[$i]));
			push(@IDlist, $elm[0])
		}
	}
}
@uniqID=uniq(@IDlist);
# foreach $line (@uniqID){
# 	print "$line\n";
# }

# exit;
for (my $i=0; $i<@chifile; $i++){
	chomp $chifile[$i];
	my @elm=split("\t",$chifile[$i]); 
	# print"$elm[0]\n$chifile[$i]\n\n";
	push (@{$chimeric{$elm[0]}},$chifile[$i]);

}
# exit;

# @{$chimericID{$ID[$i]}}

for (my $i=0; $i<@uniqID; $i++){
	foreach $line (@{$chimeric{$uniqID[$i]}}){
		print "$line\n";
	}
}


# for my $key (keys %chimeric)
# {
#     my @value= @{$chimeric{$key}};
#     foreach $line (@value)
#     {
#          # print "$key\t";
#          print "$line\n";
#     }
# }


sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}


# for (my $i=0; $i<@chifile; $i++){
#     chomp $chifile[$i];
#     # my @elm=split("\t",$chifile[$i]);
#     # if ( ($elm[2]=~m/chr11/)


#     if (($chifile[$i]=~m/$chr1.*$chr2/)|($chifile[$i]=~m/$chr2.*$chr1/)|($chifile[$i]=~m/$chr1.*$chr1/)|($chifile[$i]=~m/$chr2.*$chr2/)){
#     	for(my $j=0; $j<@start; $j++){
#     		my @elm=split("\t",$chifile[$i]);    		
#     		if ($elm[3]>$start[$j] && $elm[3]<$end[$j]){    			
#     			print "$chifile[$i]\n";
#     		}
#     		elsif ($elm[7]>$start[$j] && $elm[7]<$end[$j]){
#     			print "$chifile[$i]\n";
#     		}
#     	}        
#     }
# }
