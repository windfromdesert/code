这里是以前写的一段 md 格式转化为 html 格式的代码。

    func mdtohtml() {
        /*段落格式化*/
        reg1 := regexp.MustCompile(`(\r?\n){2,}`)
        rep1 := "</p><p>"
        zw = reg1.ReplaceAllString(zw,rep1)
        zw = strings.Replace(zw,"</p>","",1) + "</p>"
        /* 代码格式化 */
        ll := []int{16,12,8,4,0}
        for _, v := range ll {
            reg21 := regexp.MustCompile(`([ ]{` + strconv.Itoa(v) + `,}[-\d#*][.]?[ ]+(?:[^<]|<[^/]|</[^p]|</p[^>])+?</p>)<p>[ ]{` + strconv.Itoa(v+8) + `,}((?:[^<]|<[^/]|</[^p]|</p[^>])+?)</p>`)
            rep21 := "$1<pre><code>$2</code></pre>"
            zw = reg21.ReplaceAllString(zw,rep21)
        }
        reg22 := regexp.MustCompile(`(<p>[ ]{0,3}[^-\d\s#*](?:[^<]|<[^/]|</[^p]|</p[^>])+?</p>)<p>[ ]{4,}([\s\S]+?)</p>`)
        rep22 := "$1<pre><code>$2</code></pre>"
        zw = reg22.ReplaceAllString(zw,rep22)
        /* 标题格式化 title */
        first, _ := regexp.MatchString(`^[\s]*#+[ ]+[^\r\n]+`,zw)
        if first {
            reg2 := regexp.MustCompile(`^[\s]*#+[ ]+`)
            s1 := reg2.FindString(zw)
            s2 := strings.Replace(s1," ","",-1)
            n1 := len(s2)
            reg3 := regexp.MustCompile(`^[\s]*#+[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
            rep3 := "<h" + strconv.Itoa(n1) + ">" + "$1" + "</h" + strconv.Itoa(n1) + ">" + "$2"
            zw = reg3.ReplaceAllString(zw,rep3)
        }
        reg4 := regexp.MustCompile(`([\r]?\n|<p>)[ ]*#[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
        rep4 := "$1<h1>$2</h1>$3"
        zw = reg4.ReplaceAllString(zw,rep4)
        reg5 := regexp.MustCompile(`([\r]?\n|<p>)[ ]*##[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
        rep5 := "$1<h2>$2</h2>$3"
        zw = reg5.ReplaceAllString(zw,rep5)
        reg6 := regexp.MustCompile(`([\r]?\n|<p>)[ ]*###[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
        rep6 := "$1<h3>$2</h3>$3"
        zw = reg6.ReplaceAllString(zw,rep6)
        reg7 := regexp.MustCompile(`([\r]?\n|<p>)[ ]*####[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
        rep7 := "$1<h4>$2</h4>$3"
        zw = reg7.ReplaceAllString(zw,rep7)
        reg8 := regexp.MustCompile(`([\r]?\n|<p>)[ ]*#####[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
        rep8 := "$1<h5>$2</h5>$3"
        zw = reg8.ReplaceAllString(zw,rep8)
        reg9 := regexp.MustCompile(`([\r]?\n|<p>)[ ]*######[ ]+([^\r\n]+?)([\r]?\n|</p>|<p>)`)
        rep9 := "$1<h6>$2</h6>$3"
        zw = reg9.ReplaceAllString(zw,rep9)
        re9 := regexp.MustCompile(`<p>(<h[\d]>)`)
        rp9 := "$1"
        zw = re9.ReplaceAllString(zw,rp9)
        re10 := regexp.MustCompile(`(</h[\d]>)</p>`)
        rp10 := "$1"
        zw = re10.ReplaceAllString(zw,rp10)
    
        /* 项目符号格式化 */
        reg10 := regexp.MustCompile(`(<p>|\r?\n)[-+*][ ]+`)
        rep10 := "</li><li>$1"
        zw = reg10.ReplaceAllString(zw,rep10)
        reg11 := regexp.MustCompile(`(<li>[\s\S]+?</p>)(<p>[ ]{0,3}[^\s]+[\s\S])`)
        rep11 := "$1</li></ul>$2"
        zw = reg11.ReplaceAllString(zw,rep11)
        reg12 := regexp.MustCompile(`</li>([\s\S]+?</ul>)`)
        rep12 := "<ul>$1"
        zw = reg12.ReplaceAllString(zw,rep12)
        reg13 := regexp.MustCompile(`<li><p>(([^<]|<[^l/]|<l[^i]|<li[^>]|</[^p]|</p[^>])+</li>)`)
        rep13 := "<li>$1"
        zw = reg13.ReplaceAllString(zw,rep13)
        reg14 := regexp.MustCompile(`(<li>([^<]|<[^pl]|<p[^>]|<l[^i]|<li[^>])+)</p></li>`)
        rep14 := "$1</li>"
        zw = reg14.ReplaceAllString(zw,rep14)
        /* 编号格式化 */
        reg15 := regexp.MustCompile(`(<p>|\r?\n)[\d]\.[ ]+`)
        rep15 := "</li><li>$1!"
        zw = reg15.ReplaceAllString(zw,rep15)
        reg16 := regexp.MustCompile(`(<li>(?:<p>|\r?\n)!(?:[^<]|<[^/]|</[^l]|</l[^i]|</li[^>])+?(?:</p>|</pre>))((?:<ul><li>|\r?\n)?(?:<p>|<h[\d]>)[ ]{0,3}[^\s]+[\s\S])`)
        rep16 := "$1</li></ol>$2"
        zw = reg16.ReplaceAllString(zw,rep16)
        reg17 := regexp.MustCompile(`</li>(<li>(?:<p>|\r?\n)![\s\S]+?</ol>)`)
        rep17 := "<ol>$1"
        zw = reg17.ReplaceAllString(zw,rep17)
        reg18 := regexp.MustCompile(`(<li>(?:<p>|\r?\n)?)!`)
        rep18 := "$1"
        zw = reg18.ReplaceAllString(zw,rep18)
        /* 链接格式化 */
        reg19 := regexp.MustCompile(`[\s]{0,3}\[\d\]:[ ]+http[^\r\n]+\r?\n`)
        ii := len(reg19.FindAllString(zw,-1)) + 1
        for iii := 1; iii<ii; iii++ {
            reg20 := regexp.MustCompile(`\[([^\r\n]+)\][ ]?\[` + strconv.Itoa(iii) + `\]([\s\S]+?)\[` + strconv.Itoa(iii) + `\]:[ ]+(http[^\r\n]+)[ ]+\(([^\r\n]+)\)[ ]*\r?\n`)
            rep20 := "<a href=\"$3\" title=\"$4\">$1</a>$2"
            zw = reg20.ReplaceAllString(zw,rep20)
        }
        /* 去除多余的标签 */
        zw = strings.Replace(zw,"<p></p>","",-1)
        fmt.Printf("正文内容是：%s\n",zw)
    }

