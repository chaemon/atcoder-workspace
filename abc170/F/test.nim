import macros, strformat, sequtils, typetraits

macro `[]`(a: untyped, p: tuple): untyped =
  var strBody = fmt"{a.repr}"
  for i, _ in p.getTypeInst:
    strBody &= fmt"[{p.repr}[{i}]]"
  parseStmt(strBody)

var a = newSeqWith(10, newSeqWith(10, newSeqWith(10, 0)))
a[3][1][4] = 15926

type P = tuple[a,b,c:int]

proc f(p:P) =
  var p:tuple = p
  echo p
  echo a[p]

let p = (3, 1, 4)

echo a[p]
f(p)

