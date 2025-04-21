when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(a:int, b:int, c:int, d:int, e:int):
  var
    v:seq[(int, string)]
    sc = [a, b, c, d, e]
  for bt in 2^5:
    if bt == 0: continue
    var
      s = 0
      name = ""
    for i in 5:
      if bt[i] == 1:
        s += sc[i]
        name &= 'A' + i
    v.add (-s, name)
  v.sort
  var ans:seq[string]
  for (s, name) in v:
    ans.add name
  echo ans.join("\n")
  doAssert false
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  var e = nextInt()
  solve(a, b, c, d, e)
else:
  discard

