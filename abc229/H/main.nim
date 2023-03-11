const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
#import rationals
import lib/math/internal_rationals

#proc `<`(l, r:Rational[int]):bool =
#  l.num * r.den < r.num * l.den

proc calc_val(l, r:Rational[int]):Rational[int] =
  #doAssert l < r
  var d = 1
  while true:
    # l.n / l.d = x / d
    var l0, r0:int
    if l.den == 0:
      l0 = -int.inf
    else:
      l0 = floorDiv(l.num * d, l.den) + 1
    if r.den == 0:
      r0 = int.inf
    else:
      r0 = ceilDiv(r.num * d, r.den) - 1
    if l0 <= r0:
      if r0 < 0:
        return r0 /// d
      elif 0 < l0:
        return l0 /// d
      else:
        return 0 /// 1
    d *= 2

solveProc solve(N:int, S:seq[string]):
  var
    S = S
    T = S
  for i in N:
    for j in N:
      T[i][j] = S[j][i]
  S = T
  for i in N:
    S[i].reverse
  var dp = initTable[string, Rational[int]]()
  proc calc(a:string):Rational[int] =
    if a in dp: return dp[a]
    var
      l = -1 /// 0
      r = 1 /// 0
    # Takahashi
    block:
      # advance
      var a = a
      for i in N - 1:
        if a[i] == 'W' and a[i + 1] == '.':
          swap a[i], a[i + 1]
          l.max=calc(a)
          swap a[i], a[i + 1]
      # eat
      for i in N:
        if a[i] == 'B':
          a[i] = '.'
          l.max=calc(a)
          a[i] = 'B'
    # Snuke
    block:
      # advance
      var a = a
      for i in N - 1:
        if a[i] == 'B' and a[i + 1] == '.':
          swap a[i], a[i + 1]
          r.min=calc(a)
          swap a[i], a[i + 1]
      # eat
      for i in N:
        if a[i] == 'W':
          a[i] = '.'
          r.min=calc(a)
          a[i] = 'W'
    result = calc_val(l, r)
    dp[a] = result
  var ans = Rational[int](0)
  for s in S:
    ans += calc(s)
  if ans > 0:
    echo "Takahashi"
  else:
    echo "Snuke"
  return

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

