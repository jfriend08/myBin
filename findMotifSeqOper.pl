#!/usr/bin/perl -w
#use strict;
# usage: findMotifSeqOper.pl <IC_threshold>
# example: findMotifSeqOper.pl 0.25

# Note: the take HOCOMOCOv9_AD_TRANSFAC.txt as reference
# Todo: the IC_Value may still need to consider more

use 5.010;
use Cwd;
my $IC_threshold=shift;
print"##IC value threshold: $IC_threshold\n";

my @correct_TF=();
my %MotifSeq =();
############################################################################################################################################

open (TF_FILE, "HOCOMOCOv9_full_TRANSFAC.txt") or die "cannot open TF_FILE";
my @Tf_file = <TF_FILE>;
#my @all_TF_names=grep (/BF/,@Tf_file);
#print scalar(@all_TF_names), "---all\n";
for ($i=0;$i<@Tf_file;$i++){
    chomp $Tf_file[$i];
    if ($Tf_file[$i] =~ m/BF/){
        my @tmp_element=split (" ", $Tf_file[$i]);  # file is seperated by one space    
        my @currentTF=split("_", $tmp_element[1]);
        my $check =1;
        $i=$i+2;
        print "$currentTF[0]\t";
        while ($check==1){
            $i++;
            if ($Tf_file[$i] =~ m/[0-9][0-9]/){
                my @tmp_elements=split(" ", $Tf_file[$i]);
                my $result=motifCalculation($tmp_elements[1], $tmp_elements[2], $tmp_elements[3], $tmp_elements[4]);
                substr($result, 0, 1) = "" ;
                if (length $result>1){
                    #push (@{$MotifSeq{"$currentTF[0]"}}, join ("\t", $result));
                    print "[$result]";
                }
                else{
                    print "$result";
                    #push (@{$MotifSeq{"$currentTF[0]"}}, join ("\t", $result));
                    #$MotifSeq{"$currentTF[0]"}= join ("\t", $tmp_elements[1], $tmp_elements[2], $tmp_elements[3], $tmp_elements[4])
                    #print "$currentTF[0] $tmp_elements[1] $tmp_elements[2] $tmp_elements[3] $tmp_elements[4]---$result\n";
                }                
            }
            else{
                $check=0;
                print "\n";
            }
        }
    }
}


# for my $key (keys %MotifSeq){
#     my @value = @{$MotifSeq{$key}};
#     print "$key\t";
#     for ($i=0; $i<@value; $i++){
#         if (length $value[$i]>1){
#             print "[$value[$i]]";
#         }
#         else {
#             print "$value[$i]";
#         }
#         if ($i==scalar @value-1){
#             print "\n";
#         }

#     }
# }

exit;

sub motifCalculation{    
    my ($A, $C, $G, $T)= (@_);
    my $txt="#";
    $A++; $C++; $G++; $T++;
    #print "$A, $C, $T, $G\n";
    my $currentSUM=$A+$C+$G+$T ;    
    my $background=$currentSUM/4;
    my $tmpA=($A/$currentSUM)*log2($A/$currentSUM);
    my $tmpC=($C/$currentSUM)*log2($C/$currentSUM);
    my $tmpG=($G/$currentSUM)*log2($G/$currentSUM);
    my $tmpT=($T/$currentSUM)*log2($T/$currentSUM);
    my $IC_Value=log2(4)+$tmpA+$tmpC+$tmpG+$tmpT;
    #print "$IC_Value\n";
    if ($IC_Value<$IC_threshold){
        $txt=join "", $txt, ".";
    }
    if ($IC_Value>=$IC_threshold){
        if ($A>$background){
            $txt=join "", $txt, "A";
        }
        if ($C>$background){
            $txt=join "", $txt, "C";
        }
        if ($G>$background){
            $txt=join "", $txt, "G";
        }
        if ($T>$background){
            $txt=join "", $txt, "T";
        }
    }


    return $txt;
}

sub log2 {
        my $n = shift;
        return log($n)/log(2);
    }

