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
solveProc solve(A:int, B:int, C:int, D:int):
  proc fullhouse(v:seq[int]):bool =
    var v = v.sorted
    if v[0] == v[^1]: return false
    if v[0] == v[1] and v[1] == v[2] and v[3] == v[4]: return true
    if v[0] == v[1] and v[2] == v[3] and v[3] == v[4]: return true
    return false
  var v = @[A, B, C, D]
  for E in 1 .. 13:
    if fullhouse(v & E): echo YES;return
  echo NO;return
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(A, B, C, D)
else:
  discard

