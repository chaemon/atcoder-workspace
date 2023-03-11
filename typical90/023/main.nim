const
  DO_CHECK = true
  DEBUG = true
include atcoder/extra/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import lib/other/bitutils

solveProc solve(H, W:int, C:seq[string]):
  proc gen_state_len(l:int):auto =
    var
      encode = Seq[2^l: int32]
      decode = Seq[int32]
      state = 0'i32
    proc gen_state(i:int) =
      if i == l:
        block:
          ans := ""
          for i in 0 ..< l:
            if state[i] == 1: ans.add '1'
            else: ans.add '0'
        encode[state] = decode.len.int32
        decode.add state
      else:
        gen_state(i + 1)
        if i == 0 or state[i - 1] == 0:
          state[i] = 1
          gen_state(i + 1)
          state[i] = 0
    gen_state(0)
    return (encode, decode)
  var
    encode, decode = Seq[seq[int32]]
  for l in 0 .. W + 1:
    let (e, d) = gen_state_len(l)
    encode.add e
    decode.add d
  var
    dp = Seq[decode[1].len * decode[W].len: mint(0)]
  dp[0] = 1
  for i in H:
    for j in W:
      # 前の列: 長さW + 1 - j
      # 今の列: 長さj
      if j > 0:
        let
          l0 = W + 1 - j
          l1 = j
        dp2 := Seq[decode[l0 - 1].len * decode[l1 + 1].len: mint(0)]
        for b0i, b0 in decode[l0]:
          var c0 = b0
          c0[l0 - 1] = 0
          for b1i, b1 in decode[l1]:
            let d = dp[b0i * decode[l1].len + b1i]
            # (i, j)に配置しない
            block:
              var
                c1 = b1
              c1 <<= 1
              dp2[encode[l0 - 1][c0] * decode[l1 + 1].len + encode[l1 + 1][c1]] += d
            # (i, j)に配置
            block:
              if C[i][j] == '#': break
              # 真上
              if b0[l0 - 2] == 1: break
              # 真上の右
              if j + 1 < W and b0[l0 - 3] == 1: break
              # 真上の左と左
              if j > 0 and (b1[0] == 1 or b0[l0 - 1] == 1): break
              var
                c1 = (b1 << 1) | 1
              dp2[encode[l0 - 1][c0] * decode[l1 + 1].len + encode[l1 + 1][c1]] += d
        dp = dp2.move
      else:
        let
          l0 = 1
          l1 = W
        dp2 := Seq[decode[l1].len * decode[1].len: mint(0)]
        for b0i, b0 in decode[l0]:
          for b1i, b1 in decode[l1]:
            let d = dp[b0i * decode[l1].len + b1i]
            dp2[encode[l1][b1] * decode[1].len] += d
            if C[i][j] == '.' and b1[l1 - 1] == 0 and (l1 - 2 < 0 or b1[l1 - 2] == 0):
              dp2[encode[l1][b1] * decode[1].len + 1] += d
        dp = dp2.move
  ans := mint(0)
  echo dp.sum

when not defined(DO_TEST):
  let H, W = nextInt()
  let C = Seq[H: nextString()]
  
  solve(H, W, C)
else:
  for H in 1 .. 4:
    for W in 1 .. 4:
      var C = Seq[string]
      for i in H:
        C.add '.'.repeat(W)
      solve(H, W, C)


