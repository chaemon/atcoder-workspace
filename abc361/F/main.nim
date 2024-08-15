when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var
    v:seq[int]
    ans = int(sqrt(float(N)) + 1e-10)
  for b in 3 .. 61:
    let amax = int(pow(float(N), (1 / b)) + 1e-8)
    var a = 1
    while a <= amax:
      let t = a^b
      if t > N: break
      let u = int(sqrt(float(t)) + 1e-10)
      if u * u != t:
        v.add t
      a.inc
  v.sort
  v = v.deduplicate(isSorted = true)
  echo ans + v.len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

