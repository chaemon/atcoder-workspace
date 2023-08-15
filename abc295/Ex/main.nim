when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const DO_TEST = false

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/other/bitutils

solveProc solve(N:int, M:int, X:seq[string]):
  #var dp = Seq[2^M: mint(0)]
  var dp = 2^M @ mint(0)
  dp[2^M - 1] = 1
  # 1が立ってるものは縦方向に続いているとする
  for i in N:
    # dp -> dp2
    # 1を0にする
    var
      v = dp
      dp2 = 2^M @ mint(0)
    block:
      ok := true
      for k in 0 ..< M:
        if X[i][k] == '0': ok = false;break
      if ok:
        for b in 2^M:
          # 1のところは1でないといけない
          dp2[b] += v[b]
    for j in 0 ..< M << 1:
      # j + 1 .. ^1まではsubsetになってる
      # これをj .. ^1にする
      for b in 2^M:
        if b[j] == 1: continue
        # supersetならこれでいいはず
        v[b] += v[b or [j]]
      # この時点でのdp2を使う
      # 0 ..< jに1を立てる, jを0, 残りはsuperset
      # 0 ..< jに0があるとだめ
      block:
        ok := true
        for k in 0 ..< j:
          if X[i][k] == '0': ok = false;break
        if X[i][j] == '1': ok = false
        mask_one := 0 # Xが1のところにmask
        mask_zero := 0
        for k in j + 1 ..< M:
          if X[i][k] == '0':
            mask_zero[k] = 1
          elif X[i][k] == '1':
            mask_one[k] = 1
        if ok:
          for b in 2^M:
            if b[j] == 1: continue
            # maskが1のところはbも1でないといけない
            if (b and mask_one) != mask_one: continue
            if ((not b) and mask_zero) != mask_zero: continue
            dp2[b] += v[b] # vの方はsuperset
    dp = dp2.move
  echo dp.sum
  Naive:
    proc is_valid(S:seq[string]):bool =
      for i in N:
        for j in M:
          if S[i][j] == '1':
            ok0 := true
            for i2 in 0 ..< i:
              if S[i2][j] == '0': ok0 = false
            ok1 := true
            for j2 in 0 ..< j:
              if S[i][j2] == '0': ok1 = false
            if not ok0 and not ok1:
              return false
      return true
    var q = @(int, int)
    for i in N:
      for j in M:
        if X[i][j] == '?': q.add (i, j)
    ans := 0
    for b in 2^q.len:
      var S = X
      for i in q.len:
        let (x, y) = q[i]
        if b[i] == 1:
          S[x][y] = '1'
        else:
          S[x][y] = '0'
      if is_valid(S): ans.inc
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(N, nextString())
  solve(N, M, X)
else:
  import random
  randomize()
  #test(1, 2, @["00"])
  #test(1, 2, @["0?"])
  for _ in 1000:
    let N = 5
    let M = 5
    var X = N @ '0'.repeat(M)
    for i in N:
      for j in M:
        let t = random.rand(0 .. 2)
        if t == 0:
          X[i][j] = '0'
        elif t == 1:
          X[i][j] = '1'
        else:
          X[i][j] = '?'
    test(N, M, X)
  discard

