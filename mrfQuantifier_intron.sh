#!/bin/bash
OUTPATH=$1

if [[ "${OUTPATH}" == "" ]];
then
  echo "mrfQuantifier_intron.sh <output path>"
  exit 1;
fi


# #make gene expression file
 for i in $(ls -d *)
 do
    cd $i
    printf "\n"$i"\n"
    zcat $(ls "$i"*.mrf.gz)|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/intronExpression/allIntron_200piece_up_downstream_RTK.interval multipleOverlap >"$OUTPATH"/"$i"_intronExpr.txt &
    cd ..
 done
 wait