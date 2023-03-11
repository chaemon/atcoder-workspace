#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
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


proc solve(N:int, H:seq[int]) =
  var
    ans = 0
    i = 0
  while i < H.len:
    var j = i
    while true:
      if j + 1 < H.len and H[j] >= H[j+1]:
        j += 1
      else:
        break
    ans = max(j - i, ans)
    i = j + 1
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var H = newSeqWith(N, 0)
  for i in 0..<N:
    H[i] = nextInt()
  solve(N, H);
  return

main()
#}}}
