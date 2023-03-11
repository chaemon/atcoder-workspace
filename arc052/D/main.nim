include atcoder/extra/header/chaemon_header

proc solve(K:int, M:int) =
  let T = 5
  var rs = newSeq[int]()
  for i in 0..11: rs.add((10^i - 1) mod K)
  let B = 10^T
  let q = M div B
  var tb = initTable[int,int]()
  for i in B:
    s := 0
    N := i
    for j in 0..<T:
      let r = N mod 10
      s += r * rs[j] mod K
      s %= K
      N //= 10
    if s notin tb: tb[s] = 0
    tb[s] += 1
  var ans = 0
  for i in 0..<q:
    s := 0
    N := i
    j := T
    while N > 0:
      let r = N mod 10
      s += r * rs[j] mod K
      s %= K
      N //= 10
      j.inc
    if s != 0: s = K - s
    if s in tb: ans += tb[s]
  let r = M mod B
  block:
    s2 := 0
    N := q
    j := T
    while N > 0:
      let r = N mod 10
      s2 += r * rs[j] mod K
      s2.mod= K
      N.div=10
      j.inc
    if s2 != 0: s2 = K - s2
    for i in 0..r:
      s := 0
      N := i
      for j in 0..<T:
        let r = N mod 10
        s += r * rs[j] mod K
        s.mod= K
        N.div=10
      if s == s2:
        ans.inc
  echo ans - 1
  return

# input part {{{
block:
  var K = nextInt()
  var M = nextInt()
  solve(K, M)
#}}}
