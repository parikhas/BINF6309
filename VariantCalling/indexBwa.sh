#!/bin/bash
#Index the vShiloni database in the FASTA format using a linear-time algorith for constructing suffix array
nice -n19 bwa index -p vShiloni -a is vShiloni.fasta \
1>bwaIndex.log 2>bwaIndex.err &

