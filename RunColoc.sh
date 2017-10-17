#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --mem=16GB

# File with paths to query summary stats
QRY=<QTL files>
# File with paths to reference summary stats
REF=<immune traits>
# Output file
OUT=ColocResults_1.RData
# Window size for assasing coloc
WIN=250000
# GWAS threshold for loci to asses
THR=5e-6
# Output folder
OUTDIR=coloc_output
# Path to coloc script
COLOC=Colocolization.r
# Path to coloc processing script
COLOC_PROC=ColocProcessing.r

# Make the output dir
mkdir -p $OUTDIR

module load R
module load cairo

echo "--------------------------------------------------"
echo "[INFO]    Starting coloc analysis"
echo "--------------------------------------------------"

Rscript $COLOC -q $QRY -r $REF -s SampleSizesSummaryDatabase.txt -m ReferenceMAF.txt -o $OUTDIR/$OUT -t $THR -f

echo "--------------------------------------------------"
echo "[INFO]    Starting post processing"
echo "--------------------------------------------------"

Rscript $COLOC_PROC -i $OUTDIR/$OUT -q $QRY -r $REF -o $OUTDIR -w $WIN -t 0.5