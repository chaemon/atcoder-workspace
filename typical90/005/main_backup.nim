const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/generate_definitions

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

type P = tuple[a:seq[mint], p:int]

var BB:int
proc unit(self:P):P =
  result.a = Seq[BB: mint]
  result.a[0] = 1
  result.p = 1

proc `*=`(self:var P, a:P) =
  var b = Seq[BB:mint(0)]
  for ri in 0..<BB:
    for rj in 0..<BB:
      var r = ((ri * a.p) + rj) mod BB
      b[r] += self.a[ri] * a.a[rj]
  swap self.a, b
  self.p *= a.p
  self.p .mod= BB

generatePow(P)

solveProc solve(N:int, B:int, K:int, c:seq[int]):
  BB = B
  var a: P
  a.a = Seq[B: mint(0)]
  for i in 0..<K:
    a.a[c[i] mod B].inc
  a.p = 10 mod B
  echo (a^N).a[0]
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var B = nextInt()
  var K = nextInt()
  var c = newSeqWith(K, nextInt())
  solve(N, B, K, c)
#}}}
