#!/usr/bin/env python
import sys
import re

#WhiteFile = '/aslab_scratch001/asboner_dat/PeterTest/Annotation/WhiteList/WhiteList.txt'
WhiteFile = '/aslab_scratch001/asboner_dat/PeterTest/Annotation/WhiteList/WhiteList_chr1q22-1q23.txt'
GeneList = '/aslab_scratch001/asboner_dat/PeterTest/Annotation/WhiteList/CUAC1418_geneExpr_Info.txt'

# """
# This is for matching purpose.
# Try to match the gene name to our current annotation gene name
# """
# myfile = open(GeneList, "r")
# geneList_dict = {}
# for line in myfile:
#   line = line.rstrip()
#   fields = line.split('\t')
#   gene = fields[1]
#   geneList_dict[gene] = gene

# myfile = open(WhiteFile, "r")
# white_dict = {}
# for gene in myfile:
#   gene = gene.rstrip()
#   try:
#     geneList_dict[gene]
#   except:
#     print("Not matched: ", gene)

myfile = open(WhiteFile, "r")
white_dict = {}
for gene in myfile:
  gene = gene.rstrip()
  white_dict[gene] = gene


for line in sys.stdin:
  line = line.strip()
  fields = line.split('\t')
  gene1 = fields[26]
  gene2 = fields[27]
  try:
    if(white_dict[gene1] or white_dict[gene2]):
      print (line)
  except:
    continue