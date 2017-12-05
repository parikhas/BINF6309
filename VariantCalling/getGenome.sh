#!/bin/bash
#Create an array of accession numbers
array=(NZ_CP018308.1 NZ_CP018309.1 NZ_CP018310.1)
#Iterate over the array and get accessions from NCBI
getGenome(){
for acc in "${array[@]}"
do
nice -n19 bp_download_query_genbank.pl -q $acc -f fasta -o $acc.fasta
done 
}
#Call the function in the background
getGenome 1>getGenome.log 2>getGenome.err &
