include atcoder/extra/header/chaemon_header

var N:int
var S:string

# input part {{{
block:
  N = nextInt()
  S = nextString()
#}}}

block main:
  # write code here
  var ans = 0
  let N = S.len
  for i in 0..<N:
    var A, T, C, G = 0
    for j in i..<N:
      case S[j]:
        of 'A': A.inc
        of 'T': T.inc
        of 'C': C.inc
        of 'G': G.inc
        else: assert false
      if A == T and C == G: ans.inc
  echo ans
  break
