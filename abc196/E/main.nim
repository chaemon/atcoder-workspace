include atcoder/extra/header/chaemon_header

import atcoder/extra/other/binary_search

const DEBUG = true

proc solve(N:int, a:seq[int], t:seq[int], Q:int, x:seq[int]) =
  proc calc(x:int):int =
    var x = x
    for i in 0..<N:
      if t[i] == 1: x += a[i]
      elif t[i] == 2: x.max=a[i]
      elif t[i] == 3: x.min=a[i]
    return x
  var
    m = -int.inf
    M = int.inf
    lb = -int.inf
    ub = int.inf
  if 2 in t:
    lb = calc(-int.inf)
    proc f(x:int):bool = lb == calc(x)
    m = f.maxRight(-int.inf .. int.inf)
  if 3 in t:
    ub = calc(int.inf)
    proc f(x:int):bool = ub == calc(x)
    M = f.minLeft(-int.inf .. int.inf)
  let d = calc(m) - m
  for i in 0..<Q:
    if x[i] in m..M:
      echo x[i] + d
    elif x[i] < m:
      echo lb
    else:
      echo ub
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var t = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    t[i] = nextInt()
  var Q = nextInt()
  var x = newSeqWith(Q, nextInt())
  solve(N, a, t, Q, x)
#}}}

