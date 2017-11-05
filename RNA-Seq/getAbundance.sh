#!/bin/bash
#Take transcriptome file and the output directory as two arguments
transcriptome=$1
outPath=$2
trinityPath='/usr/local/programs/trinityrnaseq-2.2.0'
#Set variable for the paired path which contains trimmed reads
pairedPath='Paired/'
#Set variables for the left and right suffixes
leftSuffix='.R1.fastq'
rightSuffix='.R2.fastq'
#make sure the output directory exists
mkdir -p $outPath
logSuffix='.log'
errSuffix='.err'
#loop through the left reads in the paired directory
for leftReads in $pairedPath*$leftSuffix
do	
	#Replace left suffix with right suffix in the leftReads variable
	rightReads="${leftReads/$leftSuffix/$rightSuffix}"
	#remove the path and suffix from leftReads and put that in a variable
	sample="${leftReads/$pairedPath/}"
	sample="${sample/$leftSuffix/}"
	#Run align_and_estimate_abundance.pl with type FR for strand specific forward reverse repeats and thread count 1
	nice -n19 $trinityPath/util/align_and_estimate_abundance.pl \
	--transcripts $transcriptome --aln_method bowtie2 --est_method eXpress \
	--trinity_mode --output_dir $outPath$sample --seqType fq --SS_lib_type FR \
	--left $leftReads --right $rightReads --thread_count 1\
	1>$outPath$sample$logSuffix 2>$outPath$sample$errSuffix &
done
