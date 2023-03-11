when defined SecondCompile:
  const
    DO_CHECK = false
    DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:seq[string]):
  var ct = Seq[N: array[0..9, int]]
  for i in N:
    ct[i].fill(0)
    for s in S[i]:
      if s == 'X':ct[i][0].inc
      else: ct[i][s - '0'].inc
  proc myCmp(i, j:int):int =
    var r0 = 0
    for t in 1 .. 9:
      r0 += t * ct[j][t]
    r0 *= ct[i][0]
    var r1 = 0
    for t in 1 .. 9:
      r1 += t * ct[i][t]
    r1 *= ct[j][0]
    return - cmp(r0, r1)
  var a = (0 ..< N).toSeq
  a.sort(myCmp)
  ans := 0
  num_X := 0
  for a in a:
    for c in S[a]:
      if c == 'X': num_X.inc
      else: ans += num_X * (c - '0')
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

