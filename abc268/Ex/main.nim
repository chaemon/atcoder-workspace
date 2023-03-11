when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/string/aho_corasick

solveProc solve(S:string, N:int, T:seq[string]):
  var a = initAhoCorasick[26, 'a'.ord]()
  for s in T: a.add s
  a.build
  var
    now, ans = 0
  for s in S:
    let (r, next) = a.move(s, now)
    if r > 0:
      ans.inc
      now = 0
    else:
      now = next
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  var N = nextInt()
  var T = newSeqWith(N, nextString())
  solve(S, N, T)
else:
  discard

