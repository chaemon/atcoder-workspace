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

proc sort[T](a:var seq[T]) = a.sort(cmp[T])

template `:=`(a, b: untyped): untyped =
  when declaredInScope a:
    a = b
  else:
    var a = b
  when not declared seiuchi:
    proc seiuchi(x: auto): auto {.discardable.} = x
  seiuchi(x = b)
#}}}


proc solve(N:int, M:int, L:int, A:seq[int], B:seq[int], C:seq[int], Q:int, s:seq[int], t:seq[int]) =
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var L = 0
  L = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  var Q = 0
  Q = nextInt()
  var s = newSeqWith(Q, 0)
  var t = newSeqWith(Q, 0)
  for i in 0..<Q:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, M, L, A, B, C, Q, s, t);
  return

main()
#}}}
