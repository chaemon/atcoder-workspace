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
solveProc solve(S:string, T:string):
  for w in 1 ..< S.len:
    var v:seq[string]
    var i = 0
    while i < S.len:
      let j = min(i + w, S.len)
      v.add S[i ..< j]
      i += w
    for c in 1 .. w:
      var T2:string
      for s in v:
        if s.len >= c:
          T2.add s[c - 1]
      if T == T2:
        echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

