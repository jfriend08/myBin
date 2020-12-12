#!/bin/bash

for i in $(ls -d *)
do
    cd $i
    printf "\n"$i"\n"
    cp "$i"_exonGeneExpr_Info.txt /aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/exonExpr
    cp "$i"_geneExpr_Info.txt /aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/geneExpr
    cd ..
done
wait
