#include lib/header/chaemon_header
import std/sequtils, std/strutils, std/math, std/algorithm, std/sets, std/tables, std/options, std/deques, std/sugar, std/strformat, std/heapqueue

#######################################################################################
# 定数
const INF = 10 ^ 18
const M197 = 10 ^ 9 + 7


#######################################################################################
# 入力
proc getI():int = stdin.readLine.parseInt

proc getILn():seq[int] = stdin.readLine.split.map parseInt
proc getI2():(int, int) =
  let a = getILn()
  return (a[0], a[1])
proc getI3():(int, int, int) =
  let a = getILn()
  return (a[0], a[1], a[2])
proc getI4():(int, int, int, int) =
  let a = getILn()
  return (a[0], a[1], a[2], a[3])
proc getICl(n:int):seq[int] = newSeqWith(n, getI())
proc getICl2(n:int):(seq[int], seq[int]) =
  result[0] = newSeq[int](n)
  result[1] = newSeq[int](n)
  for i in 0..<n:
    let a = getI2()
    result[0][i] = a[0]
    result[1][i] = a[1]

proc getIMt(n:int):seq[seq[int]] = newSeqWith(n, getILn())

proc getILnZ():seq[int] = stdin.readLine.split.mapIt(it.parseInt-1)
proc getI2Z():(int, int) =
  let a = getILnZ()
  return (a[0], a[1])
proc getI3Z():(int, int, int) =
  let a = getILnZ()
  return (a[0], a[1], a[2])
proc getI4Z():(int, int, int, int) =
  let a = getILnZ()
  return (a[0], a[1], a[2], a[3])
proc getIClZ(n:int):seq[int] = newSeqWith(n, getI()-1)
proc getICl2Z(n:int):(seq[int], seq[int]) =
  result[0] = newSeq[int](n)
  result[1] = newSeq[int](n)
  for i in 0..<n:
    let a = getI2Z()
    result[0][i] = a[0]
    result[1][i] = a[1]
proc getIMtZ(n:int):seq[seq[int]] = newSeqWith(n, getILnZ())

proc getS():string = stdin.readLine
proc getSLn():seq[string] = stdin.readLine.split
proc getSCl(n:int):seq[string] = newSeqWith(n, getS())

proc getF():float = stdin.readLine.parseFloat
proc getFLn():seq[float] = stdin.readLine.split.map parseFloat

proc newSeq2d[T](h:int, w:int, init:T): seq[seq[T]]= newSeqWith(h, newSeqWith(w, init))


#######################################################################################
# 出力
proc printLn[T](s:seq[T]) =
  echo s.mapIt($it).join(" ")

proc printCl[T](s:seq[T]) =
  echo s.mapIt($it).join("\n")

proc print[T](s:seq[seq[T]]) =
  echo s.mapIt($it.join(" ")).join("\n")

proc print(b:bool) =
  if b:
    echo "Yes"
  else:
    echo "No"


#######################################################################################
# デバッグ用エラー出力
proc dbp(s:string) =
  stderr.writeLine(s)

proc dbp(s:seq[seq[int]])=
  proc toStr(x:int):string=
    if x == INF:
      "INF"
    elif x == -INF:
      "-INF"
    else:
      $x
  let ss = s.mapIt(it.mapIt(it.toStr))
  let l = ss.mapIt(it.mapIt(it.len).max).max
  ss.mapIt(it.mapIt(fmt"[{it.alignString(l, '>')}]").join("")).join("\n").dbp


proc dbp[T](s:seq[seq[T]]) = 
  let l = s.mapIt(it.mapIt(($it).len).max).max
  s.mapIt(it.mapIt(fmt"[{($it).alignString(l, '>')}]").join("")).join("\n").dbp

proc dbp[T](x: T) =
  stderr.writeLine($x)

#######################################################################################
# 汎用関数
proc chmin(a:var int, b:int)=
  if b < a:
    a = b

proc chmax(a:var int, b:int)=
  if b > a:
    a = b

proc sum(s:seq[int]): int =
  s.foldl(a+b)

proc toTup2[T](s:seq[T]):(T, T) =
  (s[0], s[1])

proc toTup3[T](s:seq[T]):(T, T, T) =
  (s[0], s[1], s[2])

#######################################################################################

const DEBUG = true

import atcoder/extra/structure/set_map

proc solve() =
  let Q = getI()
  let qs = getIMt(Q)

  let N = 2 ^ 20
  var seg = newSeqWith(N*2-1, -1)

  # chaemon debug
  var not_engaged = initSortedSet[int]()
  var A = newSeqWith(N, -1)
  for i in 0..<N:
    not_engaged.insert(i)

  proc getMT(x:int,k = 0, l= 0, r = N):int =
    echo "getMT: ", x, " ", k, " ", l, " ", r
    if k >= N-1:
      if seg[k] >= 0:
        return -1
      else:
        return k-N+1
    else:
      let m = (l + r) div 2

      if x notin l ..< m:
        return getMT(m, 2 * k + 2, m, r)
      #
      #if x < m and seg[2*k+1] < 0:
      #  return getMT(x, 2*k+1, l, m)
      #else:
      #  return getMT(x, 2*k+2, m, r)

  proc update(k:int)=
    if k == 0:
      return
    if k < N-1:
      let l = 2*k+1
      let r = 2*k+2
      seg[k] = min(seg[l], seg[r])
    let p = (k-1) div 2
    update(p)

  var ans = newSeq[int]()
  for ct, q in qs:
    let x = q[1]
    let h = x mod N
    if q[0] == 1:
      var i = getMT(h)
      if i < 0:
        i = getMT(0)
      block:
        echo "h = ", h, " i = ", i, " ", getMT(256587)

      block:
        var it = not_engaged.lower_bound(x mod N)
        if it == not_engaged.end():
          echo "found end!!"
          it = not_engaged.begin()
        let j = *it
        not_engaged.erase(it)
        if i != j:
          echo "found!! ct = ", ct, " q = ", q, " h = ", h
          echo i, " ", j
          doAssert false

      doAssert seg[i + N - 1] == -1
      seg[i+N-1] = x
      update(i+N-1)
    else:
      ans.add(seg[h+N-1])

  ans.printCl




solve()
