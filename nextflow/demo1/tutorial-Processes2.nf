#! rm .nextflow* -rf ; nextflow run

// export NXF_DEFAULT_DSL=1

ch_input = file("./design.csv")

process CHECK_DESIGN {
    tag "$design"
    publishDir "testout/pipeline_info", mode: params.publish_dir_mode

    input:
    path design from ch_input

    output:
    path 'design_reads.csv' into ch_design_reads_csv
    path 'design_controls.csv' into ch_design_controls_csv

    script:  // This script is bundled with the pipeline, in nf-core/chipseq/bin/
    """
    check_design.py $design design_reads.csv design_controls.csv
    """
}

ch_design_reads_csv
    .splitCsv(header:true, sep:',')
    .map { row -> [ row.sample_id, [ file(row.fastq_1, checkIfExists: true), file(row.fastq_2, checkIfExists: true) ] ] }
    .into { ch_raw_reads_fastqc;
            ch_raw_reads_trimgalore }

ch_design_controls_csv
    .splitCsv(header:true, sep:',')
    .map { row -> [ row.sample_id, row.control_id, row.antibody, row.replicatesExist.toBoolean(), row.multipleGroups.toBoolean() ] }
    .set { ch_design_controls_csv }

// print("ch_raw_reads_fastqc.view()")
// ch_raw_reads_fastqc.view()    // 这里面打印和读取了的话，下面的执行就会报错，这里有点类似于Python里面的迭代器

// print("ch_raw_reads_trimgalore.view()")
// ch_raw_reads_trimgalore.view()

// print("ch_design_controls_csv.view()")
// ch_design_controls_csv.view()

process FASTQC {
    tag "$name"
    label 'process_low_best'
    publishDir "testout/fastqc"

    input:
    tuple val(name), path(reads) from ch_raw_reads_fastqc


    output:
    path "${name}.0" into ch_fastqc_reports_mqc

    script:
    """
    echo -e "${name}\t${reads}" >${name}.0
    """
}

// ch_fastqc_reports_mqc_join = Channel.create()
// result=""
// ch_fastqc_reports_mqc
//     .subscribe onNext: { result += " $it " }, onComplete: { ch_fastqc_reports_mqc_join << result   }  // 子命名空间

// println "result:$result" + "a"
// println "ch_fastqc_reports_mqc_join:$ch_fastqc_reports_mqc_join"
// println "result2:$result2" + "a"

process FASTQC2 {
    tag "allSamples"
    label 'process_low_best'
    publishDir "testout/fastqc2"

    input:
    path FILE from ch_fastqc_reports_mqc.collect()
    // 参考： [Nextflow Patterns](https://nextflow-io.github.io/patterns/index.html), Google key word: “Nextflow multiple input files”

    output:
    path '*.1' into ch_fastqc_reports_mqc2

    script:

    """
    echo -e "all\t$FILE" >all.1
    """
}

