when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

const B = 32000

proc calc(n:int):int =
  # 1 .. nにおける2^k * 3^lの範囲
  var a:seq[int]
  p := 1
  while p <= n:
    let u = fastLog2(n div p)
    if u > 0:
      a.add u
    p *= 3
  debug a
  let
    N = a.len
    M = a[0]
  var b = Seq[N, M: false]
  for i in N:
    for j in a[i]:
      b[i][j] = true
  var c:seq[seq[bool]]
  for s in M:
    var ci:seq[bool]
    for i in 0 .. min(s, N - 1):
      let j = s - i
      if b[i][j]: ci.add true
      else: ci.add false
    c.add ci
  var dp = @[0, int.inf]
  for i in c.len:
    var mask = 0
    for j in c[i].len:
      if not c[i][j]: mask[j] = 1
    # c[i]の配分を考えてc[i + 1]にする
    var L = if i == c.len - 1: c[i].len + 1 else: c[i + 1].len
    var dp2 = Seq[2^L: int.inf]
    for b in 2^len(c[i]):
      var
        d = dp[b]
        b0 = b or mask
        b1 = 0
      for j in c[i].len:
        if b0[j] == 0:
          b1[j] = 1
          b1[j + 1] = 1
          d.inc
      if b1[L] == 1: b1[L] = 0
      dp2[b1].min=d
    dp = dp2.move
  return dp.min

when true:
  block:
    let N = 10^9
    for i in 1 .. N:
      echo calc(N div i)
    quit(0)



solveProc solve(N:int):
  for d in 1 .. B:
    if d mod 2 == 0 or d mod 3 == 0: continue
    var a = calc(N div d)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

