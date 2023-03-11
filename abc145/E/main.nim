#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

proc solve(N:int, T:int, A:var seq[int], B:var seq[int]):void =
  var v = newSeq[(int,int)]()
  for i in 0..<N: v.add((A[i], B[i]))
  v.sort(cmp[(int,int)])
  for i in 0..<N:A[i] = v[i][0];B[i] = v[i][1]
  var 
    dp_from = newSeqWith(T,0)
    ans = 0
  dp_from[0] = 0
  for i in 0..<N:
    var dp_to = dp_from
    for t in 0..<T:
      let
        t2 = t + A[i]
        b2 = dp_from[t] + B[i]
      if t2 < T: dp_to[t2].max=(b2)
      ans.max=(b2)
    swap(dp_from, dp_to)
  echo ans
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var T = 0
  T = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, T, A, B)
  return

main()
