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

proc solve(N:int, K:int, H:seq[int]):void =
  var hs = newSeq[int]()
  hs.add(0)
  for i in 0..<N:hs.add(H[i])
  hs.sort(cmp[int])
  hs = hs.deduplicate()
  var dp = newSeqWith(K+1, newSeqWith(hs.len, int.infty))
  var hid = newSeqWith(N,-1)
  for i in 0..<N:
    for j in 0..<hs.len:
      if H[i] == hs[j]:
        hid[i] = j
        break
    assert(hid[i] != -1)
  dp[0][0] = 0
  for i in 0..<N:
    var dp_to = newSeqWith(K+1, newSeqWith(hs.len, int.infty))
    for k in 0..K:
      for h in 0..<hs.len:
        let d = dp[k][h]
        if d == int.infty: continue
        if k < K: dp_to[k+1][h].min=(d)
        let hi = hid[i]
        var d2 = d
        if h < hi: d2 += abs(hs[hi] - hs[h])
        dp_to[k][hi].min=(d2)
    swap(dp, dp_to)
  var ans = int.infty
  for k in 0..K:
    for h in 0..<hs.len:
      ans.min=(dp[k][h])
  echo ans
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  var H = newSeqWith(N, 0)
  for i in 0..<N:
    H[i] = nextInt()
  solve(N, K, H);
  return

main()
