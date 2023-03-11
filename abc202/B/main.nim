include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(S:string) =
  var ans = ""
  for s in S:
    if s == '6': ans.add('9')
    elif s == '9': ans.add('6')
    else: ans.add(s)
  ans.reverse()
  echo ans
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

