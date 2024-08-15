when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int):
  # 2^(K - 1), 2^(K - 1) + 2, ..., 2^K - 1で全部作れる
  # 部分的に作る場合はこの部分集合で散らす
  var ans:seq[int]
  if N >= 2^(K - 1):
    let B = 2^(K - 1)
    for i in 2^(K - 1) ..< 2^K:
      ans.add i
    while ans.len < N: ans.add 1
  else:
    # 最初の桁は1、それ以外をどうするか
    # 1 (b桁) (0 or 1) (全部0)の形にする
    # つまり2^b <= N < 2^(b + 1)みたいな形にする
    var b = 0
    while true:
      if N < 2^(b + 1):
        break
      b.inc
    doAssert b <= K - 2 and 2^b <= N and N < 2^(b + 1)
    #debug b, K
    let r = N - 2^b
    # 構築
    for i in 0 ..< 2^b:
      var t = i
      ans.add t * 2
      if i < r: ans.add t * 2 + 1
    let P = 2^(K - (1 + b + 1))
    for a in ans.mitems:
      a *= P
      a += 2^(K - 1)
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var K = nextInt()
    solve(N, K)
else:
  discard

