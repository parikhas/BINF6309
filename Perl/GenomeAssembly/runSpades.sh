#!/bin/sh
spades.py -1 SRR.R1.paired.fastq -2 SRR.R2.paired.fastq \
-t 8 \
-m 50 \
-o vibrioAssembly \
1>spades.log 2>spades.err &
