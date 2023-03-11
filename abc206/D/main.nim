include atcoder/extra/header/chaemon_header
import atcoder/dsu

const DEBUG = true
const DO_TEST = false

const B = 2 * 10^5

solveProc solve(N:int, A:seq[int]):
  var uf = initDSU(B + 1)
  for i in N:
    let j = N - 1 - i
    if i >= j: break
    uf.merge(A[i], A[j])
  var s = A.toSet()
  var ans = 0
  for g in uf.groups:
    if g[0] notin s: continue
    ans += g.len - 1
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A, true)
else:
  discard

