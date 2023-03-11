const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

# Failed to predict input format
solveProc solve(N:int, A:seq[int], S:string):
  var v = Seq[int]
  var t = Seq[int]
  for i in 0..<N << 1:
    var a = A[i]
    for j in v.len:
      if a[t[j]] == 1: a = a xor v[j]
    if S[i] == '0':
      if a != 0:
        v.add a
        t.add a.countTrailingZeroBits
    else:
      if a != 0:
        echo 1;return
  echo 0
  Naive:
    var r = initTable[(int, int), int]()
    proc test(i, X:int):int =
      if (i, X) in r: return r[(i, X)]
      if i == N:
        if X == 0: return 0
        else: return 1
      if S[i] == '0':
        if test(i + 1, X) == 0 or test(i + 1, X xor A[i]) == 0: result = 0
        else: result = 1
      else:
        if test(i + 1, X) == 1 or test(i + 1, X xor A[i]) == 1: result = 1
        else: result = 0
      r[(i, X)] = result
    echo test(0, 0)
  discard

when not DO_TEST:
  let T = nextInt()
  for _ in T:
    let
      N = nextInt()
      A = Seq[N:nextInt()]
      S = nextString()
    solve(N, A, S)
else:
  const T = 8
  for a in T:
    for b in T:
      for c in T:
        for d in T:
          for e in T:
            var A = @[a, b, c, d, e]
            let N = A.len
            for bb in 2^N:
              var S = ""
              for i in N:
                if bb[i] == 1:
                  S &= '1'
                else:
                  S &= '0'
              test(N, A, S)
