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

let YES = "Yes"
let NO = "No"

proc solve(N:int, S:seq[string]) =
  for s in S:
    var k = s.find("okyo")
    if k == -1:
      echo "No"
      continue
    k = s.find("ech",k+4)
    if k == -1:
      echo "No"
      continue
    echo "Yes"
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = newSeqWith(N, "")
  for i in 0..<N:
    S[i] = nextString()
  solve(N, S);
  return

main()
#}}}
