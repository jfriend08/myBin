#!/bin/bash

#make gene expression file
for i in $(ls -d *)
do
  if [[ -f "$i"/"$i".mrf.gz ]] #if file exist
  then
    printf "\n"$i"\n"
    zcat "$i"/"$i".mrf.gz|mrfQuantifier /athena/sbonerlab/store/ys486/Annotation/transcripts/knownGeneAnnotationTranscriptCompositeModel_nh_2013.09.10.interval multipleOverlap > "$i"/"$i"_geneExpr.txt
    zcat $(ls "$i"/"$i"*.mrf.gz)|mrfQuantifier /athena/sbonerlab/store/ys486/Annotation/transcripts/knownGeneAnnotationExonCompositeModel.interval.noHeader multipleOverlap > $i/"$i"_exonGeneExpr.txt
  fi
done
wait


# #quantifier add info
# for i in `find . -type d`
# do
#     # cd $i
#     # printf "\n"$i"\n"
#     QuantifierAddInfo_gene.pl "$i"/"$i"*_geneExpr.txt>/athena/sbonerlab/store/ys486/geneExpr/new_ucsc/geneExpr/"$i"_geneExpr_Info.txt
#     QuantifierAddInfo_dev.pl "$i"/"$i"_exonGeneExpr.txt >/athena/sbonerlab/store/ys486/geneExpr/new_ucsc/exonExpr/"$i"_exonGeneExpr_Info.txt
#     cd ..
# done
# wait

for i in $(ls -d *)
do
  if [[ -f "$i"/"$i"_geneExpr.txt ]] #if file exist
  then
      echo "processing ..."
      echo "$i"/"$i"*_geneExpr.txt
      QuantifierAddInfo_gene.pl "$i"/"$i"_geneExpr.txt>/athena/sbonerlab/store/ys486/geneExpr/new_ucsc/geneExpr/"$i"_geneExpr_Info.txt
      QuantifierAddInfo_dev.pl "$i"/"$i"_exonGeneExpr.txt >/athena/sbonerlab/store/ys486/geneExpr/new_ucsc/exonExpr/"$i"_exonGeneExpr_Info.txt
  fi
done
wait