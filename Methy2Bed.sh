#!/bin/bash


for i in $(ls -d *)
do
   cd $i
   printf "$i\n"
   Methy2Bed.pl "$(ls $i*_probelist.txt)" 2 3 1 50 > "$i"_probelist.bed &
   cd ..
done
wait

for i in $(ls -d *)
do
   cd $i
   printf "start mergeBed\n"
   printf "$i\n"
   mergeBed -i "$(ls $i*_probelist.bed)" -d 500 -n |gawk '$4>2' > "$i"_Probelist_merge500_moreThan2.bed &
   mergeBed -i "$(ls $i*_probelist.bed)" -d 500 -nms |gawk '$4>2' > "$i"_Probelist_merge500_moreThan2_Info.bed &
   cd ..
done
wait

for i in $(ls -d *)
do
   cd $i
   printf "start windowBed\n"
   printf "$i\n"
   windowBed -a /home/asboner/annotations/human/hg19/ucsc/knownGeneAnnotationTranscriptCompositeModel.bed  -b "$(ls $i*_merge500_moreThan2.bed)" -l 6000 -r 500 -sw |sort -k 10 -n -r > "$i"_Probelist_merge500_moreThan2_ucscGenes.bed &
   #windowBed -a /home/asboner/annotations/human/hg19/ucsc/2013.09.10/knownGeneAnnotationTranscriptCompositeModel_nh_2013.09.10.bed  -b "$(ls $i*_merge500_moreThan2.bed)" -l 6000 -r 500 -sw |sort -k 10 -n -r > "$i"_Probelist_merge500_moreThan2_ucscGenes.bed &
   cd ..
done
wait
#/home/asboner/annotations/human/hg19/ucsc/knownGeneAnnotationTranscriptCompositeModel.bed

for i in $(ls -d *)
do
   cd $i
   printf "start Methy2BedAddInfo\n"
   printf "$i\n"
   Methy2BedAddInfo.pl "$(ls $i*_moreThan2_ucscGenes.bed)" "$(ls $i*_probelist.txt)" "$(ls $i*_moreThan2_Info.bed)" 1 27 > "$i"_ucscGenes_Info.bed &
   
   cd ..
done
wait

for i in $(ls -d *)
do
   cd $i
   printf "start QuantifierMatcher\n"
   printf "$i\n"
   QuantifierMatcher.pl "$(ls $i*_ucscGenes_Info.bed)" > "$i"_ucscGenes_Info_matched.bed &
   
   cd ..
done
wait










