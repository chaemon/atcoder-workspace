include atcoder/extra/header/chaemon_header


proc solve(N:int, S:string) =
  echo S.count('a') + S.count('i') + S.count('u') + S.count('e') + S.count('o')
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}
