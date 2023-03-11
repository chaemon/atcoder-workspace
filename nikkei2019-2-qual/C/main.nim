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

let YES = "Yes"
let NO = "No"

proc solve(N:int, A:seq[int], B:seq[int]) =
  var v = newSeq[(int,int)]()
  var w = newSeq[(int,int)]()
  for i in 0..<N: v.add((B[i], i))
  for i in 0..<N: w.add((A[i], i))
  v.sort()
  w.sort()
  for i in 0..<N:
    if w[i][0] > v[i][0]:
      echo NO
      return
    if i < N - 1 and w[i+1][0] <= v[i][0]:
      echo YES
      return
  echo YES
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    B[i] = nextInt()
  solve(N, A, B);
  return

main()
#}}}
