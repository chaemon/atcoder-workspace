const
  DO_CHECK = true
  DEBUG = true
include atcoder/extra/header/chaemon_header
#import lib/math/eratosthenes
import lib/math/static_eratosthenes

var es: Eratosthenes[10^7]

#var a:array[10^7 + 1, int32]

solveProc solve(N:int, K:int):
  #es := initEratosthenes(N + 1)
  es.init()
  ans := 0
  for n in 2 .. N:
    let f = es.factor(n)
    if f.len >= K: ans.inc
  echo ans
  #for n in 1 .. N: a[n] = n.int32
  #for n in 2 .. N:
  #  if a[n] == n: # prime
  #    for m in n * n .. N >> n:
  #      a[m] = n.int32
  #ans := 0
  #for n in 1 .. N:
  #  var
  #    n = n
  #    e = 0
  #  while n > 1:
  #    e.inc
  #    let p = a[n]
  #    while n mod p == 0:
  #      n.div=p
  #  if e >= K: ans.inc
  #echo ans
  return

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
