when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/string/run_length_compress

solveProc solve(N:int, S:string):
  var
    a = S.encode()
    ans = 1
  for i in a.len:
    if i in 1 ..< a.len - 1 and a[i].c == '/' and a[i].n == 1 and a[i - 1].c == '1' and a[i + 1].c == '2':
      ans.max=min(a[i - 1].n, a[i + 1].n) * 2 + 1
  doAssert false
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

