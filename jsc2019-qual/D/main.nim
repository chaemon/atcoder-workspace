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


proc solve(N:int) =
  var ans = newSeqWith(N,newSeqWith(N,-1))
  proc set_edge(x:seq[int],level:int):void =
    let
      d = x.len div 2
      a = x[0..<d]
      b = x[d..<x.len]
    for v in a:
      for w in b:
        ans[v][w] = level
        ans[w][v] = level
    if a.len >= 2:
      set_edge(a,level+1)
    if b.len >= 2:
      set_edge(b,level+1)
  var v = newSeq[int]()
  for i in 0..<N: v.add(i)
  set_edge(v,0)
  for i in 0..<N:
    for j in i+1..<N:
      stdout.write(ans[i][j] + 1, " ")
    echo ""
  return

proc main() =
  var N = 0
  N = nextInt()
  solve(N);
  return

main()
