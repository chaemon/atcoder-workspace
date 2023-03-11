const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, s:seq[string], t:seq[string]):
  for i in N:
    var found = false
    for a in [s[i], t[i]]:
      var ok = true
      for j in N:
        if i == j: continue
        if s[j] == a or t[j] == a: ok = false
      if ok: found = true
    if not found:
      echo NO
      return
  echo YES
  discard

when not DO_TEST:
  var N = nextInt()
  var s = newSeqWith(N, "")
  var t = newSeqWith(N, "")
  for i in 0..<N:
    s[i] = nextString()
    t[i] = nextString()
  solve(N, s, t)
else:
  discard

