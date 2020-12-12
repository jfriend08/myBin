#!/usr/bin/perl -w
#use strict;
# usage: findMotifFromList.pl <Motif List> <name of differential gene list> <want to run two_BitToFa for diff_list> <want to run two_BitToFa for all transcripts>
# example: findMotif.pl SBRCTvsRest_1FC005P_1047genes.txt [CG][CA]GGAA[GA] Y N
# example: findMotifFromList.pl SBRCT_TF_motifList.txt SBRCTvsRest_1FC005P_1047genes.txt Y N

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed

use 5.010;
use Cwd;

my $allmotiflist = shift;
my $genelist = shift;
my $run_diff_twoBitToFa=shift;
my $run_all_twoBitToFa=shift;
my $diff_motifHits=0;
my $numBiggerThanMotifHits=0;
my $p_valueSelectTimes=3000;

print "num_selection\tTF\tmotif_seq\tnum_diffList\tnum_motifHits\tp_value\thit_gene\n";

my @annofile=0;
my @diffgenelist=0;
my @matchList=0;
my @super_fafile=0;
my @super_allfafile=0;
my @super_diffgenelist=0;
my %annohash =();
my @MotifList=();
my @MotifListName=();

open (MOTIFFILE, $allmotiflist) or die "cannot open file $allmotiflist";
my @allMotifList = <MOTIFFILE>;
for ($i=0;$i<@allMotifList;$i++){
    chomp $allMotifList[$i];
    my @elements=split ("\t",$allMotifList[$i]);
    $MotifList[$i]=$elements[3];
    $MotifListName[$i]=$elements[1];

}



# my @randomSequence=0;
# my $index=0;
# my @randomNeuclide = ("A", "T", "C", "G",".");
# for ($i=0; $i<@randomNeuclide; $i++){
#     for ($j=0; $j<@randomNeuclide; $j++){
#         for ($k=0; $k<@randomNeuclide; $k++){
#             $randomSequence[$index]= "TCCTC$randomNeuclide[$i]$randomNeuclide[$j]$randomNeuclide[$k]";
#             $index++;
#         }
#     }
# }
#print "@randomSequence\n";
#print scalar (@randomSequence), "\n";
#exit;
############################################################################################################################################
my $pwd = getcwd;
chdir("/pbtech_mounts/fdlab_store003/fdlab/annotations/human/hg19/ucsc/2013.09.10");
#my @header=0;
open (ANNOFILE, "knownGeneAnnotationTranscriptCompositeModel_nh_2013.09.10.interval") or die "cannot open anno file";
@annofile = <ANNOFILE>;
my @tmp_annofile=@annofile;
@annofile = grep (!/chrM/,@annofile);  #exclude the transcript from chrM, there are 19 transcripts in this case.
chdir($pwd);
############################################################################################################################################
my $filename1 = "tmp_all.txt";
open (OUT1, ">$filename1") or die "cannot open $filename1: $!";
for ($i=0; $i<@annofile; $i++){
    chomp $annofile[$i];
    my @tmp=split ("\t",$annofile[$i]);
    $annohash{$tmp[0]} = join ("\t", $tmp[2], $tmp[1], $tmp[3], $tmp[4], $tmp[5], $tmp[6], $tmp[7]); #make hash



    if ($tmp[2] =~m/[+]/){
        my $location1 =$tmp[3]-2000;
        my $location2 =$tmp[3]+1000;
        $location1 = 0 if ($location1 < 0);
        if ($i ==@annofile-1){
            print OUT1 "$tmp[1]:$location1-$location2";
        }
        else{
            print OUT1 "$tmp[1]:$location1-$location2\n";
        }
    }
    if ($tmp[2] =~m/[-]/){
        my $location3 =$tmp[4]+2000;
        my $location4 =$tmp[4]-1000;
        $location4 = 0 if ($location4 < 0);
        if ($i ==@annofile-1){
            print OUT1 "$tmp[1]:$location4-$location3";
        }
        else {
            print OUT1 "$tmp[1]:$location4-$location3\n";
        }
    }
}

#for my $key (keys %annohash){
#    my $value = $annohash{$key};
#    print "$key\t$value\n";
#}
#exit;
close OUT1;
############################################################################################################################################
open (GENELIST, $genelist) or die "cannot open file: $genelist";
@diffgenelist = <GENELIST>;
close GENELIST;
@diffgenelist = grep (!/(uc004coq.4|uc022bqo.2|uc004cor.1|uc004cos.5|uc022bqp.1|uc022bqq.1|uc022bqr.1|uc031tga.1|uc022bqs.1|uc011mfi.2|uc022bqt.1|uc031tgb.1|uc022bqu.2|uc004cov.5|uc004cow.2|uc004cox.4|uc022bqv.1|uc022bqw.1|uc022bqx.1|uc004coz.1)/,@diffgenelist);
my $filename2 = "tmp.txt";
open (OUT2, ">$filename2") or die "cannot open $filename2: $!";
for ($i=0; $i<@diffgenelist; $i++){
    chomp $diffgenelist[$i];
    my @tmp=split ("\t", $diffgenelist[$i]); #@tmp is each row of the differential gene list. TranscriptID is saved at the second column.
    #    print "$i\n";
    my @tmp2 = split ("\t", $annohash{$tmp[1]}); # @tmp2 is the info in hash.

    unshift @tmp2, "$tmp[0]";  # add genesymbol at the first element
    $super_diffgenelist[$i]=join "\t", @tmp2;

    if ($tmp2[1] =~m/[+]/){
        my $location1 =$tmp2[3]-2000;
        $location1=0 if ($location1 < 0);
        my $location2 =$tmp2[3]+1000;
        if ($i ==@diffgenelist-1){
            print OUT2 "$tmp2[2]:$location1-$location2";
        }
        else{
            print OUT2 "$tmp2[2]:$location1-$location2\n";
        }
    }
    if ($tmp2[1] =~m/[-]/){
        my $location3 =$tmp2[4]+2000;
        my $location4 =$tmp2[4]-1000;
        if ($i ==@diffgenelist-1){
            print OUT2 "$tmp2[2]:$location4-$location3";
        }
        else {
            print OUT2 "$tmp2[2]:$location4-$location3\n";
        }
    }
}
close OUT2;
############################################################################################################################################

if ($run_diff_twoBitToFa =~ /Y/){
    system("twoBitToFa /home/asboner/genomes/human/hg19/indexes/blat/hg19_nh.2bit -seqList=tmp.txt tmp.fa");
}
if ($run_all_twoBitToFa =~ /Y/){
    system("twoBitToFa /home/asboner/genomes/human/hg19/indexes/blat/hg19_nh.2bit -seqList=tmp_all.txt tmp_all.fa");
}

############################################################################################################################################

my $tmp_fa="tmp.fa";  # .fa file of the diff gene list
my $tmp_fa_all="tmp_all.fa";  # .fa file of all transcripts

open (FAFILE, $tmp_fa) or die "cannot open file: $tmp_fa";
@fafile = <FAFILE>;

open (FAFILEALL, $tmp_fa_all) or die "cannot open file: $tmp_fa_all";
@fafile_all = <FAFILEALL>;

close FAFILE;
close FAFILEALL;
@randomSequence=@MotifList;
for ($random=0; $random<@randomSequence; $random++){
    my $printAll='';
    $motif =$randomSequence[$random];
    $printAll = join ("\t", "$p_valueSelectTimes", "$MotifListName[$random]","$motif");
    #    push (@printAll, "$p_valueSelectTimes", "$motif")
    #    print "$printAll\n";
    ######################################################diffgenelist######################################################################################
    #making appropriate sequence changes depends on the orientation of the transcript
    #then count the numbers of motif hits and save into super_diffgenelist
    if ($random==0){
        $j=0;
        for ($i=0; $i<@fafile; $i++){
            chomp $fafile[$i];
            if ($fafile[$i] =~ m/[>]/){
                $j++;
                $i++;
                $super_fafile[$j-1]="";
                chomp $super_fafile[$j-1];
            }
            $super_fafile[$j-1]=$super_fafile[$j-1].$fafile[$i];
            chomp $super_fafile[$j-1];
        }
        
        for ($i=0; $i<@super_diffgenelist; $i++){
            $super_diffgenelist[$i]=join ("\t", $super_diffgenelist[$i], $super_fafile[$i]);
            my @tmp=split("\t", $super_diffgenelist[$i]);
            if ($tmp[1]=~m/[+]/){
                push @tmp, DNA_anti($tmp[8]);
            }
            if ($tmp[1]=~m/[-]/){
                $tmp[8]=scalar reverse(DNA_anti($tmp[8]));  #tmp[8] is the 5' UTR at their strain
                push @tmp, scalar reverse($tmp[8]);  #tmp[9] is the 5' UTR at anti strain
            }

            $super_diffgenelist[$i]=join "\t", @tmp;
        }
    }
    for ($i=0; $i<@super_diffgenelist; $i++){
        my @tmp=split("\t", $super_diffgenelist[$i]);
        $count = 0;
        $count++ while ($tmp[8] =~ m/$motif/ig);
        $super_diffgenelist[$i]=join "\t", @tmp, $count;
        #    print "$super_diffgenelist[$i]\n";
    }


    #######################################################all_annolist#####################################################################################
    #making appropriate sequence changes depends on the orientation of the transcript
    #then count the numbers of motif hits and save into super_diffgenelist
    if ($random==0){
        $j=0;
        for ($i=0;$i<@fafile_all;$i++){
            chomp $fafile_all[$i];
            if ($fafile_all[$i] =~ m/[>]/){
                $j++;
                $i++;
                $super_allfafile[$j-1]="";
                chomp $super_allfafile[$j-1];
            }
            $super_allfafile[$j-1]=$super_allfafile[$j-1].$fafile_all[$i];
            chomp $super_allfafile[$j-1];
        }
        for ($i=0; $i<@annofile; $i++){
            $super_allanno[$i]=join ("\t", $annofile[$i], $super_allfafile[$i]);
            my @tmp=split("\t", $super_allanno[$i]);
            if ($tmp[2]=~m/[+]/){
                push @tmp, DNA_anti($tmp[8]);
            }
            if ($tmp[2]=~m/[-]/){
                $tmp[8]=scalar reverse(DNA_anti($tmp[8]));  #tmp[8] is the 5' UTR at their strain
                push @tmp, scalar reverse($tmp[8]);  #tmp[9] is the 5' UTR at anti strain
            }
            $super_allanno[$i]=join "\t", @tmp;
        }
    }
    for ($i=0; $i<@annofile; $i++){
        my @tmp=split("\t", $super_allanno[$i]);
        $count = 0;
        $count++ while ($tmp[8] =~ m/$motif/ig);
        $super_allanno[$i]=join "\t", @tmp, $count;   # $super_allanno would save all annotated transcripts plus 5'UTR and motif hits
        #    print "$super_allanno[$i]\n";
    }

 
    ############################################################################################################################################
    #count how many transcripts have motif hits more than one
    $diff_motifHits=0;
    for ($i=0;$i<@super_diffgenelist; $i++){
        my @tmp=split("\t", $super_diffgenelist[$i]);
        if ($tmp[10]>0){
            $diff_motifHits++;
        }
    }
    #    print "total diff_list: ";
    my $tmp_number= scalar (@super_diffgenelist);
    #    print "diff_motifHits: $diff_motifHits\n";
    $printAll = join ("\t", "$printAll","$tmp_number", "$diff_motifHits");
    #    print "$printAll\n";
    ############################################################################################################################################
    #print "start random selection\n";
    my $range = scalar(@annofile);
    $numBiggerThanMotifHits =0;
    for ($i=0; $i<$p_valueSelectTimes; $i++){
        my $random_number;
        my %seen=();
        $count=0;
        for ($j=0; $j<@super_diffgenelist;$j++){
            $random_number = int(rand($range));
            while ($seen{$random_number}) {
                $random_number = int(rand($range));
            }
            $seen{$random_number} = 1;
            # $random_number = int(rand($range));

            my @tmp=split("\t", $super_allanno[$random_number]);
            if ($tmp[10]>0){
                $count++;
            }
        }
        if ($count >= $diff_motifHits){
            $numBiggerThanMotifHits++;
        }
        
    }
    my $p_value=$numBiggerThanMotifHits/$p_valueSelectTimes;
    #    print "p_value of diff_list triggered by motif: $p_value\n";
    #    $printAll = join ("\t", "$printAll", "$p_value");
    ############################################################################################################################################
    #    print "diff_geneSymble\tnum_MotifHits\n";
    my $tmpAllHits='';
    for ($i=0; $i<@super_diffgenelist; $i++){
        my @tmp = split("\t", $super_diffgenelist[$i]);
        if ($tmp[10]>0){
            $tmpAllHits= $tmpAllHits. "#$tmp[0]:$tmp[10]";
        }
    }
    $printAll = join ("\t", "$printAll", "$p_value", "$tmpAllHits");
    print "$printAll\n";
    #    print "######################################\n";
    for ($i=0; $i<@super_diffgenelist; $i++){
        my @tmp = split ("\t", $super_diffgenelist[$i]);
        pop @tmp;
        $super_diffgenelist[$i]=join "\t", @tmp;
    }
    #    print "$super_diffgenelist[1]\n";
    for ($i=0; $i<@super_allanno; $i++){
        my @tmp = split ("\t", $super_allanno[$i]);
        pop @tmp;
        $super_allanno[$i]=join "\t", @tmp;
    }
}







sub DNA_anti{
    my ($dna)= @_;
    $dna =~ tr/ATCG/TAGC/;
    $dna =~ tr/atcg/tagc/;
    return $dna;
}
exit;