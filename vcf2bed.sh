#!/bin/bash
OUTPATH=$1
echo "############ excluding rsID ############";
for sample in $(ls -d *); do
cd $sample; echo "$sample start";
    rm $(ls *_noRS_vep.maf*)
    for i in $(ls -d *_vep.maf); do
        grep -v "rs[0-9]*" "$i" > ./"$i"_noRS_vep.maf &
    done
    wait

cd ..
done
wait


echo "############ vcf2bed ############";

for sample in $(ls -d *); do
cd $sample; echo "$i start";
    for i in $(ls *loh_indel*_noRS_vep.maf); do
        maf2bed.pl $i >$OUTPATH/"$sample"_loh_indel.bed &
    done
    wait

    for i in $(ls *loh_snp*_noRS_vep.maf); do
        maf2bed.pl $i >$OUTPATH/"$sample"_loh_snp.bed &
    done
    wait

    for i in $(ls *somatic_indel*_noRS_vep.maf); do
        maf2bed.pl $i >$OUTPATH/"$sample"_somatic_indel.bed &
    done
    wait

    for i in $(ls *somatic_snp*_noRS_vep.maf); do
        maf2bed.pl $i >$OUTPATH/"$sample"_somatic_snp.bed &
    done
    wait

    for i in $(ls *germ_indel*_noRS_vep.maf); do
        maf2bed.pl $i >$OUTPATH/"$sample"_germ_indel.bed &
    done
    wait

    for i in $(ls *germ_snp*_noRS_vep.maf); do
        maf2bed.pl $i >$OUTPATH/"$sample"_germ_snp.bed &
    done
    wait

cd ..
done
wait

echo "done"

