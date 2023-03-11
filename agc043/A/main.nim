#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
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
template inf(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

let H, W = nextInt()
let s = newSeqWith(H, nextString())

var dp = newSeqWith(H, newSeqWith(W, int.inf))

dp[0][0] = if s[0][0] == '#': 1 else: 0

for i in 0..<H:
  for j in 0..<W:
    block:
      let
        i2 = i + 1
        j2 = j
      if i2 < H and j2 < W:
        if s[i][j] == '.' and s[i2][j2] == '#':
          dp[i2][j2].min=dp[i][j] + 1
        else:
          dp[i2][j2].min=dp[i][j]
    block:
      let
        i2 = i
        j2 = j + 1
      if i2 < H and j2 < W:
        if s[i][j] == '.' and s[i2][j2] == '#':
          dp[i2][j2].min=dp[i][j] + 1
        else:
          dp[i2][j2].min=dp[i][j]

echo dp[H-1][W-1]
