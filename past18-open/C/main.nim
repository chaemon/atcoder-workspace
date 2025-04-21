when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(B:seq[int], R:seq[int], T:int):
  var a = Seq[T: true]
  for j in 2:
    block:
      var b = 0
      while b < T:
        for i in R[j]:
          let t = b + B[j] + i
          if t < T:
            a[t] = false
        b += B[j] + R[j]
  echo a.count(true)
  discard

when not defined(DO_TEST):
  var B = newSeqWith(2, 0)
  var R = newSeqWith(2, 0)
  for i in 0..<2:
    B[i] = nextInt()
    R[i] = nextInt()
  var T = nextInt()
  solve(B, R, T)
else:
  discard

