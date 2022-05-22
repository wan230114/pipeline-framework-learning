#!/work/work_users/chenjun/soft/linux/miniconda3/envs/nextflow/bin/nextflow run
// [Processes — Nextflow 21.04.3 documentation ~ 流程 — Nextflow 21.04.3 文档](https://www.nextflow.io/docs/latest/process.html)

// Processes流程

process sayHello {
    """
    echo 'Hello world!' > file
    """
}

// 一个流程可能包含五个定义块，分别是：
// 指令、输入、输出、when 子句和最后的流程脚本。
// （directives, inputs, outputs, when clause and finally the process script）
// 语法定义如下：
// process < name > {
//    [ directives ]
//    input:
//     < process inputs >
//    output:
//     < process outputs >
//    when:
//     < condition >
//    [script|shell|exec]:
//    < user script to be executed >
// }

// 默认情况下，流程脚本被 Nextflow 解释为 Bash 脚本，但您不限于此。
// 要使用 Bash 以外的脚本，只需使用相应的 shebang 声明启动您的进程脚本。例如：
process pyStuff {
    """
    #!/usr/bin/python

    x = 1
    y = 2
    print "python %s - %s" % (x,y)
    """
}

sequences = file("./data/sample.fasta").text
mode = 'tcoffee'

process align {
    input:
    file seq_to_aln from sequences

    script:
    if( mode == 'tcoffee' )
        """
        echo "t_coffee -in $seq_to_aln > out_file"
        """

    else if( mode == 'mafft' )
        """
        mafft --anysymbol --parttree --quiet $seq_to_aln > out_file
        """

    else if( mode == 'clustalo' )
        """
        clustalo -i $seq_to_aln -o out_file
        """

    else
        error "Invalid alignment mode: ${mode}"

}


sequences = Channel.fromPath('./data/*.fa')
methods = ['regular', 'expresso']
libraries = [ file('PQ001.lib'), file('PQ002.lib'), file('PQ003.lib') ]

process alignSequences {
  input:
  file seq from sequences
  each mode from methods
  each file(lib) from libraries

  """
  echo t_coffee -in $seq -mode $mode -lib $lib >>shell.sh
  """
}
