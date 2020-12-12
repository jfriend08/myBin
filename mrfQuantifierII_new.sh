#!/bin/bash

# #make gene expression file
 for i in $(ls -d *)
 do
    cd $i
    printf "\n"$i"\n"
	zcat "$i"*.mrf.gz|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/Annotation/transcripts/knownGeneAnnotationTranscriptCompositeModel_nh_2013.09.10.interval multipleOverlap >./"$i"_geneExpr.txt &
#zcat "$i"*.mrf.gz|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/Annotation/miRNA/miRBase/hsa-miR.interval multipleOverlap > /aslab_scratch001/asboner_dat/PeterTest/geneExpr/miRNA_expr/"$i"_mirExpr.txt &
    zcat $(ls "$i"*.mrf.gz)|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/Annotation/transcripts/knownGeneAnnotationExonCompositeModel.interval multipleOverlap >./"$i"_exonGeneExpr.txt &
    cd ..
 done
 wait


#quantifier add info
for i in $(ls -d *)
do
    cd $i
    printf "\n"$i"\n"
    QuantifierAddInfo_gene.pl "$i"*_geneExpr.txt>/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/geneExpr/"$i"_geneExpr_Info.txt &
    # cat "$i"*_geneExpr.txt|quantifierAddInfo>/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/geneExpr/"$i"_geneExpr_Info.txt &
    QuantifierAddInfo_dev.pl "$i"*_exonGeneExpr.txt >/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/exonExpr/"$i"_exonGeneExpr_Info.txt &
    #cat "$i"_exonGeneExpr.txt|quantifierAddInfo>/aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/"$i"_exonGeneExpr_Info.txt &
    cd ..
done
wait