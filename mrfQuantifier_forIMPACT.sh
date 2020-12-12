for i in $(ls -d *)
do
  cd $i
  printf "\n"$i"\n"
  zcat $(ls "$i"*.mrf.gz)|mrfQuantifier /aslab_scratch001/asboner_dat/PeterTest/cnvTest/filePrep/impactProbeTarget_250_noHead.interval multipleOverlap doNotNorm > /aslab_scratch001/asboner_dat/PeterTest/geneExpr/new_ucsc/impactExpr/"$i"_exonGeneExpr.txt &
  cd ..
done
wait