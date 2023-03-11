import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

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
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)


proc solve(s:string, t:string) =
  var
    s2 = s
    next = newSeqWith(s.len,newSeqWith(26,-1))
    v = newSeqWith(26,-1)
  s2 &= s
  for i in countdown(s2.len - 1,0):
    v[ord(s2[i]) - ord('a')] = i
    if i < s.len:
      for j in 0..<26:
        next[i][j] = if v[j] == -1: -1 else:v[j] - i
  var i = 0
  for c in t:
    let d = next[i mod s.len][ord(c) - ord('a')]
    if d == -1:
      echo -1;return
    i += d + 1
  echo i
  return

proc main() =
  var s = ""
  s = nextString()
  var t = ""
  t = nextString()
  solve(s, t);
  return

main()
