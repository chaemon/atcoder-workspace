when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  var
    ans: seq[string]
    s = ""
    l: seq[string]
    H = 0
    W = 0
    Q = nextInt()
  for i in Q:
    let q = nextInt()
    case q
      of 1:
        W.inc
        var c = nextString()[0]
        s &= c
      of 2:
        W = 0
        l.add s
        s = ""
      of 3:
        W = 0
        l.add s
        s = ""
        H.inc
        l.reverse
        ans.add l.join()
        l.setLen(0)
      else: doAssert false
  l.add s
  l.reverse
  ans.add l.join()
  echo H + 1, " ", W + 1
  for i in ans.len:
    echo "# " & ans[i]

when not DO_TEST:
  solve()
else:
  discard

