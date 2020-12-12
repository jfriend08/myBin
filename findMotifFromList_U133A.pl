#!/usr/bin/perl -w
#use strict;
# usage: findMotifFromList.pl <Motif List> <name of differential gene list> <want to run two_BitToFa for diff_list> <want to run two_BitToFa for all transcripts> <want to run through whole TFs>
# example: findMotif.pl SBRCTvsRest_1FC005P_1047genes.txt [CG][CA]GGAA[GA] Y N
# example: findMotifFromList.pl SBRCT_TF_motifList.txt SBRCTvsRest_1FC005P_1047genes.txt Y N
# example for GoThroughAllTFs: findMotifFromList_U133A.pl fullHOCOMOCO2U133A.txt InterestingGeneList.txt Y Y Y >InterestingGeneList_allTFs_result.txt

# Note: the transcriptID is based on composit model of 2013.09.10 ucsc version at the second column of the differential gene list
# Note: the directory of composit model of 2013.09.10 ucsc version is prefixed

use 5.010;
use Cwd;

my $allmotiflist = shift;
my $genelist = shift;
my $run_diff_twoBitToFa=shift;
my $run_all_twoBitToFa=shift;
my $runThroughWholeTFs=shift;
my $diff_motifHits=0;
my $numBiggerThanMotifHits=0;
my $p_valueSelectTimes=2000;
my $anno_key="";
print "num_selection\tTF\tmotif_seq\tnum_diffList\tnum_motifHits\tp_value\thit_gene\n";

my @annofile=0;
my @diffgenelist=0;
my @matchList=0;
my @super_fafile=0;
my @super_allfafile=0;
my @super_diffgenelist=0;
my %annohash =();
my %super_allfafile_hash=();
my @MotifList=();
my @MotifListName=();

############################################################################################################################################
### This is the place that I can motidy for findMotifWhoBindMeFromList.pl ###
if ($runThroughWholeTFs =~ m/Y/){
    my $pwd = getcwd;
    chdir("/aslab_scratch001/asboner_dat/PeterTest/Annotation");
    open (ALLTFMOTIFS, "fullAll_TF_bindingMotif_noDuplicate.txt") or die "cannot open anno file";  # this is the annotation file that random.chromosome were excluded
    my @allMotifList = <ALLTFMOTIFS>;
    close ALLTFMOTIFS;
    for ($i=1;$i<@allMotifList;$i++){
        chomp $allMotifList[$i];
        my @elements=split ("\t",$allMotifList[$i]);
        $MotifList[$i]=$elements[1];
        $MotifListName[$i]=$elements[0];
    }
    chdir($pwd);
}
else{
    open (MOTIFFILE, $allmotiflist) or die "cannot open file $allmotiflist";
    my @allMotifList = <MOTIFFILE>;
    close MOTIFFILE;
    for ($i=0;$i<@allMotifList;$i++){
        chomp $allMotifList[$i];
        my @elements=split ("\t",$allMotifList[$i]);
        $MotifList[$i]=$elements[3];
        $MotifListName[$i]=$elements[1];
    }
}

############################################################################################################################################

my $pwd = getcwd;
chdir("/aslab_scratch001/asboner_dat/PeterTest/Annotation");
open (ANNOFILE, "U133A_annotation_processed_II.txt") or die "cannot open anno file";  # this is the annotation file that random.chromosome were excluded
@annofile = <ANNOFILE>;
close ANNOFILE;
chdir($pwd);

############################################################################################################################################
# 1. screen every transcript in annotation, and make appropriate hash based on the ID. ---> %annohash
# 2. collect all -2000:+1000 interval for every transcript with orientation issue considered and print it as tmp_all.txt. This will be used in TwoBit2Fa
my $filename1 = "tmp_all.txt";
open (OUT1, ">$filename1") or die "cannot open $filename1: $!";
for ($i=0; $i<@annofile; $i++){
    chomp $annofile[$i];
    my @tmp=split ("\t",$annofile[$i]);
    if ($tmp[2] =~ m/chr/){
        $annohash{$tmp[0]} = join ("\t", $tmp[7], $tmp[8], $tmp[9], $tmp[10], $tmp[1]); #make hash
        if ($tmp[7] =~m/[+]/){
            my $location1 =$tmp[9]-2000;
            my $location2 =$tmp[9]+1000;
            $location1 = 0 if ($location1 < 0);
            if ($i ==@annofile-1){
                print OUT1 "$tmp[8]:$location1-$location2";
            }
            else{
                print OUT1 "$tmp[8]:$location1-$location2\n";
            }
        }
        if ($tmp[7] =~m/[-]/){
            my $location3 =$tmp[10]+2000;
            my $location4 =$tmp[10]-1000;
            $location4 = 0 if ($location4 < 0);
            if ($i ==@annofile-1){
                print OUT1 "$tmp[8]:$location4-$location3";
            }
            else {
                print OUT1 "$tmp[8]:$location4-$location3\n";
            }
        }
    }    
}
close OUT1;

############################################################################################################################################
# 1. Go through the @diffgenelist, and get the info only for the diffgenes, which is $annohash{$tmp[1]}. 
# 2. collect all -2000:+1000 interval for diffgenes with orientation issue considered and print it as tmp.txt. This will be used in TwoBit2Fa
open (GENELIST, $genelist) or die "cannot open file: $genelist";
@diffgenelist = <GENELIST>;
close GENELIST;
my $filename2 = "tmp.txt";
open (OUT2, ">$filename2") or die "cannot open $filename2: $!";
for ($i=0; $i<@diffgenelist; $i++){
    chomp $diffgenelist[$i];
    my @tmp=split ("\t", $diffgenelist[$i]); #@tmp is each row of the differential gene list. TranscriptID is saved at the second column.
    my @tmp2 = split ("\t", $annohash{$tmp[1]}); # Split only the one that $annohash{$tmp[1]} us true. Only get the info from diffgenelist. @tmp2 is the info in hash.
    unshift @tmp2, pop @tmp2;  # add genesymbol at the first element
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
# TwoBit2Fa for tmp_all.txt can run at the very first time on the current directory
# TwoBit2Fa for tmp.txt should run everytime you change the gene list
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

# Now, for every of the TFs in the @MotifList file. 
# Use $printAll to collect all of the results that I like to print
for ($random=0; $random<@randomSequence; $random++){
    my $printAll='';
    $motif =$randomSequence[$random]; #for every of the binfing motif
    $printAll = join ("\t", "$p_valueSelectTimes", "$MotifListName[$random]","$motif");
    ######################################################diffgenelist######################################################################################
    #making appropriate sequence changes depends on the orientation of the transcript
    #then count the numbers of motif hits and save into super_diffgenelist
    if ($random==0){
        $j=0;
        # collecting continuous promoter sequence from @fafile --> save it to @super_fafile
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
        # Then, join the @super_fafile to "@super_diffgenelist", with its appropriate orientation considered (then become 5' UTR)
        # Then, join the anit-5'UTR to @super_diffgenelist. Some research claimed TFs will bind to it as well. But this is not the case we considered now. 
        # So, the 9th ($tmp[8]) and 10th ($tmp[9]) column is the 5'UTR and anti-5'UTR. 
        for ($i=0; $i<@super_diffgenelist; $i++){
            $super_diffgenelist[$i]=join ("\t", $super_diffgenelist[$i], $super_fafile[$i]); 
            my @tmp=split("\t", $super_diffgenelist[$i]);
            if ($tmp[1]=~m/[+]/){
                push @tmp, DNA_anti($tmp[-1]);
            }
            if ($tmp[1]=~m/[-]/){
                $tmp[-1]=scalar reverse(DNA_anti($tmp[-1]));  #tmp[8] is the 5' UTR at their strain
                push @tmp, scalar reverse($tmp[-1]);  #tmp[9] is the 5' UTR at anti strain
            }
            $super_diffgenelist[$i]=join "\t", @tmp;
        }
    }

    # Now, for every of the Motif, do the counting of hit amount all of the @super_diffgenelist
    # Then, join the hit counts to super_diffgenelist. So super_diffgenelist got new column
    for ($i=0; $i<@super_diffgenelist; $i++){
        my @tmp=split("\t", $super_diffgenelist[$i]);
        $count = 0;
        $count++ while ($tmp[-2] =~ m/$motif/ig);
        $super_diffgenelist[$i]=join "\t", @tmp, $count;
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
            my @tmp_location=split(" ", $tmp[2]);
            if ($tmp_location[1]=~m/[+]/){
                push @tmp, DNA_anti($tmp[-1]);
            }
            if ($tmp_location[1]=~m/[-]/){
                $tmp[-1]=scalar reverse(DNA_anti($tmp[-1]));  #tmp[8] is the 5' UTR at their strain
                push @tmp, scalar reverse($tmp[-1]);  #tmp[9] is the 5' UTR at anti strain
            }
            $super_allanno[$i]=join "\t", @tmp;
        }
    }
    for ($i=0; $i<@annofile; $i++){
        my @tmp=split("\t", $super_allanno[$i]);
        $count = 0;
        $count++ while ($tmp[-2] =~ m/$motif/ig);
        $super_allanno[$i]=join "\t", @tmp, $count;   # $super_allanno would save all annotated transcripts plus 5'UTR and motif hits
    }

    ############################################################################################################################################
    #count how many transcripts have motif hits more than one
    $diff_motifHits=0;
    for ($i=0;$i<@super_diffgenelist; $i++){
        my @tmp=split("\t", $super_diffgenelist[$i]);
        if ($tmp[-1]>0){
            $diff_motifHits++;
        }
    }
    my $tmp_number= scalar (@super_diffgenelist);
    $printAll = join ("\t", "$printAll","$tmp_number", "$diff_motifHits");

    ############################################################################################################################################
    my $range = scalar(@annofile);
    $numBiggerThanMotifHits =0;
    for ($i=0; $i<$p_valueSelectTimes; $i++){
        $count=0;
        for ($j=0; $j<@super_diffgenelist;$j++){
            my $random_number = int(rand($range));
            #        print "R:$random_number-";
            my @tmp=split("\t", $super_allanno[$random_number]);
            if ($tmp[-1]>0){
                $count++;
            }
        }
        if ($count >= $diff_motifHits){
            $numBiggerThanMotifHits++;
        }        
    }
    my $p_value=$numBiggerThanMotifHits/$p_valueSelectTimes;    
    my $tmpAllHits='';
    for ($i=0; $i<@super_diffgenelist; $i++){
        my @tmp = split("\t", $super_diffgenelist[$i]);
        if ($tmp[-1]>0){
            $tmpAllHits= $tmpAllHits. "#$tmp[0]:$tmp[-1]";
        }
    }
    $printAll = join ("\t", "$printAll", "$p_value", "$tmpAllHits");
    print "$printAll\n";


    # clean up the last column of @super_diffgenelist and @super_allanno because we store the current hitcount at there. 
    # So we have to clean it up, and step to next loop
    for ($i=0; $i<@super_diffgenelist; $i++){
        my @tmp = split ("\t", $super_diffgenelist[$i]);
        pop @tmp;
        $super_diffgenelist[$i]=join "\t", @tmp;
    }
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