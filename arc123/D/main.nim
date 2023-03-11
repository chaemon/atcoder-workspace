const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/extra/other/binary_search

solveProc solve(N:int, A:seq[int]):
  var s = 0
  var S = 0
  var a = Seq[Slice[int]]
  for i in N:
    S += abs(A[i])
    var l, r:int
    if A[i] >= 0:
      l = 0
      r = A[i]
    else:
      l = A[i]
      r = 0
    l -= s
    r -= s
    a.add(l..r)
    if i + 1 < N:
      let d = A[i + 1] - A[i]
      if d > 0: s += d
  proc f(x:int):bool =
    var left, right = 0
    for i in N:
      if x < a[i].a: right.inc
      elif a[i].b < x: left.inc
    return left <= right
  
  let x = f.maxRight(-int.∞..int.∞)

  proc calc(x:int):int =
    var s = 0
    for i in N:
      if x < a[i].a: s += a[i].a - x
      elif a[i].b < x: s += x - a[i].b
    return S + s * 2

  var ans = int.∞
  for x in [x - 1, x, x + 1]:
    ans.min=calc(x)

  echo ans

  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

