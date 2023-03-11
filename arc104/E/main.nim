include atcoder/extra/header/chaemon_header
import atcoder/modint
import atcoder/extra/math/combination
import atcoder/extra/dp/longest_increasing_subsequence

type mint = modint1000000007

const MOD = 1000000007
var N:int
var A:seq[int]

# input part {{{
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

proc get_rank(a:seq[int], b:int):auto =
  var (r, a) = (0, a)
  var rank = newSeq[int](N)
  for i in 0..<N:
    rank[i] = r
    if i < N - 1 and (b and (1 shl i)) != 0: r.inc
  for i in 0..<N:
    a[i] = rank[a[i]]
  return a

proc calc(k:int, d:int):mint =
  if d == 0: return mint(1)
  elif k < d: return mint(0)
  result = mint(1)
  for i in 0..<d:
    result *= k - i

proc calcVal(p:seq[mint], k:int):mint =
  result = mint(0)
  for d in 0..<p.len:
    result += p[d] * calc(k, d)

const INF = 10^9 + 3

proc cut(v:var seq[(Slice[int], seq[mint])], A:int) =
  var v2 = @[(0..0, @[mint(0)])]
  for (s, p) in v.mitems:
    if s.b <= A: v2.add((s, p))
    elif A in s: v2.add((s.a..A, p))
    elif A < s.a:
      discard
    else:
      assert false
  if v2[^1][0].b < INF:
    v2.add((v2[^1][0].b + 1..INF, @[mint(0)]))
  swap(v, v2)

proc update(v:var seq[(Slice[int], seq[mint])], A:int) =
  var v2 = newSeq[(Slice[int], seq[mint])]()
  var s = mint(0)
  for (p, a) in v:
    var a2 = @[mint(0)] & a
    for i in 1..<a2.len:
      a2[i] *= mint.inv(i)
    a2[0] = s - a2.calc_val(p.a)
    var p2 = p.a + 1..p.b + 1
    p2.b .min= INF
    v2.add((p2, a2))
    if p.b == INF:break
    s += a2.calc_val(p2.b) - a2.calc_val(p2.a - 1)
  swap(v, v2)

proc calc(p:seq[seq[int]]):mint =
  var v = @[(0..0, @[mint(1)]), (1..INF, @[mint(0)])]
  for p in p:
    var minA = INF
    for p0 in p:
      minA.min=A[p0]
    v.update(minA)
    v.cut(minA)
  v.update(INF)
  return v[^1][1].calc_val(INF)

proc main() =
#  block:
#    let a = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
#    echo longestIncreasingSubsequence(a)
#    echo longestIncreasingSubsequence(a, false)
#    echo longestIncreasingSubsequence(a, true, true)
  if N == 1:
    echo 1
    return
  # write code here
  var a = (0..<N).toSeq
  var s = initSet[seq[int]]()
  while true:
    for b in 0..<(1 shl (N - 1)):
      let v = get_rank(a, b)
      s.incl(v)
    if not a.nextPermutation: break
  var ans = mint(0)
  for s in s:
    let l = s.longestIncreasingSubsequence(true, true).len
    let m = s.max
    var p = newSeq[seq[int]](m + 1)
    for i,s in s:
      p[s].add i
    ans += l * calc(p)
  var p = mint(1)
  for i in 0..<N: p *= A[i]
  ans /= p
  echo ans

main()
