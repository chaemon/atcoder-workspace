when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, K:int, A:seq[int]):
  proc f(s:int):bool =
    # s秒以内に印刷される枚数がK枚以内
    ans := 0
    for i in N:
      ans += s div A[i]
    return ans >= K
  echo f.minLeft(1 .. 10^9)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

