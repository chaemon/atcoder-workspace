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
solveProc solve(N:int, S:int, a:seq[int]):
  var
    a = a.sorted
    found = false
    ans:string
  while true:
    proc expr(i:int, s:string, si:int) =
      if i == N:
        if si == S:
          found = true
          ans = s
      else:
        var
          t = ""
          p = 1
          j = i
        while j < N:
          if j > i: t &= "x"
          t &= $a[j]
          p *= a[j]
          j.inc
          if i > 0:
            expr(j, s & "+" & t, si + p)
          else:
            expr(j, t, si + p)
    expr(0, "", 0)
    if not a.nextPermutation(): break
  if found:
    echo YES
    echo ans
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, S, a)
else:
  discard

