when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 200003
useStaticModInt(modint200003, MOD)
type mint = modint200003

type S = object
  e: int
  p: mint

var fact_v = Seq[MOD: mint]

block:
  var p = mint(1)
  for i in MOD:
    fact_v[i] = p
    p *= i + 1

proc `*`(a, b: S): S = S(e: a.e + b.e, p: a.p * b.p)
proc `/`(a, b: S): S = S(e: a.e - b.e, p: a.p / b.p)
converter toMint(a: S): mint =
  if a.e > 0: return 0
  doAssert a.e == 0
  return a.p

proc fact(n: int): S =
  if n == 0:
    return S(e: 0, p: mint(1))
  let
    q = n div MOD
    r = n mod MOD
  result = S(e: 0, p: fact_v[r])
  result = result * fact(q)
  result.e += q
  discard

proc C(n, r: int): S =
  doAssert r >= 0
  if n >= 0:
    if r > n:
      return S(e: 0, p: mint(0))
    return fact(n) / (fact(r) * fact(n - r))
  else:
    let n = -n
    result = C(n + r - 1, n - 1)
    if r mod 2 != 0:
      result.p *= -1

solveProc solve(N: int, M: int):
  ans := mint(0)
  var n = 0
  while true:
    end_loop := false
    var v = @[n]
    if n > 0: v.add -n
    for n in v:
      var
        d = (n * (3 * n - 1)) div 2 + N
        s = mint(1)
      if n mod 2 != 0:
        s *= -1
      if d > M:
        end_loop = true
        break
      let t = M - d
      # C(- 2 * N, t)を計算
      s *= mint(C( - N * 2, t))
      #for i in t:
      #  s *= - 2 * N - i
      #  s /= i + 1
      if t mod 2 != 0: s *= -1
      ans += s
    if end_loop: break
    n.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

