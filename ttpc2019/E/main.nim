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

let YES = "Yes"
let NO = "No"

proc solve(N:int) =
  if N mod 2 == 0:
    echo NO
    return
  var a = newSeqWith(N,newSeqWith(N,-1))
  for i in 0..<N:
    if i == 0:
      for j in 0..<N:
        a[i][j] = N*(j + 1)
    else:
      a[i][0] = i
      for j in 1..<N:
        a[i][j] = j + N*i
  block check:
    var v = newSeq[int]()
    for i in 0..<N:
      var s = 0
      for j in 0..<N:
        s += a[i][j]
      v.add(s mod N)
    v.sort(cmp[int])
    var w = newSeq[int]()
    for j in 0..<N:
      var s = 0
      for i in 0..<N:
        s += a[i][j]
      w.add(s mod N)
    w.sort(cmp[int])
    for i in 0..<N:
      assert v[i] == i
      assert w[i] == i
  echo YES
  for i in 0..<N:
    for j in 0..<N:
      stdout.write a[i][j]," "
    echo ""


  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  solve(N);
  return

main()
#}}}
