#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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
#}}}

#{{{ bitutils
proc bits(v:varargs[int]): int =
  result = 0
  for x in v: result = (result or (1 shl x))
proc `[]`(b:int,n:int):int =
  if (b and (1 shl n)) == 0: 0 else: 1
proc test(b:int,n:int):bool =
  if b[n] == 1:true else: false
proc set(b:var int,n:int) = b = (b or (1 shl n))
proc unset(b:var int,n:int) = b = (b and (not (1 shl n)))
proc write_bits(b:int,n:int = 64) =
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
#}}}

#{{{ main function
proc main() =
  let N, M = nextInt()
  var a,b,c = newSeq[int](M)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
    var k = 0
    for j in 0..<b[i]:
      let t = nextInt(1)
      k.set(t)
    c[i] = k
  var dp_from = newSeqWith((1 shl N),int.infty)
  dp_from[0] = 0
  let B = (1 shl N)
  for i in 0..<M:
    var dp_to = dp_from
    for p in 0..<B:
      if dp_from[p] == int.infty: continue
      let q = (p or c[i])
      dp_to[q].min=(dp_from[p] + a[i])
    swap(dp_from,dp_to)
  let t = dp_from[(1 shl N) - 1]
  if t == int.infty:
    echo -1
  else:
    echo t
  return

main()
#}}}
