#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}



#{{{ main function
proc main() =
  let
    H,W = nextInt()
  var
    c = newSeqWith(H,"")
    ans = 0
  for i in 0..<H: c[i] = nextString()
  for l in 0..<W-1:
    # friction between l and l + 1
    var
      samecol = newSeqWith(H+1,newSeqWith(H+1,0))
      cost = newSeqWith(H+1,newSeqWith(H+1,0))
    for i in 0..H:
      for j in 0..H:
        if i == 0 or j == 0:samecol[i][j] = 0
        else: samecol[i][j] = samecol[i-1][j-1] + (if c[i-1][l] == c[j-1][l+1]:1 else:0)
    for i in countdown(H,0):
      for j in countdown(H,0):
        if i == H and j == H: cost[i][j] = 0
        else:
          cost[i][j] = int.infty
          if i < H: cost[i][j].min=(cost[i+1][j] + samecol[i+1][j])
          if j < H: cost[i][j].min=(cost[i][j+1] + samecol[i][j+1])
    ans += cost[0][0]
  echo ans
  return

main()
#}}}
