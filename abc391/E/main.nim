when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

# Failed to predict input format
solveProc solve():
  var
    N = nextInt()
    A = nextString()
  var
    h = 0
    cost = Seq[A.len: array[2, int]]
  for i in A.len:
    if A[i] == '0':
      cost[i] = [0, 1]
    elif A[i] == '1':
      cost[i] = [1, 0]
    else:
      doAssert false
  proc calc(a:char, cost: seq[array[2, int]]): array[2, int] =
    for d in 2:
      let c = '0' + d
      if c == a: result[d] = 0
      else:
        var ans = int.inf
        for b in 2^3:
          var v: seq[int]
          for i in 3:
            v.add b[i]
          if v.count(d) < 2: continue
          var s = 0
          for i in 3:
            s += cost[i][v[i]]
          ans.min=s
        result[d] = ans
  while A.len > 1:
    let A_next_len = A.len div 3
    var
      cost_next = Seq[A_next_len: array[2, int]]
      A_next = '?'.repeat(A_next_len)
    for i in A_next_len:
      let s = A[i * 3 ..< i * 3 + 3]
      if s.count('0') >= 2:
        A_next[i] = '0'
      else:
        A_next[i] = '1'
      cost_next[i] = calc(A_next[i], cost[i * 3 ..< i * 3 + 3])
    A = A_next.move
    cost = cost_next.move
  echo max(cost[0][0], cost[0][1])

when not DO_TEST:
  solve()
else:
  discard

