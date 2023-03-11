include atcoder/extra/header/chaemon_header


proc solve(N:int) =
  for i in 0..<N:
    echo (i * 2 mod N) + 1, " ", ((i * 2 + 1) mod N) + 1
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
