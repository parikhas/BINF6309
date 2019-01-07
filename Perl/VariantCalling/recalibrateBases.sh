#!/bin/bash

baseCommand='nice -n19 java -jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar'
taskRef1='-T BaseRecalibrator -nct 16 -R vShiloni.fasta -I merged.bam  -knownSites filteredSnps.vcf' 
    
#taskRef2='-T PrintReads  -R vShiloni.fasta -I merged.bam -BQSR recal_data.table -o recal_reads.bam' 

$baseCommand $taskRef1 -o recal_data.table 1>recal_data.log 2>recal_data.err &

#$baseCommand $taskRef1 -BQSR recal_data.table -o post_recal_data.table &

#$baseCommand $taskRef2 &






