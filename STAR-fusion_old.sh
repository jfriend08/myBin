SYMBOLIC=$1
PWD=$(pwd)
echo $PWD
printf "SYMBOLIC_DIR=<$SYMBOLIC>\n"
if [[ "${SYMBOLIC}" == "" ]]; 
then
	exit 1;
fi

red='\033[0;31m'
NC='\033[0m' # No Color

PICAR=/home/ys486/software/picard/picard-tools-1.130/picard.jar
PL=illumina
LB=Human
PU=ACAGTG


echo -e "${red}START: AddOrReplaceReadGroups${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" ]]; then
    cd $i/*_SAMfile; printf "$i\n"; echo $(pwd)  
    java -jar -Xmx1024m $PICAR  AddOrReplaceReadGroups VALIDATION_STRINGENCY=SILENT INPUT=./"$i"_Aligned.out_F256_filtered_samSort.bam OUTPUT=./"$i".sorted_RG.bam RGPL=$PL RGLB=$LB RGPU=$PU RGSM=$i &
    cd ../..
fi
done
wait

echo -e "${red}START: Samtools sorting ${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" ]]; then
    cd $i/*_SAMfile; printf "$i\n"; echo $(pwd)
    samtools sort -@4 ./"$i".sorted_RG.bam ./"$i".sorted_RG &
    cd ../..
fi
done
wait

echo -e "${red}START: MarkDuplicates${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" ]]; then
    cd $i/*_SAMfile; printf "$i\n"; echo $(pwd)  
	java -jar -Xmx1024m $PICAR MarkDuplicates VALIDATION_STRINGENCY=SILENT INPUT=./"$i".sorted_RG.bam OUTPUT=./"$i".sorted_RG_dup.bam METRICS_FILE=duplicatedMatrix &
    cd ../..
fi
done
wait



echo -e "${red}START: Remove file and samtools index${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" ]]; then
    cd $i/*_SAMfile; printf "$i\n"; echo $(pwd)  
	rm "$i"*.sorted_RG.bam
	samtools index ./"$i".sorted_RG_dup.bam &
    cd ../..
fi
done
wait




echo -e "${red}START: MaKe symbolic links${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" ]]; then
    cd $i/*_SAMfile; printf "$i\n"; echo $(pwd)  
	ln -s $PWD/"$i".sorted_RG_dup.bam* $SYMBOLIC &
    cd ../..
fi
done
wait




