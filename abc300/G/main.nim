when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/eratosthenes

solveProc solve(N:int, P:int):
  var
    es = initEratosthenes()
    ps:seq[int]
  for p in es.enumPrime(P):
    ps.add p
  proc gen(p:seq[int], n:var int, ans:var seq[int], i = 0) =
    if p.len == i:
      ans.add n
      return
    else:
      let n_old = n
      while true:
        gen(p, n, ans, i + 1)
        n *= p[i]
        if n > N: break
      n = n_old

  proc gen(p:seq[int]):seq[int] =
    var
      n = 1
      ans:seq[int]
    gen(p, n, ans, 0)
    return ans
  let
    l = min(8, ps.len)
    v = gen(ps[0 ..< l]).sorted
    w = gen(ps[l .. ^1]).sorted
  var ans = 0
  for n in v:
    ans += w.upperBound(N div n)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  solve(N, P)
else:
  discard

