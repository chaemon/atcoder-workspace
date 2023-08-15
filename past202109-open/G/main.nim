when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, K:int, A:seq[int], B:seq[int], C:seq[int]):
  proc f(T:int):bool =
    # T以下の数がK個未満=>false
    # K個以上=>true
    var ct = 0
    for i in N:
      # B[i] + t * C[i] <= Tなるtの数
      if T < B[i]: continue
      elif B[i] + (A[i] - 1) * C[i] <= T:
        ct += A[i]
      else:
        # t <= T - B[i]
        let tmax = (T - B[i]) /. C[i]
        ct += tmax + 1
    return K <= ct
  echo f.minLeft(0 .. 10^18)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, K, A, B, C)
else:
  discard

