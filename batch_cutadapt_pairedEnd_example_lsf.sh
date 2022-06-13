#!/bin/bash

for file in /beevol/home/kimji/DNA-seq/Thurman/210205_A00405_0345_BHT2K3DSXY/*_R1_001.fastq.gz; do
        run() {
        filename=$(basename "$file")
        INPUT1=`echo $filename | perl -ne 'if($_ =~ /((\S+)_R1_001\.fastq\.gz)/){print $1;}'`
        INPUT2=`echo $filename | perl -ne 'if($_ =~ /((\S+)_R1_001\.fastq\.gz)/){print $2, "_R2_001.fastq.gz";}'`

        OUTPUT1=`echo $filename | perl -ne 'if($_ =~ /((\S+)_R1_001\.fastq\.gz)/){print $2. "_R1_001_cutadapt.fastq.gz";}'`
        OUTPUT2=`echo $filename | perl -ne 'if($_ =~ /((\S+)_R1_001\.fastq\.gz)/){print $2. "_R2_001_cutadapt.fastq.gz";}'`

        cmd='
#!/bin/sh
#BSUB -o /beevol/home/kimji/DNA-seq/Thurman/210205_A00405_0345_BHT2K3DSXY/cutadapt.out.%J
#BSUB -e /beevol/home/kimji/DNA-seq/Thurman/210205_A00405_0345_BHT2K3DSXY/cutadapt.err.%J
#BSUB -J cutadapt

cutadapt -a AGATCGGAAGAGC -A AGATCGGAAGAGC -o OUTPUT1 -p OUTPUT2 INPUT1 INPUT2

                '
                cmd=${cmd/INPUT1/$INPUT1};
                cmd=${cmd/INPUT2/$INPUT2};
                cmd=${cmd/OUTPUT1/$OUTPUT1};
                cmd=${cmd/OUTPUT2/$OUTPUT2};

        echo "$cmd" > test_bsub.sh
        bsub < test_bsub.sh
        #`$cmd`
        }
        run
done
