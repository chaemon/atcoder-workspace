#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

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

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}


#{{{ main function
proc main() =
  let H, W, K = nextInt()
  var s = newSeq[string](H)
  for i in 0..<H:s[i] = nextString()
  var
    ans = newSeqWith(H, newSeq[int](W))
    right_most = newSeqWith(H, -1)
  for i in 0..<H:
    for j in 0..<W:
      if s[i][j] == '#': right_most[i].max=j
  var u = 0
  for i in 0..<H:
    if right_most[i] == -1:
      continue
    else:
      u += 1
      for j in 0..<W:
        ans[i][j] = u
        if s[i][j] == '#' and right_most[i] != j: u += 1
  var c = -1
  for i in 0..<H:
    if right_most[i] != -1:
      if c == -1:
        for i2 in 0..<i:
          for j in 0..<W:
            ans[i2][j] = ans[i][j]
      c = i
    else:
      if c != -1:
        for j in 0..<W: ans[i][j] = ans[c][j]
  for i in 0..<H:
    for j in 0..<W:
      stdout.write(ans[i][j])
      if j < W - 1:
        stdout.write(" ")
    echo ""
  return

main()
#}}}
