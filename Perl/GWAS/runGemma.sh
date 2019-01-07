#!/bin/bash

gemma -bfile famEpilepsy -gk 2 -o Epilepsy 

gemma -bfile famEpilepsy -k output/Epilepsy.sXX.txt -eigen -o Eigen

gemma -bfile famEpilepsy -d output/Eigen.eigenD.txt \
-u output/Eigen.eigenU.txt -lmm 1 -o Wald
