#!/bin/bash

baseCommand='nice -n19 java jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar'

taskRef='-T PrintReads -R vShiloni.fasta -I merged.bam -BQSR recal_data.table -o recal_reads.bam'

$baseCommand $taskRef 1>recal_reads.log 2>recal_reads.err & 
