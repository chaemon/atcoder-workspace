include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(t:int, N:int) =
  let N = N - 1
  s := initSet[int]()
  for a in 0..<100:
    let u = (100 + t) * a div 100
    s.incl u
  var rs = Seq[int]
  for p in 0..<100+t:
    if p notin s:
      rs.add(p)
#  debug s
  let q = N div rs.len
  let r = N mod rs.len
  echo q * (100 + t) + rs[r]
  return

# input part {{{
block:
  var t = nextInt()
  var N = nextInt()
  solve(t, N)
#}}}

