include atcoder/extra/header/chaemon_header


proc solve(S:string, A:int, B:int, C:int, D:int) =
  let
    s0 = S[0..<A]
    s1 = S[A..<B]
    s2 = S[B..<C]
    s3 = S[C..<D]
    s4 = S[D..^1]
    c = "\""
  echo s0 & c & s1 & c & s2 & c & s3 & c & s4
  return

# input part {{{
block:
  var S = nextString()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(S, A, B, C, D)
#}}}
