import sequtils, strutils
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

let d = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

proc solve(N:int):void =
  if N == 0:
    echo 0;return
  var N = N
  var ans = ""
  while N > 0:
    ans = "" & d[N mod 36] & ans
    N = N div 36
  echo ans
  discard

proc main():void =
  var N = nextInt()
  solve(N);
  return

main()
