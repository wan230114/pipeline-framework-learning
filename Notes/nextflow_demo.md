

## 

```bash
git clone https://github.com/lifebit-ai/GATK.git
nextflow run main.nf --help
# nextflow run oliverSI/GATK4_Best_Practice --fastq1 read_R1.fastq.gz --fastq2 read_R2.fastq.gz &>log

conda activate nextflow
nextflow run oliverSI/GATK4_Best_Practice --fastq1 GATK/chr20_testdata/chr20.R1.fq --fastq2 GATK/chr20_testdata/chr20.R2.fq &>log2

moni_ps -s 0.2 nextflow &>moni_ps.txt

```

