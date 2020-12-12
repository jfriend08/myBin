#!/bin/bash

LOCATION1="chrX"


grep "$(echo $LOCATION1)" PEC29_chimericPE.sam |gawk '($4>53358277 && $4 <54434277) || ($8>53358277 && $8<54434277)'>myGrep.sam 
cat head.txt myGrep.sam >myGrepII.sam
cat myGrepII.sam |sam2bed >myGrep.bed
cut -f 1-14 myGrep.bed >myGrepII.bed
mergeBed -i myGrepII.bed -d 500 -n|sort -k 4 -n -r |gawk '($2<53358277 || $2 >54434277)' > tel_RRAGB.txt



# grep chr14 PEC29_chimericPE.sam |gawk '$4>68353320 && $4<68354666'
# grep "$(echo $LOCATION1)" PEC29_chimericPE.sam |gawk '($4>"$(echo $LOCATION1)" && END1="68353320" || ($8>68353320 && $8<68354666)'>myGrep.sam 
