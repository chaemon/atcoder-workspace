include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(S:string) =
  if S.len <= 3:
    var a = (0..<S.len).toSeq
    while true:
      var s = 0
      for i in 0..<a.len:
        s *= 10
        s += S[a[i]].ord - '0'.ord
      if s mod 8 == 0:
        echo YES;return
      if not a.nextPermutation(): break
    echo NO;return
  var ct = Seq(10, int)
  for s in S:
    ct[s.ord - '0'.ord].inc
  for p in 100..<1000:
    if p mod 8 != 0: continue
    var ct2 = Seq(10, int)
    var p = p
    for i in 0..<3:
      ct2[p mod 10].inc
      p = p div 10
    var valid = true
    for d in 0..<10:
      if ct[d] < ct2[d]:
        valid = false
    if valid: echo YES;return
  echo NO
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}
