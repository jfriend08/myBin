
SYMBOLIC=$1
#PWD=$(pwd)
#echo $PWD
printf "SYMBOLIC_DIR=<$SYMBOLIC>\n"
if [[ "${SYMBOLIC}" == "" ]];
then
	exit 1;
fi

red='\033[0;31m'
NC='\033[0m' # No Color

STARFUSION=/home/ys486/software/STAR-Fusion/STAR-Fusion



echo -e "${red}START: gzip chimeric.sam and junction files${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" && $i != "RGprocessed" ]]; then
    cd $i; printf "$i\n"
    if [ -f $i*chimericPE.sorted.bam ];
      then
        samtools view -h $i*chimericPE.sorted.bam |gzip > "$i"_Chimeric.out.sam.gz &
      else
        echo $i no Chimeric.out.bam
        echo $i no Chimeric.out.bam >> $1/probleSamples.txt
    fi

    if [ -f $i*Chimeric.out.junction ];
      then
        gzip $i*Chimeric.out.junction &
      else
        echo $i no Chimeric.out.junction
        #echo $i no Chimeric.out.junction >> $1/probleSamples.txt
    fi
    cd ..
fi
done
wait


echo -e "${red}START: STAR-fusion${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" && $i != "RGprocessed" ]]; then
  cd $i; printf "$i\n"
  #if [ -f "$i"_Chimeric.out.sam.gz ];
  if [ -f "$i"_Chimeric.out.sam.gz -a -f "$i"*_Chimeric.out.junction.gz ];
  #if [[ -f "$i"_Chimeric.out.sam.gz && -f "$i"*_Chimeric.out.junction.gz ]];
    then
      echo hi
      $STARFUSION -S "$i"_Chimeric.out.sam.gz -J "$i"*Chimeric.out.junction.gz &
      echo -e "${red}---------------------------------${NC}"
    else
      echo $i having problem with STAR-fusion
      #echo $i having problem with STAR-fusion >> $1/probleSamples.txt
  fi
  cd ..
fi
done
wait



echo -e "${red}START: Moving files to directory and cleanup${NC}"
for i in $(ls -d *); do
  if [[ $i != "MRF" && $i != *sh && $i != "bin" && $i != "RGprocessed" ]]; then
    cd $i; printf "$i\n"; echo star-fusion*final*;
    for file in $(ls star-fusion*final*); do
      cp $file $SYMBOLIC/"$i"_"$file"
      echo -e "${red}---------------------------------${NC}"
    done
    cd ..
fi
done
wait
