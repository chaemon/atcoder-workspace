when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
when DO_TEST:
  import random
  randomize()

# Failed to predict input format
solveProc solve():
  when DO_TEST:
    let N = 30
    var ct = 0
    #var
    #  ans_P = @[2, 3, 0, 1, 4]
    #  ans_A = @[5, 20, 6, 7, 1]
    var
      ans_P = (0 ..< N).toSeq
      ans_A:seq[int]
    for i in N:
      ans_A.add random.rand(1 .. 20)
    while true:
      ans_P.shuffle
      if ans_P[0] < ans_P[1]: break
    debug "answer: ", ans_P, ans_A

  proc ask(s, t:int):int =
    echo "? ", s + 1, " ", t + 1
    flushFile(stdout)
    when DO_TEST:
      doAssert s != t
      ct.inc
      doAssert ct <= N * 2
      var
        si = ans_P[s]
        ti = ans_P[t]
      if si > ti: swap si, ti
      result = ans_A[si .. ti].sum
      echo "     ", result
      return
    else:
      let X = nextInt()
      if X == -1: quit(0)
      return X
  when DO_TEST:
    discard
  else:
    let N = nextInt()
  var
    P, A = Seq[N: -1]
    s = Seq[N: Array[2: -1]]
    left, right = Seq[tuple[s, i:int]]
    d = ask(0, 1)
  s[0][1] = d
  s[1][0] = d
  s[0][0] = 0 #ここ違う。。。
  s[1][1] = 0 #
  left.add (s[0][1], 0)
  right.add (s[1][0], 1)
  for i in 2 ..< N:
    for j in 0 .. 1:
      s[i][j] = ask(i, j)
    if s[i][0] < s[i][1]:
      left.add (s[i][1], i)
    else:
      right.add (s[i][0], i)
  left.sort
  right.sort
  # 2(N - 2) + 1回
  var
    Al, li = Seq[left.len: -1]
  for i in left.len:
    li[i] = left[i].i
  for i in left.len - 1:
    let d = left[i + 1].s - left[i].s
    Al[i + 1] = d
  #  left[0].i, right[0].i,     1
  # leftの最後はrightの先頭とindex 1の距離と比較
  var Ar, ri = Seq[right.len: -1]
  for i in right.len:
    ri[i] = right[i].i
  for i in right.len - 1:
    let d = right[i + 1].s - right[i].s
    Ar[i + 1] = d
  Al.reverse
  li.reverse
  A = Al & Ar
  var invP = li & ri
  for i in N:
    P[invP[i]] = i
  # -1を探して接するものを
  while true:
    if A.find(-1) == -1: break
    for i in N - 1:
      if A[i] == -1 and A[i + 1] != -1:
        A[i] = ask(invP[i], invP[i + 1]) - A[i + 1]
      if A[i] != -1 and A[i + 1] == -1:
        A[i + 1] = ask(invP[i], invP[i + 1]) - A[i]
  when DO_TEST:
    doAssert ans_A == A
    doAssert ans_P == P
  for i in P.len: P[i].inc
  echo "! ", P.join(" "), " ", A.join(" ")
  flushFile(stdout)

when not DO_TEST:
  solve()
else:
  for _ in 10000:
    solve()

