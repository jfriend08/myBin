#!/bin/bash

perl ~/bin/findChimeric.pl PEC45_chimericPE.sam > PEC45_selectChim.sam
cat PEC45_selectChim.sam|sam2mrf > PEC45_selectChim.mrf