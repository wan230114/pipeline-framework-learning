
# 1. 准备 nf
ls ./tutorial-Processes2.nf

# 2. 准备输入文件
{
echo "
group,replicate,fastq_1,fastq_2,antibody,control
1week-IP,1,./Rawdata/1week-IP-1_1.fq.gz,./Rawdata/1week-IP-1_2.fq.gz,antibodyName,1week-input
1week-IP,2,./Rawdata/1week-IP-2_1.fq.gz,./Rawdata/1week-IP-2_2.fq.gz,antibodyName,1week-input
3week-IP,1,./Rawdata/3week-IP-1_1.fq.gz,./Rawdata/3week-IP-1_2.fq.gz,antibodyName,3week-input
3week-IP,2,./Rawdata/3week-IP-2_1.fq.gz,./Rawdata/3week-IP-2_2.fq.gz,antibodyName,3week-input
1week-input,1,./Rawdata/1week-input-1_1.fq.gz,./Rawdata/1week-input-1_2.fq.gz,,
1week-input,2,./Rawdata/1week-input-2_1.fq.gz,./Rawdata/1week-input-2_2.fq.gz,,
3week-input,1,./Rawdata/3week-input-1_1.fq.gz,./Rawdata/3week-input-1_2.fq.gz,,
3week-input,2,./Rawdata/3week-input-2_1.fq.gz,./Rawdata/3week-input-2_2.fq.gz,,
" | awk NF > design.csv
}

mkdir ./Rawdata
grep -oP "\./.*gz," ./design.csv | sed 's#,#\n#g' | awk NF | while read x; do >$x; done


rm .nextflow* -rf ; nextflow run "./tutorial-Processes2.nf"

