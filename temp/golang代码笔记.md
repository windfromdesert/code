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

### 写入文本

写入已有文件：

    alltext = strings.Replace(alltext,"归档文章：</p>",indexln,1)
    fin2, err := os.OpenFile(indexfile,os.O_RDWR | os.O_TRUNC,0644)
    defer fin2.Close()
    fin2.WriteString(alltext)
    fin2.Close()

或者先创建文件，再写入：

    func writefile() {
        wFile := "./htm/" + filename
        fout,err := os.Create(wFile)
        defer fout.Close()
        if err != nil {
            fmt.Println(wFile,err)
            return
        }
        wri = head + zw + foot
        fout.WriteString(wri)
    }

### 字符串操作

字符串拆分 Split

    s3 := strings.Split(reg1.ReplaceAllString(s1,s2),"\n")

字符串替换 Replace

    PhotoInfo = strings.Replace(PhotoInfo,"\n","<br />",-1)

### 文件目录操作

    import (
        "os"
        "strings"
        "strconv"
    )

    lujing = "./doc/"
    dir, _ := os.Open(lujing)
    files, _ := dir.Readdir(0)
    var b string
    var c string
    for _, a := range files {
    if !a.IsDir() {
        b = a.Name()
        c = strings.Replace(strings.Split(b,".")[0],"wangbin","",-1)
        d, err := strconv.ParseInt(c,10,64)
        if err != nil {
            panic(err)
        }
        if i<d {
            i = d
        }
    }
  }
  newname = "wangbin" + strconv.FormatInt(i+1,10) + ".htm"
  lastname = "wangbin" + strconv.FormatInt(i,10) + ".htm"
