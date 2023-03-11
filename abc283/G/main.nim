when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

# Failed to predict input format
solveProc solve(N, L, R:int, A:seq[int]):
  var
    a = Seq[tuple[ind, x:int]]
  proc add(x:int) =
    var x = x
    for i in a.len:
      if x[a[i].ind] == 1:
        x.xor=a[i].x
    if x != 0:
      let i = x.fastLog2()
      for j in a.len:
        if a[j].x[i] == 1:
          a[j].x.xor=x
      a.add (i, x)
  for i in N:
    add(A[i])
  a.sort()
  ans := Seq[int]
  var L = L - 1
  for b in L ..< R:
    var t = 0
    for i in 0 .. a.len:
      if b[i] == 1:
        t.xor=a[i].x
    ans.add t
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  let N, L, R = nextInt()
  let A = Seq[N: nextInt()]
  solve(N, L, R, A)
else:
  discard

