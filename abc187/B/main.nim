include atcoder/extra/header/chaemon_header

const EPS = 1e-10

proc solve(N:int, x:seq[int], y:seq[int]) =
  proc valid(i, j:int):bool =
    let f = (y[i] - y[j]).float/(x[i] - x[j]).float
    if -1.0 - EPS < f and f < 1.0 + EPS: return true
    else: return false
  var ans = 0
  for i in 0..<N:
    for j in i+1..<N:
      if valid(i, j):ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
#}}}
