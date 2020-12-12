#!/bin/bash
GENE=$1
CHR=$2

printf "\nGENE=$GENE\nCHR=$CHR\n"
[[ "${GENE}" == "" ]] && [[ "${CHR}" == "" ]] && exit

for i in $(ls *txt); do
    printf "\n$i\n"
    Chromosome="$CHR"_
    grep $GENE $i|grep $Chromosome|grep "stop_gained\|frameshift_variant\|stop_lost\|inframe_insertion\|inframe_deletion\|missense_variant"
done
wait