#!/bin/bash
##This is the step for unzip the files
GENE1="NTRK3"
GENE2="uc004dem.3|uc004den.3|uc004deo.3|uc004dep.3|uc004deq.3|uc010nhb.2"
GENE3="NTRK1"
GENE4="NTRK2"
GENE5="uc002ioz.3"
GENE6="NTF3"

#GENE6="uc001smz.2" #NAB2
#GENE7="uc001sna.2|uc009zpe.2|uc009zpf.2|uc009zpg.2|uc010srb.1|uc010src.1|uc010srd.1" #STAT6
#GENE8="NTRK3"

#GENE9="uc002rmy.2|uc010ymo.1" #ALK
#GENE10="BCORL1"
#GENE11="NTRK3"
#GENE12="NTRK1"
# GENE13="EPB41L4B"

# GENE14="uc001jak.1|uc001jal.2|uc010qez.1" #RET
# GENE15="NCOA4"
# GENE16="TRIO"
# GENE17="LRRK2"
# GENE18="BMP7"
# GENE19="DROSHA"
# GENE20="NPEPL1"
# GENE21="ADCY2"
# GENE22="DOK5"
# GENE23="NCOA1"
# GENE24="LBH"
# GENE25="ADCY2"
# GENE26="SEMA5A"
# GENE27="DNMT3A"
# GENE28="FBXL7"
# GENE29="NHSL2"
# GENE30="NFIX"
# GENE31="DNMT3A"


echo $GENE1;
echo $GENE2; echo $GENE3;
echo $GENE3; echo $GENE4;
echo $GENE5; echo $GENE6;
echo $GENE7; echo $GENE8;
# echo $GENE9; echo $GENE10;

for i in $(ls -d *)
do
    CURRENT=$(pwd); echo $CURRENT
    zcat "$i"|grep -P "$(echo $GENE1)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE1"
    zcat "$i"|grep -P "$(echo $GENE2)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"BCOR"
    zcat "$i"|grep -P "$(echo $GENE3)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE3"
    zcat "$i"|grep -P "$(echo $GENE4)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE4"
    zcat "$i"|grep -P "$(echo $GENE5)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"NGFR"
    zcat "$i"|grep -P "$(echo $GENE6)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE6"
    # cat "$i"|grep -P "$(echo $GENE7)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"STAT6"
    # cat "$i"|grep -P "$(echo $GENE8)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE8".txt
    # cat "$i"|grep -P "$(echo $GENE9)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"ALK".txt
    # cat "$i"|grep -P "$(echo $GENE10)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE10".txt
    # cat "$i"|grep -P "$(echo $GENE11)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE11".txt
    # cat "$i"|grep -P "$(echo $GENE12)"|cut -f 3,5 |sort -k1 -n > ~/GeneExpr_pf/"$i"_"$GENE12".txt
    # zcat "$i"|grep -P "$(echo $GENE11)"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE11".txt
    # zcat "$i"|grep -P "$(echo $GENE12)"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE12".txt
    # zcat "$i"|grep -P "$(echo $GENE13)"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # zcat "$i"|grep -P "$(echo $GENE14)"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"RET".txt
    # zcat "$i"|grep -P "$(echo $GENE15)"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE15".txt


    # grep -P "$(echo $GENE1)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"BCOR".txt
    # grep -P "$(echo $GENE2)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE2".txt
    # grep -P "$(echo $GENE3)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"USP4".txt
    # grep -P "$(echo $GENE4)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"DPH1".txt
    # grep -P "$(echo $GENE5)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE5".txt
    # grep -P "$(echo $GENE6)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE6".txt
    # grep -P "$(echo $GENE7)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE7".txt
    # grep -P "$(echo $GENE8)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE8".txt
    # grep -P "$(echo $GENE9)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"PARD3".txt
    # grep -P "$(echo $GENE10)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE10".txt
    # grep -P "$(echo $GENE11)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE11".txt
    # grep -P "$(echo $GENE12)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"LDHA".txt
    # grep -P "$(echo $GENE13)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE14)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE15)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE16)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE17)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE18)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE19)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE20)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE21)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE22)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE23)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE24)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE25)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE26)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE27)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE28)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE29)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE30)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt
    # grep -P "$(echo $GENE31)" "$i"|cut -f 3,5 |sort -k1 -n > ~/GeneExprIII/"$i"_"$GENE13".txt



done
wait
