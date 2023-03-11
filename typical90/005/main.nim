const
  DO_CHECK = false
  DEBUG = false
  DO_TEST = false
include atcoder/extra/header/chaemon_header


var P = 10^9 + 7
let N, B, K = nextInt()
var C = Seq[K:nextInt()]
var A = Seq[B:0]
for c in C:
  A[c mod B] += 1
 
proc prod(a, b:seq[int]):auto =
  result = Seq[B:0]
  for i, aa in a:
    for j, bb in b:
      let k = (i + j) mod B
      result[k] = (result[k] + aa * bb) mod P

proc poww(a:seq[int], n:int):seq[int] =
  proc rotate(a:seq[int], r:int):seq[int] =
    result = Seq[B:0]
    for i,t in a:
      result[i*r mod B] = (result[i*r mod B] + t) mod P
  result = Seq[B:0]
  result[0] = 1
  var aa = a
  var n = n
  var r = 10
  while n > 0:
    if n % 2 != 0:
      result = prod(aa, rotate(result, r))
    aa = prod(aa, rotate(aa, r))
    n.div= 2
    r = r * r mod B

echo(poww(A, N)[0])

