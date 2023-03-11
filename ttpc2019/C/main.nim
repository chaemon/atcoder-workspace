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


proc solve(N:int, X:int, a:var seq[int]) =
  var
    s = X
    ct = 0
  for p in a:
    if p != -1: s = (s xor p)
    else: ct += 1
  var appeared = false
  if ct == 0:
    if s != 0:
      echo -1
      return
  elif ct == 1:
    if s > X:
      echo -1
      return
    else:
      for p in a.mitems:
        if p == -1: p = s
  else:
    var
      v = [0,0]
      i = 0
    for k in countdown(40,0):
      if ((1 shl k) and s) != 0 :
        v[0] = (1 shl k)
        if v[0] > X:
          echo -1
          return
        else:
          v[1] = s - v[0]
          break
    for p in a.mitems:
      if p == -1:
        if i < 2: p = v[i]
        else: p = 0
        i += 1
  for p in a:
    stdout.write p, " "
  echo ""
  var ss = 0
  for p in a:
    assert p != -1
    ss = (ss xor p)
  assert ss == X
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var X = 0
  X = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  solve(N, X, a);
  return

main()
#}}}
