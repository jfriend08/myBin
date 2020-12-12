#!/bin/bash
set -e
set -u
# findFJRII_dev.pl /aslab_scratch001/asboner_dat/PeterTest/1111_reRun2/STAR/AS194 AS194_ACTTGA_L0078_FJR.sam AS194_ACTTGA_L0078.sorted.bam AS194_ACTTGA_L0078.gfr
#sam to bam
CURRENT=$(pwd)
cd ./STAR
for i in $(ls -d *); do
if [ $i != "MRF" ]; then
    cd $i; printf "\n$i\n"
    samtools view $(ls *FJR.bam) > "$i"_FJR.sam &
    cd ..
fi
done
wait
cd ..

cd ./STAR
for i in $(ls -d *); do
if [ $i != "MRF" ]; then
#if [ $i != "MRF" ] && [ $i != "IMT41" ]; then
#    	cd $CURRENT/GFR.new;
        cd $CURRENT/GFR.noM.new;
    	findFJRII_dev.pl $CURRENT/STAR/$i "$i"_FJR.sam "$i".sorted.bam ./"$i"*.gfr > "$i".FJR.gfr &
    	echo hi
#    	findFJRII_dev.pl $CURRENT/STAR/$i "$i"_FJR.sam "$i"*sorted.bam ./"$i"*.gfr > "$i".FJR.gfr &
    	
fi
done
wait