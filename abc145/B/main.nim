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

let YES = "Yes"
let NO = "No"

proc solve(N:int, S:string):void =
  if N mod 2 != 0:
    echo NO
    return
  let d = N div 2
  for i in 0..<d:
    if S[i] != S[i+d]:
      echo NO
      return
  echo YES
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var S = ""
  S = nextString()
  solve(N, S);
  return

main()
