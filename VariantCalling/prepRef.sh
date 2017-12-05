#!/bin/bash
#Create an idex file which is a tab-delimited file
samtools faidx vShiloni.fasta
#Generate a sequency dictionary using CreateSequenceDictionary 
#Set reference to the file vShiloni.fasta and output to vShiloni.dict
java -jar /usr/local/bin/picard.jar CreateSequenceDictionary \
R=vShiloni.fasta O=vShiloni.dict \
1>prepRef.log 2>prepRef.err &
