when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(p:int, a:int, b:int):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var p = nextInt()
    var a = nextInt()
    var b = nextInt()
    solve(p, a, b)
else:
  discard

