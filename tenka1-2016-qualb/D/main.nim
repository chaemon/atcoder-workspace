#{{{ header
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


proc solve(N:int, a:seq[int], A:int, L:seq[int], R:seq[int], X:seq[int], B:int, S:seq[int], T:seq[int], K:seq[int]) =
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  var A = 0
  A = nextInt()
  var L = newSeqWith(A, 0)
  var R = newSeqWith(A, 0)
  var X = newSeqWith(A, 0)
  for i in 0..<A:
    L[i] = nextInt()
    R[i] = nextInt()
    X[i] = nextInt()
  var B = 0
  B = nextInt()
  var S = newSeqWith(B, 0)
  var T = newSeqWith(B, 0)
  var K = newSeqWith(B, 0)
  for i in 0..<B:
    S[i] = nextInt()
    T[i] = nextInt()
    K[i] = nextInt()
  solve(N, a, A, L, R, X, B, S, T, K);
  return

main()
#}}}
