#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

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


proc solve(N:int, K:int, A:var seq[int], F:var seq[int]) =
  A.sort(cmp[int])
  F.sort(cmp[int])
  F.reverse()
  proc test(T:int, A: seq[int], F: seq[int]):bool =
    if T == -1:
      return false
    var S = 0
    for i in 0..<N:
      var a = (T div F[i])
      if a < A[i]:
        if S >= int.infty:
          S = int.infty
        else:
          S += A[i] - a
          if S >= int.infty:
            S = int.infty
    return S <= K
  var
    l = -1
    r = int(1000000000000000000 + 100)
  while r - l > 1:
    let m = int((l + r) div 2)
    if test(m, A, F): r = m
    else: l = m
#    echo l," ", r
  echo r
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  var F = newSeqWith(N, 0)
  for i in 0..<N:
    F[i] = nextInt()
  solve(N, K, A, F);
  return

main()
#}}}
