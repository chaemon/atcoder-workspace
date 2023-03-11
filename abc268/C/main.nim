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

solveProc solve(N:int, p:seq[int]):
  var ans = Seq[N: int] # 回す角度
  for j in N:
    let i = p[j]
    let d = (i - j).floorMod N
    for d in [d - 1, d , d + 1]:
      let d = d.floorMod N
      ans[d].inc
  echo ans.max
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N, nextInt())
  solve(N, p)
else:
  discard

