include atcoder/extra/header/chaemon_header
import atcoder/extra/math/eratosthenes

const DEBUG = true

proc solve(N:int) =
  es := initEratosthenes()
  ans := newSeq[int]()
  for i in 0..<N:
    f := es.factor(i + 1)
    s := 0
    for (p, e) in f:
      s += e
    ans.add(s + 1)
  echo ans.join(" ")
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

