const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/cumulative_sum
import lib/other/binary_search
import lib/other/bitutils

proc sum[T:SomeInteger](s:Slice[T]):T =
  if s.a > s.b: return T(0)
  else: return (s.b - s.a + T(1)) * (s.a + s.b) div T(2)

solveProc solve(S:string, K:int):
  var ct, s = initCumulativeSum[int](S.len)
  var a = Seq[int]
  for i in S.len:
    if S[i] == 'Y':
      ct[i] = 1
      s[i] = i
      a.add i
  proc calc(L:int):bool =
    if a.len < L: return false
    proc calc(l, r, k:int):int = # l..<k, k..r
      # l..<k
      block:
        let p = l..<k
        var c = ct[p]
        result += (k - c ..< k).sum - s[p]
        result += p.sum - s[p] - (l ..< k-c).sum
      # k..r
      block:
        let p = k..r
        var c = ct[p]
        result += s[p] - (k ..< k+c).sum
        result += (k + c .. r).sum - (p.sum - s[p])
      assert result mod 2 == 0
      result.div= 2
    var k = 0
    for i in a.len:
      let j = i + L - 1
      if j >= a.len: break
      # a[i] .. a[j]
      #block:
      #  var q = Seq[int]
      #  for k in a[i]..a[j]+1:
      #    q.add calc(a[i], a[j], k)
      #  debug i, q
      if k < a[i]:
        k.max= a[i]
      assert k in a[i] .. a[j]
      var cur = calc(a[i], a[j], k)
      while true:
        var k_next = k + 1
        if a[j] + 1 < k_next: break
        var cur_next = calc(a[i], a[j], k_next)
        if cur >= cur_next: # > だとだめなのなんでだろう？
          swap cur, cur_next
          swap k, k_next
        else:
          break
      if cur <= K: return true
    return false
  echo calc.maxRight(1..a.len+1)
  Naive:
    proc calc_inversion(a:seq[int]):int =
      for i in a.len:
        for j in i + 1 ..< a.len:
          if a[i] > a[j]: result.inc
    proc apply(a:seq[int]):string =
      result = S
      for i in 0..<S.len:
        result[i] = S[a[i]]
    var
      a = (0..<S.len).toSeq
      ans = 0
    while true:
      let M = a.calc_inversion
      if M <= K:
        let S = apply(a)
        var
          i = 0
          t = 0
        while i < S.len:
          if S[i] == 'Y':
            var j = i
            while j < S.len and S[j] == 'Y': j.inc
            t.max= j - i
            i = j
          else:
            i.inc
        ans.max=t
      if not a.nextPermutation: break
    echo ans
  return

when not DO_TEST:
  var S = nextString()
  var K = nextInt()
  solve(S, K)
#  solve_naive(S, K)
else:
  const N = 8
  for b in 2^N:
    var S = '.'.repeat(N)
    for i in N:
      if b[i]:
        S[i] = 'Y'
    debug S
    for K in 0..N^2>>N:
      test(S, K)
  discard

