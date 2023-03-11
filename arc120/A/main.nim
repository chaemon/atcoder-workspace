include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int]) =
  var max_val = -int.inf
  var s = 0
  for i in 0..<N:
    var a = A[i] + max_val
    max_val.max=a
    s += a
    echo s
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

