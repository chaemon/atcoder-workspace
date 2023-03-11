const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve(N:int, A:seq[int]):
  proc check(ans:seq[int]) =
    var A = A
    debug A
    for a in ans:
      if a == -1:
        for it in A.mitems:
          it.inc
          if it == 2^N: it = 0
      else:
        for it in A.mitems: it = it xor a
      debug A
    for i in 2^N:
      doAssert A[i] == i
  var
    ans = Seq[int]
    a = @[A]
  for d in N:
    debug d, a
    # aのどの要素も隣との偶奇が異ならなくてはならない
    for a in a:
      for i in a.len:
        let j = (i + 1) mod a.len
        if a[i] mod 2 == a[j] mod 2:
          echo NO;return
    # aの各元は偶数のインデックスが0、奇数のインデックスは1になるようにする
    x := 0 # xorの回数 下一桁はxが偶数なら0, 1, 奇数なら1, 0となるようにする
    i := a.len - 1 # 1足される場所
    while true:
      # a[i][...]に1を加える。ただし、すでにx回のxorが行われているのでそれを反映してから
      # 初期配置から0 1にして足し算して1 0になる
      # また初期配置に戻す
      init_0_1 := a[i][0] mod 2 == 1 # 初期配置が1 0か?
      if x mod 2 == 0: # 目標は0 1
        if a[i][0] mod 2 == 0: # 初期配置で0 1→今現在1 0にする
          ans.add 2^d
          x.inc
      else: # 目標は1 0
        if a[i][0] mod 2 == 1: # 初期配置で1 0→今現在1 0にする
          ans.add 2^d
          x.inc
      ans.add -1
      for it in a[i].mitems:
        it.inc
        if it == 2^(N - d): it = 0
      # 1 0になっている
      if i == 0:
        break
      i.dec
    if a[0][0] mod 2 == 1:
      ans.add 2^d
      for a in a.mitems:
        for a in a.mitems:
          a = a xor 1
    debug a
    # 目的が達成されたはず
    var ps, qs = Seq[seq[int]]
    for a in a:
      var p, q:seq[int]
      for i in a.len:
        if i mod 2 == 0: p.add a[i] div 2
        else: q.add a[i] div 2
      ps.add p
      qs.add q
    a = ps & qs
    debug a, ans
    if d == N - 2: break
  check(ans)
  echo YES
  discard

when not DO_TEST:
  let
    N = nextInt()
    A = Seq[2^N: nextInt()]
  solve(N, A)
else:
  discard

