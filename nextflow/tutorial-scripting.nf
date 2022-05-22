#!/work/work_users/chenjun/soft/linux/miniconda3/envs/nextflow/bin/nextflow run

println '打印 Hello, World!'

//  Lists
myList = [1, new java.util.Date(), -3.1499392, false, true, 'Hi']
println 'myList: ' + myList
println 'myList长度: ' + myList.size()

// Maps
scores = [ 'Brett':100, 'Pete':'demo str var.', 'Andrew':86.87934 ]
println 'scores: ' + scores
println 'scores[\"Pete\"]: ' + scores['Pete'] + scores.Pete
scores['Pete'] = 3
scores['Cedric'] = 120
println scores['Pete'] + ',' + scores['Cedric']

// Multiple assignment 多重赋值
(a, b, c) = [10, 20, 'foo']

// Conditional Execution
x = Math.random()
if ( x < 0.5 ) {
    println 'You lost.'
}
else {
    println 'You won!'
}

// Strings
println "he said 'cheese' once"
println 'he said "cheese!" again'
a = 'world'
print 'hello ' + a + '\n'
print 'hello ' + a

// String interpolation 字符串赋值, 类似于 Bash/shell 脚本, 不同在于可通过使用 ${expression} 语法来包含任何表达式的值
foxtype = 'quick'
foxcolor = ['b', 'r', 'o', 'w', 'n']
println "The $foxtype ${foxcolor.join()} fox. " + "${foxcolor.join('-')}"

x = 'Hello'
println '$x + $y'

// Multi-line strings多行字符串
// 1. 双引号可以变量赋值, 单引号不可以
// 2. 用 \ 字符终止多行字符串中的一行可以防止换行符
text = '''$x
    hello there James
    how are you today?
    ''' + """
    a: $x \
    b: test \
    c: test2
    """
println "多行字符串: $text"

// String replacement 字符串替换
// 要替换给定字符串中出现的模式，请使用 replaceFirst 和 replaceAll 方法：
x = 'colour'.replaceFirst(/ou/, 'o')
println x
// prints: color
y = 'cheesecheese'.replaceAll(/cheese/, 'nice')
println y
// prints: nicenice

// Implicit variables隐式变量
// Script implicit variables 脚本隐式变量
println """
baseDir 基目录: $baseDir
launchDir 启动目录: $launchDir
moduleDir 模块目录: $moduleDir
nextflow 下一个流程: $nextflow
params 参数: $params
projectDir 项目目录: $projectDir
workDir 工作目录: $workDir
workflow 工作流程: $workflow
"""

// Closures 闭包函数
square = { it * it }
println square(9)
test = [ 1, 2, 3, 4 ].collect(square)
println test + '| ' + " ${[ 1, 2, 3, 4 ].collect(square)}"  // 列表可直接追加元素
// 默认情况下，闭包采用一个称为它的参数，但您也可以创建具有多个自定义命名参数的闭包。
// 例如，方法 Map.each() 可以采用带有两个参数的闭包，它将 Map 中每个键值对的键和关联值绑定到该闭包。
printMapClosure = { key, value ->
    println "$key = $value"
}
[ 'Yue' : 'Wu', 'Mark' : 'Williams', 'Sudha' : 'Kumari' ].each(printMapClosure)

// 闭包还有另外两个重要的特性。首先，它可以访问定义范围内的变量，以便与它们交互。
myMap = ['China': 1 , 'India' : 2, 'USA' : 3]

result = 0
myMap.keySet().each( { result += myMap[it] } )

println result

// Regular expressions  正则表达式
// =~ 检查给定模式是否出现在字符串中的任何位置
// 使用 ==~ 检查字符串是否与给定的正则表达式模式完全匹配。
test = 'foo' =~ /foo/
println "RE-test: ${test}"       //  TRUE
assert 'foo' =~ /foo/       // return TRUE
assert 'foobar' =~ /foo/    // return TRUE
// assert 'foobar' =~ /goo/    // raise error.
x = ~/abc/
println "${x.class}  x:$x"  // prints java.util.regex.Pattern
y = 'some string' =~ /abc/
println "${y.class}  y:$y"  // prints java.util.regex.Matcher

// Capturing groups
programVersion = '2.7.3-beta'
m = programVersion =~ /(\d+)\.(\d+)\.(\d+)-?(.+)/
assert m[0] ==  ['2.7.3-beta', '2', '7', '3', 'beta']
assert m[0][1] == '2'
assert m[0][2] == '7'
assert m[0][3] == '3'
assert m[0][4] == 'beta'
programVersion = '2.7.3-beta'
(full, major, minor, patch, flavor) = (programVersion =~ /(\d+)\.(\d+)\.(\d+)-?(.+)/)[0]
println "${[full, major, minor, patch, flavor].join(',')}"

// Removing part of a string删除字符串的一部分  ~/(?i)xxx/
// define the regexp pattern
wordStartsWithGr = ~/(?i)\s+Gr\w+/
// apply and verify the result
println 'Hello Groovy world!' - wordStartsWithGr == 'Hello world!'
println 'Hi Grails users' - wordStartsWithGr == 'Hi users'
// 从字符串中删除第一个 5 个字符的单词：
println 'Remove first match of 5 letter word' - ~/\b\w{5}\b/ == 'Remove  match of 5 letter word'
// 从字符串中删除带有尾随空格的第一个数字：
println 'Line contains 20 characters' - ~/\d+\s+/ == 'Line contains characters'

// Files and I/O文件和 I/O
// 要访问和处理文件，请使用 file 方法，该方法返回给定文件路径字符串的文件系统对象：
myFile = file('some/path/to/my_file.file')
println "myFile: $myFile"
// glob 模式中的两个星号 (**) 与 * 类似，但匹配文件系统路径中的任意数量的目录组件。
listOfFiles = file('./*')
println "listOfFiles: $listOfFiles"
println """
${file('./*', hidden: true)}
"""
// glob: true
// type: file, dir or any (default: file)
// hidden: true
// maxDepth: int
// followLinks: true
// checkIfExists: true

// Basic read/write基本读/写
myFile = file('./my_file.txt')
myFile.text = 'Hello world!\n'  // 文件覆写
print myFile.text
myFile.append('Add this line\n')  // 文件追加
myFile << 'Add a line more\n'  // 文件追加

// 二进制数据可以用同样的方式管理
binaryContent = myFile.bytes
myFile.bytes = binaryContent  // 文件覆写

// Read a file line by line 逐行读取文件
println '逐行读取：'
myFile = file('./my_file.txt')
allLines  = myFile.readLines()
for ( line : allLines ) {
    println line
}

file('./my_file.txt')
    .readLines()
    .each { println it }

// Advanced file reading operations 高级文件读取操作
// 方法 newReader 为给定的文件创建一个 Reader 对象，允许您以单个字符、行或字符数组的形式读取内容：
myFile = file('./my_file.txt')
myReader = myFile.newReader()
String line_tmp1  //【此处不正常！！！？？？】
while ( line_tmp1 = myReader.readLine() ) {
    println "line_tmp1: ${line_tmp1}"
}
myReader.close()
// withReader 方法的工作方式类似，但在您处理完文件后会自动为您调用 close 方法。所以，前面的例子可以更简单地写成：
myFile = file('./my_file.txt')
myFile.withReader {
    String line_tmp2  //【此处不正常！！！？？？】
    while ( line_tmp2 = it.readLine() ) {
        println "line_tmp2: ${line_tmp2}"
    }
}
// 以下是读取文件的最重要方法：
// getText  获取文本, 将文件内容作为字符串值返回
// getBytes  获取字节数, 以字节数组形式返回文件内容
// readLines  读行, 逐行读取文件并将内容作为字符串列表返回
// eachLine  每条线, 逐行迭代文件，应用指定的闭包
// eachByte  每个字节, 逐字节迭代文件，应用指定的闭包
// withReader  与读者, 打开一个文件进行读取，并允许您使用 Reader 对象访问它
// withInputStream  输入流, 打开一个文件进行读取，并允许您使用 InputStream 对象访问它
// newReader  新读者, 返回一个 Reader 对象以读取文本文件
// newInputStream  新输入流, 返回一个 InputStream 对象来读取一个二进制文件

// Advanced file writing operations 高级文件写入操作
sourceFile = file('./my_file.txt')
targetFile = file('./my_file2.txt')
sourceFile.withReader { source ->
    targetFile.withWriter { target ->
        String line_tmp3  //【此处不正常！！！？？？】
        while ( line_tmp3 = source.readLine() ) {
            target << line_tmp3.replaceAll('A', '- A')
        }
    }
}

// 以下是写入文件的最重要方法：
// setText  设置文本, 将字符串值写入文件
// setBytes  设置字节数, 将字节数组写入文件
// write  写, 将字符串写入文件，替换任何现有内容
// append  附加, 将字符串值附加到文件而不替换现有内容
// newWriter  新作家, 创建一个 Writer 对象，允许您将文本数据保存到文件
// newPrintWriter  新打印写入器, 创建一个 PrintWriter 对象，允许您将格式化文本写入文件
// newOutputStream  新输出流, 创建一个允许您将二进制数据写入文件的 OutputStream 对象
// withWriter  与作家, 将指定的闭包应用于 Writer 对象，完成后将其关闭
// withPrintWriter  withPrintWriter, 将指定的闭包应用于 PrintWriter 对象，完成后将其关闭
// withOutputStream  带输出流, 将指定的闭包应用于 OutputStream 对象，完成后将其关闭

// List directory content 列出目录内容
// list 和 listFiles 之间的唯一区别是前者返回一个字符串列表，后者返回一个允许您访问文件元数据的文件对象列表，例如大小、上次修改时间等。
myDir = file('./')
println "myDir: $myDir"
allFiles = myDir.list()
for ( def file : allFiles ) {
    println file
}
// eachFile 方法允许您仅遍历第一级元素（就像 listFiles 一样）。与其他 each- 方法一样，eachFiles 将闭包作为参数：
myDir.eachFile { item ->
    if ( item.isFile() ) {
        println "${item.getName()} - size: ${item.size()}"
    }
    else if ( item.isDirectory() ) {
        println "${item.getName()} - DIR"
    }
}
// 上述方法的几种变体
// eachFile  每个文件, 遍历第一级元素（文件和目录）。阅读更多
// eachDir  每个目录, 仅遍历第一级目录。阅读更多
// eachFileMatch  每个文件匹配, 遍历名称与给定过滤器匹配的文件和目录。阅读更多
// eachDirMatch  每个目录匹配, 遍历名称与给定过滤器匹配的目录。阅读更多
// eachFileRecurse  每个文件递归, 深度优先遍历目录元素。阅读更多
// eachDirRecurse  每个目录递归, 遍历目录深度优先（忽略常规文件）。阅读更多

// Create directories创建目录
// 给定一个表示不存在目录的文件变量，如下所示：
myDir = file('any/path')
result = myDir.mkdir()
println result ? 'OK - create directory' : "Cannot create directory: $myDir"
// 如果父目录不存在，上述方法将失败并返回false。
// mkdirs 方法创建由文件对象命名的目录，包括任何不存在的父目录：
myDir.mkdirs()

// Delete files 删除文件
myFile = file('./link-to-file.txt')
result = myFile.delete()
println result ? 'OK - del' : "Can delete: $myFile"

// Create links 创建链接
myFile = file('/some/path/file.txt')
myFile.mklink('./link-to-file.txt')

// Copy files / Move files 复制/移动文件(夹)
file('my_file.txt').copyTo('new_name.txt')
file('new_name.txt').moveTo('any/path')

// Rename files 重命名文件
file('my_file.txt').copyTo('new_name.txt')
file('new_file_name.txt').delete()
file('new_name.txt').renameTo('new_file_name.txt')

// Check file attributes 检查文件属性
// getName  获取名称, 获取文件名，例如/some/path/file.txt -> file.txt
// getBaseName  获取基名, 获取不带扩展名的文件名，例如/some/path/file.tar.gz -> file.tar
// getSimpleName  获取简单名称, 获取没有任何扩展名的文件名，例如/some/path/file.tar.gz -> 文件
// getExtension  获取扩展, 获取文件扩展名，例如/some/path/file.txt -> txt
// getParent  获取父级, 获取文件父路径，例如/some/path/file.txt -> /some/path
// size  尺寸, 获取以字节为单位的文件大小
// exists  存在, 如果文件存在则返回真，否则返回假
// isEmpty  是空的, 如果文件长度为零或不存在则返回真，否则返回假
// isFile  文件, 如果它是常规文件，则返回 true，例如不是目录
// isDirectory  是目录, 如果文件是目录，则返回 true
// isHidden  是隐藏的, 如果文件被隐藏，则返回 true
// lastModified  最后修改, 返回文件上次修改的时间戳，即与 Linux 纪元时间一样长

// Get and modify file permissions  获取和修改文件权限
println file('new_file_name.txt').getPermissions()
println file('new_file_name.txt').setPermissions('rwxrwxr-x')
println file('new_file_name.txt').setPermissions(7, 6, 5)
println file('new_file_name.txt').getPermissions()

// HTTP/FTP filesHTTP/FTP 文件
// Nextflow 提供 HTTP/S 和 FTP 协议的 文件
// pdb = file('http://files.rcsb.org/header/5FID.pdb')
pdb = file('https://www.taobao.com/robots.txt')
println pdb.text

def sample1 = file('https://www.taobao.com/robots.txt')
println sample1.countLines()

file('./data').mkdirs()

// 名称以 .gz 后缀结尾的文件应该被 GZIP 压缩并自动解压缩。
file('./data/sample.fasta').text = '>a\nACTTG\n>b\nccaaatt'
def sample2 = file('./data/sample.fasta')
println sample2.countFasta()

file('./data/sample.fastq').text = '@aa\nACTTG\n+\nFFFFF'
def sample3 = file('./data/sample.fastq')
println sample3.countFasta()

//
//
//
params.str = 'Hello world!'

process splitLetters {
    output:
    file 'chunk_*' into letters

    """
    printf '${params.str}' | split -b 6 - chunk_
    printf "use: --cpus $task.cpus --mem $task.memory"
    """
}

process convertToUpper {
    input:
    file x from letters.flatten()

    output:
    stdout result

    """
    cat $x | tr '[a-z]' '[A-Z]'
    """
}

result.view { it.trim() }
// 多进程去调用运行的文件，是软链接过去的，无需担心存储问题
