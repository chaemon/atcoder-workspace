include atcoder/extra/header/chaemon_header

proc intersect(p, q:(int,int)):bool =
  return p[0] <= q[1] and q[0] <= p[1]

proc aoki(ans:seq[(int,int)]):int =
  var ans = ans
  ans.sort() do (p, q:(int,int)) -> int:
    cmp[int](p[0], q[0])
  var v = newSeq[(int,int)]()
  for i in 0..<ans.len:
    var valid = true
    for p in v:
      if intersect(p, ans[i]):valid = false;break
    if valid: v.add(ans[i])
  return v.len

proc takahashi(ans:seq[(int,int)]):int =
  var ans = ans
  ans.sort() do (p, q:(int,int)) -> int:
    cmp[int](p[1], q[1])
  var v = newSeq[(int,int)]()
  for i in 0..<ans.len:
    var valid = true
    for p in v:
      if intersect(p, ans[i]):valid = false;break
    if valid: v.add(ans[i])
  return v.len

proc solve(N:int, M:int) =
  if N == 1:
    if M == 0:
      echo "1 10"
    else:
      echo -1
    return
  elif M < 0:
    echo -1
    return
#    let T = M + 1 # takahashi: M + 1, aoki: 1
#    ans.add((1, 10^8 - 1))
#    var l = 2
#    for i in 0..<T - 1:
#      ans.add((l, l + 1))
#      l += 2
#    var r = 10^8
#    for i in 0..<N - T:
#      ans.add((l, r))
#      l.inc
#      r.inc
  elif M > N - 2:
    echo -1;
    return
  var ans = newSeq[(int,int)]()
#    var M = -M
  ans.add((1, 10^8 - 1))
  let A = M + 1 # aoki: 1, takahashi: M + 1
  var l = 2
  for i in 0..<A-1:
    ans.add((l, l + 1))
    l += 2
  var r = 10^8 - 1 - 1
  for i in 0..<N - A:
    ans.add((l, r))
    l.inc
    r.dec
  for (x, y) in ans:
    echo x, " ", y
  when false:
    var st = initSet[int]()
    for (x, y) in ans:
      assert 1 <= x and x <= 10^9
      assert 1 <= y and y <= 10^9
      assert x notin st
      st.incl(x)
      assert y notin st
      st.incl(x)
    assert takahashi(ans) - aoki(ans) == M
  return

#proc test() =
#  for N in 1..100:
#    for M in -N..N:
#      echo "test: ", N, " ", M
#      solve(N, M)
#  echo "test_end"

#test()

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}
