#!/bin/bash
#SNP_new.sh 800 2 40 /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BWA/BCFfiles_Paired/ /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BWA/OUTfiles_Paired/
Dval=$1
dval=$2
Qval=$3
BCFDIR=$4
OUTDIR=$5
# Dval=$3
# Qval=$4
echo $OUTDIR
printf "\nDval=$Dval\ndval=$dval\nQval=$Qval\nBCFDIR=<$BCFDIR>\nOUTDIR=<$OUTDIR>\n"
[[ "${BCFDIR}" == "" ]] && [[ "${OUTDIR}" == "" ]] && [[ "${Dval}" == "" ]] && [[ "${dval}" == "" ]] && [[ "${Qval}" == "" ]] && exit

# ####bam2bcfIII####
# cd ./STAR
# for i in $(ls -d *); do
# if [ $i != "MRF" ]; then
#     cd $i; printf "\n$i bam2bcfIII start\n"
#     samtools mpileup -DSuf /pbtech_mounts/fdlab_store003/fdlab/genomes/human/hg19/genome/hg19_nh.fa ./"$i"*.sorted.bam | bcftools view -bvcg  -> ./"$i"_noT_noPairIII.bcf &
#     cd ..
# fi
# done
# wait
# cd ..
# printf "\n ================================ \n"
####bcf quality filter####
cd ./STAR
for i in $(ls -d *); do
if [ $i != "MRF" ]; then
    cd $i; printf "\n$i quality filter start\n"
    NAME1="$i"_Paired.bcf
    NAME2="$i"_Paired_q"$Qval"_D"$Dval"_d"$dval".vcf
    # NAME1="$i"_noT_noPairIII.bcf
    # NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".vcf
    echo "NAME1 = $NAME1" ; echo "NAME2 = $NAME2"
    CON=-D"$Dval"; echo "CON = $CON"
    CON2=\$6">${Qval}"; echo "CON2 = $CON2"
    bcftools view "$NAME1"|gawk $(echo $CON2)|vcfutils.pl varFilter -D $(echo $Dval) -d $(echo $dval) > ./"$NAME2" 2>"$i"_bcftools_varFilter.log &
    cd ..
fi
done
wait
cd ..

printf "\n ================================ \n"

####variant_effect_predictor start####
cd ./STAR
for i in $(ls -d *); do
if [ $i != "MRF" ]; then
    cd $i;printf "\n$i variant_effect_predictor start\n"
    NAME2="$i"_Paired_q"$Qval"_D"$Dval"_d"$dval".vcf
    NAME3="$i"_Paired_q"$Qval"_D"$Dval"_d"$dval".txt    
    # NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".vcf
    # NAME3="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".txt    
    echo "NAME2 = $NAME2" ; echo "NAME3 = $NAME3"
    perl /home/ys486/software/VEP/ensembl-tools-release-75/scripts/variant_effect_predictor/variant_effect_predictor.pl -i ./"$NAME2"  -o ./"$NAME3" --cache --dir "/home/ys486/.vep" --offline --refseq --species "homo_sapiens" --sift b --everything --force_overwrite --fork 4 2>"$i"_VEP.log &
    cd ..
fi
done
wait
cd ..

####variant_effect_predictor start####
cd ./STAR
for i in $(ls -d *); do
if [ $i != "MRF" ]; then
    cd $i;printf "\n$i variant_effect_predictor start\n"
    NAME1="$i"_Paired.bcf
    NAME2="$i"_Paired_q"$Qval"_D"$Dval"_d"$dval".vcf
    NAME3="$i"_Paired_q"$Qval"_D"$Dval"_d"$dval".txt
    NAME4="$i"_Paired_q"$Qval"_D"$Dval"_d"$dval".txt_summary.html    


    # NAME1="$i"_noT_noPairIII.bcf
    # NAME2="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".vcf
    # NAME3="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".txt
    # NAME4="$i"_noT_noPair_q"$Qval"_D"$Dval"_d"$dval".txt_summary.html    
    echo "NAME2 = $NAME2" ; echo "NAME3 = $NAME3" ; echo "NAME4 = $NAME4"
    cp ./"$NAME1" ${BCFDIR} &
    cp ./"$NAME2" ./"$NAME3" ./"$NAME4" ${OUTDIR} &
    gzip ./"$NAME3"

    cd ..
fi
done
wait
cd ..







    