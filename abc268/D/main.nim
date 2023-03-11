when defined SecondCompile:
  const
    DO_CHECK = false
    DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, S:seq[string], T:seq[string]):
  var tb = initSet[string]()
  for t in T: tb.incl t
  var a = (0..<N).toSeq
  while true:
    var found = false
    proc f(i: int, s:string): string =
      if found: return s
      if i == N:
        if s.len notin 3 .. 16:
          return ""
        if s notin tb:
          found = true
          return s
        return ""
      var s = s
      if i == 0:
        let ans = f(i + 1, s & S[a[i]])
        if found: return ans
      else:
        for j in 1 .. N:
          s &= '_'
          if s.len >= 16: break
          let ans = f(i + 1, s & S[a[i]])
          if found: return ans
      return ""
    let ans = f(0, "")
    if found:
      echo ans
      return
    if not a.nextPermutation: break
  echo -1

  #for T in T:
  #  ok := true
  #  if T[0] == '_' or T[^1] == '_':
  #    ok = false
  #  else:
  #    i := 0
  #    t := ""
  #    v := Seq[string]
  #    while i < T.len:
  #      while i < T.len and T[i] != '_':
  #        t.add T[i]
  #        i.inc
  #      v.add t
  #      while i < T.len and T[i] == '_':
  #        i.inc
  #      t = ""

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  var T = newSeqWith(M, nextString())
  solve(N, M, S, T)
else:
  discard

