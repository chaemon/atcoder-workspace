include atcoder/extra/header/chaemon_header


proc solve(S:string) =
  var ans = 0
  for s in S:
    if s in '0'..'9':
      ans *= 10
      ans += s.ord - '0'.ord
  echo ans
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}
