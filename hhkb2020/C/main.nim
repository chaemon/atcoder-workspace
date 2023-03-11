include atcoder/extra/header/chaemon_header


proc solve(N:int, p:seq[int]) =
  var c = 0
  var s = Seq(200010, false)
  for p in p:
    s[p] = true
    while s[c]:
      c.inc
    echo c
  return

# input part {{{
block:
  var N = nextInt()
  var p = newSeqWith(N, nextInt())
  solve(N, p)
#}}}
