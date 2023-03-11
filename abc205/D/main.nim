include atcoder/extra/header/chaemon_header
import lib/other/binary_search

const DEBUG = true

solveProc solve(N:int, Q:int, A:seq[int], K:seq[int]):
  var t:int
  proc index(k:int):int =
    # kのインデックスはいくつか?
    k - A.upperBound(k)
  proc f(k:int):bool =
    # kはインデックスt以前か?
    index(k) >= t
  for k in K:
    t = k
    echo f.minLeft(1..2 * 10^18)
  return

block:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var K = newSeqWith(Q, nextInt())
  solve(N, Q, A, K)
