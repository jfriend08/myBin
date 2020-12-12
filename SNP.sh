#!/bin/bash
#SNP.sh 1000 2 40 /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/samtools_snps/SUM/BCFfiles/ /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/samtools_snps/SUM/OUTfiles/
Dval=$1
dval=$2
Qval=$3
BCFDIR=$4
OUTDIR=$5
echo $OUTDIR
printf "\nDval=$Dval\ndval=$dval\nQval=$Qval\nBCFDIR=<$BCFDIR>\nOUTDIR=<$OUTDIR>\n"
[[ "${BCFDIR}" == "" ]] && [[ "${OUTDIR}" == "" ]] && [[ "${Dval}" == "" ]] && [[ "${dval}" == "" ]] && [[ "${Qval}" == "" ]] && exit

#Samtools mpilep
for i in $(ls -d *)
do
    cd $i
    cd "$i"_SAMfile
    printf "\nSamtools mpilep start\n"
    samtools mpileup -DSuf /pbtech_mounts/fdlab_store003/fdlab/genomes/human/hg19/genome/hg19_nh.fa ./"$i"_Aligned.out_F256_filtered_samSort.bam | bcftools view -bvcg  -> ./"$i"_noT_noPairIII.bcf &
    cd ..
    cd ..
done
wait

#vcfutils.pl
for i in $(ls -d *)
do
    cd $i
    cd "$i"_SAMfile

    NAME1="$i"_noT_noPairIII.bcf
    NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".vcf
    echo "NAME1 = $NAME1" ; echo "NAME2 = $NAME2"
    CON=-D"$Dval"; echo "CON = $CON"
    CON2=\$6">${Qval}"; echo "CON2 = $CON2"
    bcftools view "$NAME1"|gawk $(echo $CON2)|vcfutils.pl varFilter -D $(echo $Dval) -d $(echo $dval) > ./"$NAME2" &

    # printf "\nvcfutils.pl start\n"
    # bcftools view "$i"_noT_noPairIII.bcf|gawk '$6>40' |vcfutils.pl varFilter -D $(echo $Dval) -d $(echo $dval)  >./"$i"_noT_noPair_q40_D800.vcf &
    cd ..
    cd ..
done
wait


#vcfutils.pl
for i in $(ls -d *)
do
    cd $i
    cd "$i"_SAMfile
    printf "\nvcfutils.pl start\n"  
    NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".vcf
    NAME3="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".txt    
    echo "NAME2 = $NAME2" ; echo "NAME3 = $NAME3"
    perl /home/ys486/software/VEP/ensembl-tools-release-75/scripts/variant_effect_predictor/variant_effect_predictor.pl -i ./"$NAME2"  -o ./"$NAME3" --cache --dir "/home/ys486/.vep" --offline --refseq --species "homo_sapiens" --sift b --everything --force_overwrite --fork 4 &
    # perl /home/ys486/software/VEP/ensembl-tools-release-75/scripts/variant_effect_predictor/variant_effect_predictor.pl -i ./"$i"_noT_noPair_q40_D800.vcf  -o ./"$i"_noT_noPair_q40_D800.txt --cache --dir "/home/ys486/.vep" --offline --refseq --species "homo_sapiens" --sift b --everything --force_overwrite &
    cd ..
    cd ..
done
wait

#move files
for i in $(ls -d *)
do
    cd $i
    cd "$i"_SAMfile
    printf "\nmove files\n"
    NAME1="$i"_noT_noPairIII.bcf
    NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".vcf
    NAME3="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".txt
    NAME4="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".txt_summary.html    
    echo "NAME2 = $NAME2" ; echo "NAME3 = $NAME3" ; echo "NAME4 = $NAME4"
    cp ./"$NAME1" ${BCFDIR} &
    cp ./"$NAME2" ./"$NAME3" ./"$NAME4" ${OUTDIR} &
    gzip ./"$NAME3"



    # NAME1="$i"_noT_noPairIII.bcf
    # NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval".vcf
    # NAME3="$i"_noT_noPair_q"$Qval"_D"$Dval".txt
    # NAME4="$i"_noT_noPair_q"$Qval"_D"$Dval".txt_summary.html    

    # echo "NAME1 = $NAME1" ; echo "NAME2 = $NAME2" ; echo "NAME3 = $NAME3" ; echo "NAME4 = $NAME4"

    # cp ./"$NAME1" ${BCFDIR} &
    # cp ./"$NAME2" ./"$NAME3" ./"$NAME4" ${OUTDIR} &
    # mv ./"$i"_noT_noPair_q40.bcf ${OUTDIR} &
    # mv ./"$i"_noT_noPair_q40_D800.vcf ${OUTDIR} &
    # gzip ./"$NAME3" &

    cd ..
    cd ..
done
wait
