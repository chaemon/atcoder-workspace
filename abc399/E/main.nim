when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string, T:string):
  var
    StoT, TtoS = Seq[26: initSet[char]()]
    ans = 0
  for i in N:
    StoT[S[i] - 'a'].incl T[i]
    TtoS[T[i] - 'a'].incl S[i]
  for i in 26:
    for c in TtoS[i]:
      for j in i + 1 ..< 26:
        if c in TtoS[j]:
          echo -1;return
  for i in 26:
    if StoT[i].len == 0: continue
    let c = 'a' + i
    ans += StoT[i].len
    if c in StoT[i]: ans.dec
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

