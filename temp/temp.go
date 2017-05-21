package main
import (
    "fmt"
    "io/ioutil"
    "os"
    "regexp"
)

func main() {
    inputFile := "products.txt" // 在同目录中创建一个文本文件
    buf, err := ioutil.ReadFile(inputFile)
    if err != nil {
        fmt.Fprintf(os.Stderr, "File Error: %s\n", err)
        // panic(err.Error())
        }
    fmt.Printf("%s\n", string(buf))
    modstring := string(buf)
    reg1 := regexp.MustCompile(`\[Title\]\n(.+)\n\[/Title\]`)
    s1 := reg1.FindString(modstring)
    s2 := "$1"
    Title := reg1.ReplaceAllString(s1,s2)
    fmt.Printf("标题是：%s\n",Title)
}


