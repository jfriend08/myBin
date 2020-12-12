#!/bin/bash

#sam to bam
for i in $(ls -d *)
do
#cd $i/"$i"_SAMfile
    cd $i
    echo "$i"
    printf "\nStart IGV counting\n"
#    igvtools count -z 7 -w 25 -e 0 "$i"_Aligned.out_F256_filtered_samSort.bam "$i"_Aligned.out_F256_filtered_samSort.cov2.tdf hg19 &
    igvtools count -z 7 -w 25 -e 0 "$i"*.sorted.bam "$i".sort.cov2.tdf hg19 &
    cd ..
#    cd ..
done
wait
#c/Volumes/NewSpace/0225_Sample/STAR/PEC29/PEC29.sort.cov2.tdf
