const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes

const YES = "Yes"
const NO = "No"

const U = 79000
const B = 450
const T = 10^6 + 7
const P = 405818577188209.int

solveProc solve(N:int, Q:int, A:seq[int], L:seq[int], R:seq[int]):
  es := initEratosthenes()
  id := Seq[T: -1]
  pcount := 0
  h := 0
  for p in 2..<T:
    if es.isPrime(p):
      id[p] = pcount
      pcount.inc
  var pw = Seq[pcount: 0]
  pw[0] = 1
  for i in 1 ..< pcount:
    pw[i] = (pw[i - 1] * 3) mod P
  a := Seq[pcount: 0]
  hs := Seq[int]
  for i in N:
    hs.add h
    for (p, e) in es.factor(A[i]):
      e := e mod 3
      if e == 0: continue
      i := id[p]
      # a[i] => (a[i] + e) mod 3
      let ai = (a[i] + e) mod 3
      if ai > a[i]:
        while ai > a[i]:
          h += pw[i]
          h = floorMod(h, P)
          a[i].inc
      else:
        while ai < a[i]:
          h -= pw[i]
          h = floorMod(h, P)
          a[i].dec
  hs.add h
  for i in Q:
    if hs[L[i]] == hs[R[i]]:
      echo YES
    else:
      echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt()
  solve(N, Q, A, L, R)
else:
  import random
  for _ in 1000:
    N := 2*10^5
    Q := 2*10^5
    A := Seq[N: random.rand(1..10^6)]
    var L, R = Seq[Q: int]
    for i in 0 ..< Q:
      while true:
        L[i] = random.rand(0..<N)
        R[i] = random.rand(0..<N)
        if L[i] <= R[i]: break
    solve(N, Q, A, L, R)
