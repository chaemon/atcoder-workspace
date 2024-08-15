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
solveProc solve(a:int, b:int, c:int, d:int, e:int, f:int, g:int, h:int, i:int, j:int, k:int, l:int):
  if max(a, g) < min(d, j) and max(b, h) < min(e, k) and max(c, i) < min(f, l):
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  var e = nextInt()
  var f = nextInt()
  var g = nextInt()
  var h = nextInt()
  var i = nextInt()
  var j = nextInt()
  var k = nextInt()
  var l = nextInt()
  solve(a, b, c, d, e, f, g, h, i, j, k, l)
else:
  discard

