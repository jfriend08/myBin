#!/bin/bash
# Goal:  to collect all normal bam and make symbolic link to a folder
# Usage: collect_AllBAMs.sh <1/2> (1: for original directory management; 2: for new directory management) 



##Sorting
if [ $1 == "1" ]; then
  for i in $(ls -d *); do
      echo $i
      BASEDIR=$(pwd)
      ln -s $BASEDIR/$i/"$i"_SAMfile/"$i"_Aligned.out_F256_filtered_samSort.bam /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BAMfiles/"$i".bam
      ln -s $BASEDIR/$i/"$i"_SAMfile/"$i"_Aligned.out_F256_filtered_samSort.bam.bai /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BAMfiles/"$i".bam.bai
  done

elif [ $1 == "0" ]; then
  for i in $(ls -d *); do
    if [ $i != "MRF" ]; then      
      echo $i
      BASEDIR=$(pwd)
      ln -s $BASEDIR/$i/"$i"*.sorted.bam /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BAMfiles/"$i".bam          
      ln -s $BASEDIR/$i/"$i"*.sorted.bam.bai /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BAMfiles/"$i".bam.bai
    fi
  done  
fi