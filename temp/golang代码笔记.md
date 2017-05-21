## golang 代码笔记

第一句一般是：

    package main

### 读文件操作示例：

    import (
        "fmt"
        "io/ioutil"
        "os"
    )

    func main() {
        inputFile := "products.txt" // 在同目录中创建一个文本文件
        buf, err := ioutil.ReadFile(inputFile)
        if err != nil {
            fmt.Fprintf(os.Stderr, "File Error: %s\n", err)
            // panic(err.Error())
            }
        fmt.Printf("%s\n", string(buf))
    }

### 读取特定格式字符：示例为读取 [Title]...[/Title]标签中间的文本

    import (
        "regexp"
    )

    func main() {
        modstring := string(buf) // 假设需要读取的字符包含其中
        reg1 := regexp.MustCompile(`\[Title\]\n(.+)\n\[/Title\]`) // 这里要读取[Title]...[/Title]标签中间的内容
        s1 := reg1.FindString(modstring)
        s2 := "$1"
        Title := reg1.ReplaceAllString(s1,s2)
        fmt.Printf("标题是：%s\n",Title)
    }

