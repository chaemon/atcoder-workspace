import sequtils, math
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false

proc sq(x:int):int = x * x

proc solve(N:int, x:seq[int], y:seq[int]):void =
  var
    s = 0.0
  for i in 0..<N:
    for j in 0..<N:
      s += sqrt(float(sq(x[i] - x[j]) + sq(y[i] - y[j])))
  echo s / float(N)
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y);
  return

main()
