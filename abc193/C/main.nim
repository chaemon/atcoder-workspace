include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int) =
  t := initSet[int]()
  for b in 2..40:
    var a = 2
    while true:
      let p = a^b
      if p <= N: t.incl(p)
      else: break
      a.inc
  echo N - t.len
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

