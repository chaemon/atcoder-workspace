when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
const DO_TEST = false

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum_2d
import lib/dp/cumulative_sum_2d
import lib/other/bitset
import lib/math/gaussian_elimination_bit

const YES = "Yes"
const NO = "No"

const B = 8064

solveProc solve(N:int, Q:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int], e:seq[int]):
  Pred a, c
  # グリッドであって0のところは1, 0でないところは0のものを作る
  # Step 1: 0でないところに1を足す
  var cs = initDualCumulativeSum2D[int](N, N)
  for i in Q:
    if e[i] != 0:
      cs.add(a[i] ..< b[i], c[i] ..< d[i], 1)
  cs.build()
  # Step 2: csのエントリーが正なら0, 0なら1のcs2を作る
  var
    cs2 = initCumulativeSum2D[int](N, N)
  for i in N:
    for j in N:
      if cs[i, j] == 0:
        cs2.add(i, j, 1)
  cs2.build()
  # Step 3: 0のところの和が0ならNo
  for i in Q:
    if e[i] == 0:
      if cs2[a[i] ..< b[i], c[i] ..< d[i]] == 0:
        echo NO;return
  # この時点でcs[i, j]が0のところは0に確定, その他は1, 2(-1)
  # 1は0, 2を1としたビット列で考える
  # Step 4: 連立方程式を解く
  var
    id = initTable[(int, int), int]()
    di = newSeq[(int, int)]()
    A = Seq[0:BitSet[B]]
  for i in Q:
    if e[i] == 0: continue
    for x in [a[i], b[i]]:
      for y in [c[i], d[i]]:
        if (x, y) notin id:
          id[(x, y)] = id.len
          di.add (x, y)
  for i in Q:
    if e[i] == 0: continue
    var a0 = initBitSet[B]()
    for x in [a[i], b[i]]:
      for y in [c[i], d[i]]:
        if (x, y) notin id:
          doAssert false
        let u = id[(x, y)]
        a0[u] = 1
    if e[i] == 2:
      a0[id.len] = 1
    A.add a0
  var
    s = Seq[N + 1, N + 1: 0]
  let (base, pivot, rest) = A.base(id.len)
  for i in rest.len:
    if rest[i][id.len] == 1: echo NO;return
  for i in base.len:
    doAssert base[i][pivot[i]] == 1
    # pivot[i]番目を決める
    # di[t]の値はbase[i][id.len]
    let (x, y) = di[pivot[i]]
    #debug x, y, base[i][id.len]
    s[x][y] = base[i][id.len]
  # Step 5: 累積和sからaを復元
  var ans = Seq[N, N: 0]
  for i in N:
    for j in N:
      ans[i][j] = s[i + 1][j + 1] xor s[i + 1][j] xor s[i][j + 1] xor s[i][j]

  for i in N:
    for j in N:
      if ans[i][j] == 0:
        ans[i][j] = 1
      else:
        ans[i][j] = 2
      if cs[i, j] == 0:
        ans[i][j] = 0

  echo YES
  for i in N:
    echo ans[i].join(" ")
  #Check(strm):
  #  var r = strm.nextString()
  #  if r == NO:
  #    return
  #  Pred a, c
  #  var x = Seq[N, N: strm.nextInt()]
  #  for i in Q:
  #    var p = 1
  #    for j in a[i] ..< b[i]:
  #      for k in c[i] ..< d[i]:
  #        p = (p * x[j][k]) mod 3
  #    doAssert e[i] == p
  discard

#when not defined(DO_TEST):
when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  var c = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  var e = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
    d[i] = nextInt()
    e[i] = nextInt()
  solve(N, Q, a, b, c, d, e)
else:
  import random
  #solve(N = 2, Q = 2, a = @[2, 1], b = @[2, 2], c = @[1, 1], d = @[2, 2], e = @[2, 1])
  #solve(N = 3, Q = 3, a = @[2, 2, 2], b = @[3, 3, 3], c = @[1, 2, 1], d = @[3, 2, 2], e = @[1, 1, 2])
  when true:
    for _ in 1000:
      let
        N = 1000
        Q = 1000
      var
        x = Seq[N, N: random.rand(1 .. 2)]
        a, b, c, d, e = Seq[Q: int]
      for i in Q:
        a[i] = random.rand(1 .. N)
        b[i] = random.rand(1 .. N)
        if a[i] > b[i]: swap a[i], b[i]
        c[i] = random.rand(1 .. N)
        d[i] = random.rand(1 .. N)
        if c[i] > d[i]: swap c[i], d[i]
        p := 1
        for j in a[i] - 1 ..< b[i]:
          for k in c[i] - 1 ..< d[i]:
            p = (p * x[j][k]) mod 3
        e[i] = p
      debug x
      debug N, Q, a, b, c, d, e
      test(N, Q, a, b, c, d, e)
  discard

