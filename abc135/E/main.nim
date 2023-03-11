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

proc main():void =
  var
    K, X, Y = nextInt()
  let
    sx = if X >= 0: 1 else: -1
    sy = if Y >= 0: 1 else: -1
  X = abs(X)
  Y = abs(Y)
  var reverse = false
  if X > Y: swap(X, Y);reverse = true
  var ans = newSeq[(int,int)]()
  if X + Y == 0:
    discard
  elif X + Y < K:
    ans.add(())
  if (X + Y) mod K == 0:
    discard
  if reverse:
    for i in 0..<ans.len:
      swap(ans[i][0], ans[i][1])
  discard

main()

