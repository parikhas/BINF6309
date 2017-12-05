#!/bin/bash
mkdir -p vcf
findVariants(){
for bam in noDup/*.bam
do
vcfOut="${bam/noDup/vcf}"
vcfOut="${vcfOut/bam/vcf}"
#Find variants in vShiloni.fasta using the HaplotypeCaller 
#Put the reference model with GVCF format as the mode for emitting reference confidence scores
#Specify LINEAR variant_index_type to create linear Index with bins of width of 128000
#Use minimun phred-scaled confidence threshold of 30
#Use DISCOVERY genotyper to choose the most likely alternate allele

nice -n19 java -jar /usr/local/programs/GenomeAnalysisTK-3.8-0/GenomeAnalysisTK.jar \
-T HaplotypeCaller --emitRefConfidence GVCF -R vShiloni.fasta -I $bam --genotyping_mode DISCOVERY \
-variant_index_type LINEAR -variant_index_parameter 128000 \
-stand_call_conf 30 -nct 16 -o $vcfOut
done
}
findVariants 1>findVariants.log 2>findVariants.err &
