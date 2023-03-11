include atcoder/extra/header/chaemon_header


#const DEBUG = true

proc solve(S:string) =
  var ans = 0
  var r = S.len
  while r >= 0:
    debug r
    var l = r - 1
    while l >= 1 and S[l] != S[l - 1]:
      l.dec
    if l < 1: break
    debug l, r
    assert S[l] == S[l - 1]
    debug l, r
    let c = S[l]
    for i in l + 1 ..< r:
      if S[i] != c:
        ans.inc
    if not (r < S.len and S[r] == c):
      ans += S.len - r
    while l >= 0 and S[l] == c: l.dec
    r = l
  echo ans
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

