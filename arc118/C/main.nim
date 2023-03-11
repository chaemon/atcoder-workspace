include atcoder/extra/header/chaemon_header

const M = 10000

#const DEBUG = true

proc solve(N:int) =
  var appeared = initSet[int]()
  var r = N
  var ans = Seq[int]
  var i: int
  i = 1
  while r >= 3:
    let b = i * 2 * 3
    if b in appeared:
      i.inc
      continue
    if b > M: break
    appeared.incl b
    ans.add b
    r.dec
    i.inc
  i = 1
  while r >= 2:
    let b = i * 3 * 5
    if b in appeared:
      i.inc
      continue
    if b > M: break
    appeared.incl b
    ans.add b
    r.dec
    i.inc
  i = 1
  while r >= 1:
    let b = i * 5 * 2
    if b in appeared:
      i.inc
      continue
    if b > M: break
    appeared.incl b
    ans.add b
    r.dec
    i.inc
  assert r == 0
  echo ans.join(" ")
#  block check:
#    assert ans.len == N
#    for i in 0..<N:
#      for j in i+1..<N:
#        assert ans[i] != ans[j]
#        assert gcd(ans[i], ans[j]) > 1
#    var g = 0
#    for i in 0..<N:
#      assert ans[i] in 1..M
#      g = gcd(g, ans[i])
#    assert g == 1
  return

proc test() =
  for N in 3..2500:
    echo "test: ", N
    solve(N)

#test()

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

