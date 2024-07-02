when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(S:string):
  var left, right = Seq[S.len: 0] # iの左(右)にいくつ数字があるか
  block:
    var ct:int
    ct = 0
    for i in S.len:
      if S[i] in '0' .. '9':
        ct.inc
      left[i] = ct
    ct = 0
    for i in 0 ..< S.len << 1:
      if S[i] in '0' .. '9':
        ct.inc
      right[i] = ct
  var s0, s, ans = mint(0) # n: 今の個数, s0: 直前までの和, s: s0から現在の積をかけて足した値
  for i in S.len:
    if S[i] == '+':
      ans += s * right[i] # +の位置より右で終える
      s = 0
      s0 = left[i]
    elif S[i] == '*':
      # 今までのsがs0になる
      s0 = s
      s = 0
    else:
      let d = S[i] - '0'

      # S[i]から開始する
      s0 += 1

      s *= 10
      s += s0 * d

      # S[i]で終了する
      ans += s
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

