red='\033[0;31m'
NC='\033[0m' # No Color

# STARFUSION=/home/ys486/software/STAR-Fusion2/STAR-Fusion/STAR-Fusion

STARFUSION=/home/ys486/software/STAR-Fusion3/STAR-Fusion_v0.8/STAR-Fusion
# LIBDIR=/aslab_scratch001/asboner_dat/PeterTest/Annotation/GRCh37_gencode_v19_CTAT_lib

# STARFUSION=/home/ys486/software/STAR-Fusion.v1.9.1/STAR-Fusion-v1.9.1/STAR-Fusion
LIBDIR=/athena/sbonerlab/store/ys486/Annotation/STAR-fusion_CTAT_RESOURCE_LIB/GRCh37_gencode_v19_CTAT_lib_Apr032020.plug-n-play/ctat_genome_lib_build_dir

echo -e "${red}START: STAR-fusion${NC}"
for i in $(ls -d *); do
if [[ $i != "MRF" && $i != *sh && $i != "bin" && $i != "RGprocessed" ]]; then
  cd $i; printf "$i\n"
  if [ -f "$i"*_Chimeric.out.junction ];
    then
      echo hi
      mkdir starfusion_out
      $STARFUSION --genome_lib_dir $LIBDIR -J "$i"*Chimeric.out.junction --output_dir starfusion_out/&
      echo -e "${red}---------------------------------${NC}"
    else
      echo $i having problSem with STAR-fusion
  fi
  cd ..
fi
done
wait
