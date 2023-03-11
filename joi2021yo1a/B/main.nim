include atcoder/extra/header/chaemon_header


proc solve(N:int, S:string) =
  let j = S.count('J')
  let o = S.count('O')
  let i = S.count('I')
  echo "J".repeat(j) & "O".repeat(o) & "I".repeat(i)
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}
