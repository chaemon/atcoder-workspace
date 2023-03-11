#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future, strformat
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

# dump {{{
import macros, strformat

macro dump*(n: varargs[untyped]): untyped =
  var a = "stderr.write "
  for i,x in n:
    a = a & fmt""" "{x.repr} = ", {x.repr} """
    if i < n.len - 1:
      a.add(""", ", ",""")
  a.add(""","\n"""")
  parseStmt(a)
# }}}

const YES = "Yes"
const NO = "No"
var N:int
var A:int
var B:int
var C:int
var s:seq[string]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = nextInt()
  B = nextInt()
  C = nextInt()
  s = newSeqWith(N, nextString())
#}}}

proc discardableId[T](x: T): T {.discardable.} =
  return x

macro `:=`(x, y: untyped): untyped =
  var strBody = ""
  if x.kind == nnkPar:
    for i,xi in x:
      strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
  else:
    strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
  strBody &= fmt"discardableId({x.repr})"
  parseStmt(strBody)


proc main() =
  a := [A,B,C]
  ans := newSeq[string]()
  t := a.sum
  if t == 0:
    echo NO;return
  elif t == 1:
    for i in 0..<N:
      if s[i] == "AB":
        if A == 0:
          A.inc
          B.dec
          ans.add "A"
        else:
          A.dec
          B.inc
          ans.add "B"
      elif s[i] == "BC":
        if B == 0:
          B.inc
          C.dec
          ans.add "B"
        else:
          B.dec
          C.inc
          ans.add "C"
      else:
        if C == 0:
          C.inc
          A.dec
          ans.add "C"
        else:
          C.dec
          A.inc
          ans.add "A"
      if A < 0 or B < 0 or C < 0:
        echo NO;return
  else:
    if s[0] == "AB" and A == 0 and B == 0: echo NO;return
    if s[0] == "BC" and B == 0 and C == 0: echo NO;return
    if s[0] == "AC" and C == 0 and A == 0: echo NO;return
    for i in 0..<N:
#      dump(A, B, C, s[i])
      if s[i] == "AB":
        if A == 0:
          A.inc
          B.dec
          ans.add("A")
        elif B == 0:
          B.inc
          A.dec
          ans.add("B")
        elif t == 2 and i < N - 1 and s[i] != s[i + 1]:
          c := (s[i].toSet().intersection s[i + 1].toSet()).toSeq[0]
          if c == 'A':
            A.inc
            B.dec
            ans.add("A")
          else:
            A.dec
            B.inc
            ans.add("B")
        else:
          if A < B:
            A.inc
            B.dec
            ans.add("A")
          else:
            B.inc
            A.dec
            ans.add "B"
      elif s[i] == "BC":
        if B == 0:
          B.inc
          C.dec
          ans.add("B")
        elif C == 0:
          C.inc
          B.dec
          ans.add("C")
        elif t == 2 and i < N - 1 and s[i] != s[i + 1]:
          c := (s[i].toSet().intersection s[i + 1].toSet()).toSeq[0]
          if c == 'B':
            B.inc
            C.dec
            ans.add("B")
          else:
            B.dec
            C.inc
            ans.add("C")
        else:
          if B < C:
            B.inc
            C.dec
            ans.add("B")
          else:
            B.dec
            C.inc
            ans.add "C"
      elif s[i] == "AC":
        if A == 0:
          A.inc
          C.dec
          ans.add("A")
        elif C == 0:
          C.inc
          A.dec
          ans.add("C")
        elif t == 2 and i < N - 1 and s[i] != s[i + 1]:
          c := (s[i].toSet().intersection s[i + 1].toSet()).toSeq[0]
          if c == 'A':
            A.inc
            C.dec
            ans.add("A")
          else:
            A.dec
            C.inc
            ans.add("C")
        else:
          if A < C:
            A.inc
            C.dec
            ans.add("A")
          else:
            A.dec
            C.inc
            ans.add "C"
      assert A >= 0 and B >= 0 and C >= 0
  print YES
  for a in ans:
    echo a

main()
