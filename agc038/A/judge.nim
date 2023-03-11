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

proc solve(H:int, W:int, A:int, B:int):int =
  var ans = newSeqWith(H,"")
  for i in 0..<H:
    ans[i] = nextString()
  for i in 0..<H:
    var
      zero = 0
      one = 0
    for j in 0..<W:
      if ans[i][j] == '0': zero += 1
      else: one += 1
      if min(zero,one) != A: return 1
  for j in 0..<W:
    var
      zero = 0
      one = 0
    for i in 0..<H:
      if ans[i][j] == '0': zero += 1
      else: one += 1
      if min(zero,one) != B: return 1
  echo "correct"
  return 0

#{{{ main function
proc main() =
  var H = 0
  H = nextInt()
  var W = 0
  W = nextInt()
  var A = 0
  A = nextInt()
  var B = 0
  B = nextInt()
  quit(solve(H, W, A, B))

main()
#}}}
