include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, S:seq[string], T:seq[int]) =
  var v = Seq[(int, string)]
  for i in N:
    v.add((T[i], S[i]))
  v.sort()
  echo v[^2][1]
  return

# input part {{{
block:
  var N = nextInt()
  var S = newSeqWith(N, "")
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextString()
    T[i] = nextInt()
  solve(N, S, T)
#}}}

