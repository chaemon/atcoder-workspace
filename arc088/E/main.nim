#{{{ header
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


proc solve(S:string) =
  var
    ans = 0
    odd_ct = 0
  for c in 0..<26:
    var
      a = newSeq[int]()
      ct = 0
    for s in S:
      let os = ord(s) - ord('a')
      if os > c:continue
      elif os == c: a.add(ct)
      ct += 1
    if a.len mod 2 == 1: odd_ct += 1
    if odd_ct > 1: echo -1;return
    var (i,j) = (0,a.len - 1)
    while i < j:
      ans += abs(ct - 1 - a[j] - a[i])
      i += 1;j -= 1
    if i == j:
      ans += abs((ct div 2) - a[i])
  echo ans
  return

#{{{ main function
proc main() =
  var S = ""
  S = nextString()
  solve(S);
  return

main()
#}}}
