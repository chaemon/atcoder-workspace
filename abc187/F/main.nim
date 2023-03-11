include atcoder/extra/header/chaemon_header
import atcoder/extra/other/bitutils

var is_clique = Array(2^18, false)
var dp = Array(2^18, 0.uint8)

const DEBUG = false

import atcoder/extra/graph/chromatic_number

#proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
#  var adj = Seq(N, N, false)
#  for i in M:
#    adj[A[i]][B[i]] = true
#    adj[B[i]][A[i]] = true
#  for b in 0..<2^N:
#    var v = newSeq[int]()
#    for i in 0..<N:
#      if b[i] == 1: v.add(i)
#    if v.len <= 1: is_clique[b] = true;continue
#    let t = v[^1]
#    var valid = true
#    for vi in v:
#      if vi < t and not adj[vi][t]: valid = false
#    if not is_clique[b xor (1 shl t)]: valid = false
#    is_clique[b] = valid
#  for b in 0..<2^N:
#    debug b, is_clique[b]
#  dp[0] = 0
#  for b in 1..<2^N:
#    var v = newSeq[int]()
#    for i in 0..<N:
#      if b[i] == 1: v.add(i)
#    let t = v.pop()
#    debug b, t
#    dp[b] = uint8.inf
#    for b2 in subsets[int](v):
#      let b2 = b2 or (1 shl t)
#      if not is_clique[b2]: continue
#      debug b, b2
#      dp[b].min=dp[b xor b2] + 1
#    debug b, dp[b]
#  echo dp[2^N - 1]
#  return


proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
  var adj = Seq(N, N, true)
  for i in M:
    adj[A[i]][B[i]] = false
    adj[B[i]][A[i]] = false
  echo chromatic_number(adj)

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, M, A, B)
#}}}
