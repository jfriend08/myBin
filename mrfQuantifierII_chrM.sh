#!/bin/bash

#make gene expression file
for i in $(ls -d *)
do
    cd $i
    printf "\n"$i"\n"
    cd "$i"_MRFfile
    zcat "$i"*.mrf.gz|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/Annotation/ensembl_chM/chrM_transcript.interval multipleOverlap > /aslab_scratch001/asboner_dat/PeterTest/geneExpr/ensembl_chrM/"$i"_chrM_Expr.txt &
    
    cd ..
    cd ..
done
wait

