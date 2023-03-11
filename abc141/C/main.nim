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

let YES = "Yes"
let NO = "No"

proc solve(N:int, K:int, Q:int, A:seq[int]) =
  var v = newSeq[int](N)
  for i in 0..<Q:
    v[A[i]] += 1
  for i in 0..<N:
    let p = K - (Q - v[i])
    echo if p <= 0: "No" else: "Yes"
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  var Q = 0
  Q = nextInt()
  var A = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt() - 1
  solve(N, K, Q, A);
  return

main()
#}}}
