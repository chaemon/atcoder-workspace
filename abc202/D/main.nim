include atcoder/extra/header/chaemon_header

import atcoder/extra/math/combination_table

const DEBUG = true

proc solve(A:int, B:int, K:int) =
  var
    ans = ""
    K = K
    a = A
    b = B
  for i in A + B:
    let c = int.C(a + b - 1, a - 1)
    if K < c:
      ans.add 'a'
      a.dec
    else:
      K -= c
      ans.add 'b'
      b.dec
  echo ans
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var K = nextInt() - 1
  solve(A, B, K)
#}}}

