#!/bin/bash

#sam to bam
for i in $(ls -d *)
do
   cd $i
   printf "\nStart sam to bam\n"
   samtools view -S -h -b -@8 "$i"*_chimericPE.sam > "$i"_chimericPE.bam &
   # samtools view -S -h -b -@8 "$i"_Aligned.out_F256_filtered.sam>"$i"_Aligned.out_F256_filtered.bam &
   # samtools view -S -h -b -@8 "$i"_chim_Align_merged.sam>"$i"_chim_Align_merged.bam &
   #samtools view -S -h -b -@8 "$i"*FJR.sam>"$i"_FJR.bam &
   cd ..
done
wait

##Sorting
for i in $(ls -d *)
do
    cd $i
    printf "\nStart sorting\n"; echo $i 
    ~/bin/samtools sort -@8 "$(ls *_chimericPE.bam)" "$i"_chimericPE.sorted &
    # samtools sort -@8 "$(ls *.bam)" "$i".sorted &
#    samtools sort -@8 "$i"_FJR.bam "$i"_FJR_samSort &
    cd ..

done
wait

##Indexing
for i in $(ls -d *)
do
    cd $i/
    printf "\nStart indexing\n"; echo $i
    samtools index "$i"_chimericPE.sorted.bam &
    # samtools index "$i".sorted.bam &
    cd ..
done
wait



