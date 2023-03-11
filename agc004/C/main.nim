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


#{{{ main function
proc main() =
  let H,W = nextInt()
  var s = newSeqWith(H,"")
  for i in 0..<H:
    s[i] = nextString()
  var a,b = s
  for i in 0..<H:
    a[i][0] = '#'
    if i mod 2 == 0:
      for j in 0..<W-1:
        a[i][j] = '#'
  for i in 0..<H:
    b[i][W-1] = '#'
    if i mod 2 == 1:
      for j in 1..<W:
        b[i][j] = '#'
  for i in 0..<H:
    echo a[i]
  echo ""
  for i in 0..<H:
    echo b[i]
  proc check() =
    for i in 0..<H:
      for j in 0..<W:
        if a[i][j] == b[i][j]:
          assert s[i][j] == '#'
        else:
          assert s[i][j] == '.'
  check()

  return

main()
#}}}
