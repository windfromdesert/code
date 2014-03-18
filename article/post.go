package main
import (
        "os"
        "fmt"
        "strings"
        "strconv"
)

var i int64=0
var lujing string=""
var newname string
var lastname string
var mode string=""
var text string
var img string
var title string
var wri string=""
var post string
var time string=""
var tag string=""
var tagurl string=""
var tagurlpre string=""
var nav string=""

func main() {
    readtext()
    creattagurl()
    newfilename()
    fmt.Printf("%s\n",newname)
    readmode()
    texttohtml()
    writefile()
}

func newfilename() {
       lujing = "./post/"
       dir, _ := os.Open(lujing)
       files, _ := dir.Readdir(0)
       var b string
       var c []string
       for _, a := range files {
           if !a.IsDir() {
               b = a.Name()
               c = strings.Split(b,"-")
               d, err := strconv.ParseInt(c[0],10,64)
               if err != nil {
                   panic(err)
               }
               if i<d {
                   i = d
                   tagurlpre = strings.Split(c[1],".")[0]
               }
           }
       }
       newname = strconv.FormatInt(i+1,10) + "-" + tagurl + ".htm"
       lastname = strconv.FormatInt(i,10) + "-" + tagurlpre + ".htm"
}

func readmode() {
    modeFile := "article.htm"
    fin,err := os.Open(modeFile)
    defer fin.Close()
    if err != nil {
             fmt.Println(modeFile,err)
             return
     }
     buf := make([]byte, 1024)
     for{
            n, _ := fin.Read(buf)
            if 0 == n { break }
            list := string(buf[:n])
            mode = mode + list
     }

}

func readtext() {
    textFile := "post.mo"
    fin,err := os.Open(textFile)
    defer fin.Close()
    if err != nil {
             fmt.Println(textFile,err)
             return
     }
     buf := make([]byte, 1024)
     alltext := ""
     for{
            n, _ := fin.Read(buf)
            if 0 == n { break }
            alltext = alltext + string(buf[:n])
     }
            sp := strings.Split(alltext,"\r\n\r\n")
            sp2 := strings.Split(sp[0],"\r\n")
            img = strings.Replace(sp2[0],"[img]","",-1)
            time = sp2[1]
            tag = sp2[2]
            temp := sp[0]+"\r\n\r\n"+sp[1]+"\r\n\r\n"
            text = strings.Replace(alltext,temp,"",1)
            title = strings.Replace(sp[1],"## ","",1)
            fmt.Printf("text: %s\n",text)
            fmt.Printf("img's URL is: %s\n",img)

}

func creattagurl() {
    if tag == "散文" {
        tagurl = "prose"
    }
    if tag == "七种武器" {
        tagurl = "equipment"
    }
    if tag == "摄影技术" {
        tagurl = "photography"
    }
    if tag == "摄影学院" {
        tagurl = "school"
    }
    if tag == "论坛" {
        tagurl = "discuss"
    }

}

func texttohtml() {    
    body := "<p>"+strings.Replace(text,"\r\n\r\n","</p><p>",-1)+"</p>"
    meta := "</div><div class=\"meta\">Written on " + time + " | Tag: <a href=\"../archive/" + tagurl + ".htm\">" + tag + "</a>"
    message := "</div><div class=\"mess\"><a href=\"http://www.douban.com/group/heimaphoto/\" target=\"_blank\">留言或讨论请点击这里</a>"
    post = "<h2>" + title + "</h2>" + body + meta + message
    if i == 0 {
        nav = ""
    } else {
        nav = "<a href=\"./" + lastname + "\">上一篇</a>"
    }
}

func writefile() {
    wFile := lujing + newname
    fout,err := os.Create(wFile)
    defer fout.Close()
    if err != nil {
            fmt.Println(wFile,err)
            return
    }
    wri = strings.Replace(mode,"[title]",title,1)
    wri = strings.Replace(wri,"[img]",img,1)
    wri = strings.Replace(wri,"[post]",post,1)
    wri = strings.Replace(wri,"[nav]",nav,1)
    fout.WriteString(wri)
    if i != 0 {
        preFile := lujing + lastname
        prefout, er := os.Open(preFile)
        defer prefout.Close()
        if er != nil {
            fmt.Println(preFile,er)
            return
        }
        buf := make([]byte, 1024)
        alltext := ""
        for{
            n, _ := prefout.Read(buf)
            if 0 == n { break }
            alltext = alltext + string(buf[:n])
        }
        if i == 1 {
            oldtext := "索引页</a> | "
            replacetext := oldtext + "<a href=\"./" + newname + "\">下一篇</a>"
            alltext = strings.Replace(alltext,oldtext,replacetext,1)
            prewr, eerr := os.Create(preFile)
            defer prewr.Close()
            if eerr != nil {
                fmt.Println(preFile,eerr)
                return
            }
            prewr.WriteString(alltext)
        } else {
            oldtext := "上一篇</a>"
            replacetext := oldtext + " | <a href=\"./" + newname + "\">下一篇</a>"
            alltext = strings.Replace(alltext,oldtext,replacetext,1)
            prewr, eerr := os.Create(preFile)
            defer prewr.Close()
            if eerr != nil {
                fmt.Println(preFile,eerr)
                return
            }
            prewr.WriteString(alltext)
        }
    }
}
