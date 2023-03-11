#{{{ header
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
#}}}

proc calc(s:seq[string]):int =
  var
    H = s.len
    W = s[0].len
    sum = newSeqWith(H+W-1,newSeq[int]())
  for S in 0..<sum.len:
    var sum_val = 0
    for x in 0..H-1:
      var y = S - x
      if x < H and 0<=y and y < W and s[x][y] == '#': sum_val += 1
      sum[S].add(sum_val)
  result = 0
  for S in 0..H+W-2:
    for x in 0..H-1:
      var y = S - x
      if y < 0 or W <= y: continue
      if s[x][y] == '.': continue
      for x2 in x+1..H-1:
        var y2 = S - x2
        if y2 < 0 or W <= y: continue
        if s[x2][y2] == '.': continue
        debug(x,y,x2,y2)
        var d = abs(x - x2) + abs(y - y2)
        # S - d
        block:
          let S2 = S - d
          if S2 >= 0: result += sum[S2][x-1] - sum[S2][S2-y2]
        # S + d
        block:
          let S2 = S + d
          debug(S2,sum[S2])
          if S2 < sum.len: result += sum[S2][S2-y-1] - sum[S2][x2]

proc main():void =
  var
    H = nextInt()
    W = nextInt()
    S = newSeqWith(H,nextString())
    T = newSeqWith(H,newString(W))
    ans = 0
  ans += calc(S)
  for i in 0..<H:
    for j in 0..<W:
      T[i][j] = S[i][W-1-j]
  ans += calc(T)
  echo ans

main()

