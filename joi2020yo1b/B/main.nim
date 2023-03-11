include atcoder/extra/header/chaemon_header


proc solve(N:int, A:int, B:int, S:string) =
  echo S[0..<A] & (S[A..B].reversed).join.toStr & S[B+1..^1]
  return

# input part {{{
block:
  var N = nextInt()
  var A = nextInt() - 1
  var B = nextInt() - 1
  var S = nextString()
  solve(N, A, B, S)
#}}}
