#!/bin/bash
## example: SNP_report_whole.sh /zenodotus/sbonerlab/scratch/SoftTissues_MSKCC/ys486/BWA/proc_10062014
OUTDIR=$1
printf "\nOUTDIR=<$OUTDIR>\n"
[[ "${OUTDIR}" == "" ]] && exit



SNP_report.pl ${OUTDIR} 0 25 &
SNP_report.pl ${OUTDIR} 25 50 &
SNP_report.pl ${OUTDIR} 50 75 &
SNP_report.pl ${OUTDIR} 75 100 &
SNP_report.pl ${OUTDIR} 100 125 &
SNP_report.pl ${OUTDIR} 125 150 &
SNP_report.pl ${OUTDIR} 150 175 &
SNP_report.pl ${OUTDIR} 175 200 &
SNP_report.pl ${OUTDIR} 200 225 &
SNP_report.pl ${OUTDIR} 225 250 &
SNP_report.pl ${OUTDIR} 250 275 &
SNP_report.pl ${OUTDIR} 275 300 &
SNP_report.pl ${OUTDIR} 300 325 &
SNP_report.pl ${OUTDIR} 325 340 &




# # SNP_report.pl ${OUTDIR} 0 1 PED &
# SNP_report.pl ${OUTDIR} 0 25 IMT &
# SNP_report.pl ${OUTDIR} 25 50 IMT &
# SNP_report.pl ${OUTDIR} 50 75 IMT &
# SNP_report.pl ${OUTDIR} 75 100 IMT &
# SNP_report.pl ${OUTDIR} 100 125 IMT &
# SNP_report.pl ${OUTDIR} 125 150 IMT &
# SNP_report.pl ${OUTDIR} 150 175 IMT &
# SNP_report.pl ${OUTDIR} 175 200 IMT &
# SNP_report.pl ${OUTDIR} 200 225 IMT &
# SNP_report.pl ${OUTDIR} 225 250 IMT &
# SNP_report.pl ${OUTDIR} 250 275 IMT &
# SNP_report.pl ${OUTDIR} 275 300 IMT &
# SNP_report.pl ${OUTDIR} 300 325 IMT &
# SNP_report.pl ${OUTDIR} 325 340 IMT &

