#!/bin/bash

baseCommand='nice -n20 java -jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar'

taskRef='-T BaseRecalibrator -nct 16 -R vShiloni.fasta -I merged.bam -knownSites filteredSnps.vcf -BQSR recal_data.table -o post_recal_data.table'

$baseCommand $taskRef 1>post_recal_data.log 2>post_recal_data.err &
