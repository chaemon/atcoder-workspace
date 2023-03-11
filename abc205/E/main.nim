include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import atcoder/extra/math/combination

const DEBUG = true

#  system.echo("echo: ", x)
#  system.echo(x)

#dumpTree:
#  proc solve(N:int, M:int, K:int, output_stdout:static[bool] = false) =
#    echo N, M, K

#proc solve(N:int, M:int, K:int, output_stdout: static[bool] = false):auto =
solveProc solve(N:int, M:int, K:int):
  result = ""
  macro echo(x:varargs[typed]) =
    parseStmt(fmt"""for s in {x.repr}: result &= $s;(when output_stdout: stdout.write $s){'\n'}result &= "\n"{'\n'}(when output_stdout: stdout.write "\n")""")
  if N > M + K: echo mint(0);return
  var ans = mint.C(N + M, M)
  let d = N - (K + 1)
  if d >= 0: ans -= mint.C(N + M, d)
  echo ans
  Naive:
    return solve(N, M, K)

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  solve(N, M, K, true)
#}}}
