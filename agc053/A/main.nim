include atcoder/extra/header/chaemon_header


const DEBUG = true

solveProc solve(N:int, S:string, A:seq[int]):
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  var A = newSeqWith(N+1, nextInt())
  solve(N, S, A, true)
#}}}

