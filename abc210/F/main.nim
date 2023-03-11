const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true
include atcoder/extra/header/chaemon_header

import lib/math/eratosthenes, atcoder/twosat

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, A:seq[int], B:seq[int]):
  a := initTable[int, seq[int]]()
  var es = initEratosthenes()
  var vars = 0
  for i in N:
    for (p, e) in es.factor(A[i]):
      a[p].add(i * 2)
  for i in N:
    for (p, e) in es.factor(B[i]):
      a[p].add(i * 2 + 1)
  vars += N * 2
  var c:seq[tuple[i:int, f:bool, j:int, g:bool]]
  for i in N:
    c.add((i * 2, true, i * 2 + 1, true))
    c.add((i * 2, false, i * 2 + 1, false))
  proc add_c(a:seq[int]) =
    let n = a.len
    var p = Seq[int]
    for i in 0 .. n: p.add vars;vars.inc

    for i in 0 ..< n:
      # p[i] => p[i + 1]
      c.add((p[i], false, p[i + 1], true))
      # a[i] => p[i + 1]
      c.add((a[i], false, p[i + 1], true))
      # a[i] => !p[i]
      c.add((a[i], false, p[i], false))
      # p[i] => !a[i]
      c.add((p[i], false, a[i], false))
    # p[0] == false
    c.add((p[0], false, p[0], false))
    discard
  for p, a in a:
    add_c(a)
  var ts = initTwoSAT(vars)
  for (i, f, j, g) in c:
    ts.add_clause(i, f, j, g)
  echo if ts.satisfiable(): YES else: NO
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
