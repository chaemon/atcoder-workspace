when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitset

const B = 2 * 10^6

solveProc solve(N:int, d:seq[int]):
  var b = initBitSet[B * 2 + 10]()
  b[B] = 1
  for d in d:
    b = (b shl d) or (b shr d)
  for i in 0 .. 2000000:
    if b[i + B] == 1:
      echo i;return
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var d = newSeqWith(N-1, nextInt())
  solve(N, d)
else:
  discard

