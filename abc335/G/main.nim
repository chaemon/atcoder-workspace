when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

{.emit: """
#include<cstdio>
inline unsigned long long calc_mul(const unsigned long long &a, const unsigned long long &b, const unsigned long long &p){
  return (unsigned long long)(((unsigned __int128)(a)*b%p));
}
""".}

#proc calc_mul*(a,b,p:culonglong):culonglong {.importcpp: "calc_mul(#,#,#)", nodecl, inline.}

# ab mod m (m < 10^13) を求める
proc calc_mul(a, b, m:uint):uint =
  let
    mask = uint(1048575)
    a_high = a shr 40
    a_mid = (a shr 20) and mask
    a_low = a and mask
  var r = uint(0)
  r += b * a_high
  r.mod= m
  r.shl=20
  r.mod= m
  r += b * a_mid
  r.mod= m
  r.shl=20
  r.mod= m
  r += b * a_low
  r.mod= m
  return r

solveProc solve(N:int, P:int, A:seq[int]):
  proc powP(a, n:int):int =
    if n == 0: return 1
    else:
      let
        n2 = n shr 1
      result = powP(a, n2)
      result = calc_mul(result.uint, result.uint, P.uint).int
      if (n and 1) != 0:
        result = calc_mul(result.uint, a.uint, P.uint).int
  var
    p:seq[tuple[p, e:int]]
    M:seq[int] # (e[0] + 1) * (e[1] + 1) * ... * (e[i - 1] + 1)
    B:int
  block:
    var P1 = P - 1
    for i in 2 .. P1:
      if i * i > P1: break
      e := 0
      if P1 mod i == 0:
        while P1 mod i == 0:
          P1.div=i
          e.inc
        p.add (i, e)
    if P1 > 1: p.add (P1, 1)
    B = 1
    for (p, e) in p:
      M.add B
      B *= e + 1
    M.add B
  proc calc_order(a:int):int =
    result = P - 1
    for (p, e) in p:
      while result mod p == 0:
        r2 := result div p
        if powP(a, r2) == 1:
          result = r2
        else:
          break
  proc id(m:int):int =
    var m = m
    result = 0
    for i, (p, e) in p:
      var e1 = 0
      while m mod p == 0:
        e1.inc
        m.div=p
      # 0 <= e1 <= e
      result += e1 * M[i]
  var a = Seq[B: 0]
  for i in N:
    let m = calc_order(A[i])
    a[id(m)].inc
  var a0 = a
  # aを高速ゼータ変換
  for i in p.len:
    for j in B:
      # M[i] -> M[i + 1]
      let t = (j mod M[i + 1]) div M[i]
      if t + 1 <= p[i].e:
        a[j + M[i]] += a[j]
  ans := 0
  for i in a.len:
    ans += a0[i] * a[i]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, P, A)
else:
  discard

