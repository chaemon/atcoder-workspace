include atcoder/extra/header/chaemon_header

var N:int
var K:int
var X:seq[int]
var Q:int
var L:seq[int]
var R:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  X = newSeqWith(N, nextInt())
  Q = nextInt()
  L = newSeqWith(Q, 0)
  R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt() - 1
#}}}

proc main() =
  var ans = newSeq[int](Q)
  for ct in 0..<2:
    var
      next = newSeq[int](N)
      l = 0
    for i in 0..<N:
      while l < N and X[l] - X[i] < K: l.inc
      next[i] = l
    const B = 18
    type P = tuple[i, s:int]
    var
      doubling = newSeqWith(B, newSeq[P](N))
    for i in 0..<N:
      var s:int = if next[i] < N: X[next[i]] else: int.inf
      doubling[0][i] = (next[i], next[i])
    for j in 1..<B:
      for i in 0..<N:
        var (i2,s) = doubling[j - 1][i]
        if i2 < N:
          s += doubling[j - 1][i2].s
          i2 = doubling[j - 1][i2].i
        doubling[j][i] = (i2, s)

    for q in 0..<Q:
      var
        i = L[q]
        n = 0
        s = 0
      for b in countdown(B - 1, 0):
        let d = (1 shl b)
        if doubling[b][i].i <= R[q]:
          n += d
          s += doubling[b][i].s
          i = doubling[b][i].i
      if ct == 0:
        ans[q] -= s
        ans[q] -= L[q]
        ans[q] += n + 1
      else:
        ans[q] += (n + 1) * (N - 1) - (s + L[q])
    var X2 = newSeq[int](N)
    for i in 0..<N:
      X2[i] = -X[N - 1 - i]
    swap(X, X2)
    for q in 0..<Q:
      var
        L2 = N - 1 - R[q]
        R2 = N - 1 - L[q]
      swap(L2, L[q])
      swap(R2, R[q])
  echo ans.join("\n")
  return

main()
