package main
import (
"fmt"
)

func  main()  {
p2  :=  plusX(6)
fmt.Printf("%v\n",p2(5))
}
func  plusX(x int)  func(int)  int  {
return  func(y  int)  int  {  return  x  +  y  }
}
