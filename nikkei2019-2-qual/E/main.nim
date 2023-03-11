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


proc solve(N:int, K:int) =
  let t = (N+1) div int(2)
  if K > t:
    echo -1
    return
  var ans = newSeq[(int,int,int)]()
  for i in 0..<t:
    let
      p = t + i
      q = t + N + N - t + i
      # p + q = 2N + t + 2i
    ans.add((p,q,p+q))
  for i in 0..<N - t:
    let
      p = t + t + i
      q = t + N + i
      # p + q = 3t + N + 2i
    ans.add((p,q,p+q))
  let d = t - K
  for i in 0..<ans.len:
    ans[i][0] -= d
    ans[i][1] -= d
    ans[i][2] -= d
  if N mod 2 == 0:
    for i in 0..<(N div int(2)):
      ans[i][2] += 1
  for i in 0..<N:
    echo ans[i][0], " ", ans[i][1], " ", ans[i][2]
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  solve(N, K);
  return

main()
#}}}
