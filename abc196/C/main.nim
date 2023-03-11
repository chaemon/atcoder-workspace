include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int) =
  var ans = 0
  for a in 1..1000000:
    var d = 0
    block:
      var a = a
      while a > 0:
        d.inc
        a = a div 10
    let N2 = a * 10^d + a
    if N2 <= N: ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

