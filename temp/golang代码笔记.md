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


