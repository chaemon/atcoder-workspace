include atcoder/extra/header/chaemon_header


proc solve(N:int, S:string, T:string) =
  var v, w = newSeq[int]()
  for i,s in S:
    if s == '1':v.add(i)
  for i,s in T:
    if s == '1':w.add(i)
#  debug v, w
  if v.len < w.len or v.len mod 2 != w.len mod 2:
    echo -1;return
  var ans = 0
  var
    i = 0
  for j in 0..<w.len:
    if i >= v.len:
      echo -1;return
    while v[i] < w[j]:
      if i + 1 >= v.len:
        echo -1;return
      ans += v[i + 1] - v[i]
      i += 2
    if i >= v.len:
      echo -1;return
    assert v[i] >= w[j]
#    debug i, j, ans
    ans += v[i] - w[j]
    i.inc
  while i < v.len:
    if i + 1 >= v.len:
      echo -1;return
    ans += v[i + 1] - v[i]
    i += 2
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
#}}}
