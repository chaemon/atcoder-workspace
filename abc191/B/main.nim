include atcoder/extra/header/chaemon_header

const DEBUG = true

proc solve(N:int, X:int, A:seq[int]) =
  var a = newSeq[int]()
  for v in A:
    if v != X: a.add(v)
  echo a.join(" ")
  return

# input part {{{
block:
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
#}}}

