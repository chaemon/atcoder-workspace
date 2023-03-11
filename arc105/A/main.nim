include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(A:int, B:int, C:int, D:int) =
  let v = [A, B, C, D]
  let S = v.sum
  for b in 0..<(1 shl 4):
    var s = 0
    for i in 0..<4:
      if (b and (1 shl i)) > 0: s += v[i]
    if s * 2 == S:
      echo YES
      return
  echo NO
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(A, B, C, D)
#}}}
