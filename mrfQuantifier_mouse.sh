#!/bin/bash

INTERVALFILE = /aslab_scratch001/asboner_dat/PeterTest/Annotation/genome/mouse/annotation/Mus_musculus.GRCm38.80.chr_onlyGene.interval
OUTPATH = /aslab_scratch001/asboner_dat/PeterTest/geneExpr/mouse
# #make gene expression file
 for i in $(ls -d *)
 do
    cd $i
    printf "\n"$i"\n"
    zcat "$i"*.mrf.gz|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/Annotation/genome/mouse/annotation/Mus_musculus.GRCm38.80.chr_detailed.interval multipleOverlap > /aslab_scratch001/asboner_dat/PeterTest/geneExpr/mouse/detailedAnno/"$i"_geneExpr.txt &
    cd ..
 done
 wait
