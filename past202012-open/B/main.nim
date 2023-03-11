import sequtils
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


proc solve(N:int, S:string):void =
  var T = ""
  for c in S:
    var T2 = ""
    for c2 in T:
      if c2 == c: continue
      T2.add c2
    T2.add c
    swap T, T2
  echo T
  discard

proc main():void =
  var N = nextInt()
  var S = nextString()
  solve(N, S);
  return

main()
