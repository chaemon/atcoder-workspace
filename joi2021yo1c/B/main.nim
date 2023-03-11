include atcoder/extra/header/chaemon_header


proc solve(N:int, S:string) =
  var ans = 0
  for i in 0..<N:
    if i mod 2 == 0:
      if S[i] != 'I': ans.inc
    else:
      if S[i] != 'O': ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}
