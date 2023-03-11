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

proc calc(a:int):int =
  return a div int(2)

proc solve(S:string, K:int) =
  var
    i = 0
    v = newSeq[int]()
  while i < S.len:
    var j = i
    while j < S.len and S[i] == S[j]: j += 1
    v.add(j - i)
    i = j
  if v.len == 1:
    echo calc(v[0] * K)
    return
  var sum = 0
  for i in 1..<v.len - 1:
    sum += calc(v[i])
  sum *= K
  if S[0] == S[^1]:
    sum += calc(v[0]) + calc(v[^1]) + calc(v[0] + v[^1]) * (K - 1)
  else:
    sum += (calc(v[0]) + calc(v[^1])) * K
  echo sum
  return

#{{{ main function
proc main() =
  var S = ""
  S = nextString()
  var K = 0
  K = nextInt()
  solve(S, K);
  return

main()
#}}}
