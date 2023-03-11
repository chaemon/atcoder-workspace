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

let YES = "Possible"
let NO = "Impossible"

proc solve(N:int, a:seq[int]) =
  let m = max(a)
  var ct = newSeq[int](m+1)
  for d in a: ct[d] += 1
  let t = (m + 1) div 2
  for i in 0..<t:
    if ct[i] > 0:
      echo NO
      return
  if m mod 2 == 0:
    if ct[t] != 1:
      echo NO
      return
  else:
    if ct[t] != 2:
      echo NO
      return
  for i in t+1..<m:
    if ct[i] < 2:
      echo NO
      return
  echo YES
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  solve(N, a);
  return

main()
#}}}
