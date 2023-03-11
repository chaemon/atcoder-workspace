include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(A:int, B:int, C:int) =
  var r2, r5:int
  block:
    let A = A mod 2
    # mod 2
    if A == 0:
      r2 = 0
    else:
      r2 = 1
  block:
    let A = A mod 5
    # mod 5
    if A == 0:
      r5 = 0
    else:
      if B mod 4 == 0:
        r5 = 1
      elif B mod 2 == 0:
        if C >= 2:
          r5 = 1
        else:
          let t = B mod 4
          r5 = (A^t) mod 5
      else:
        let C = C mod 2
        let B = B mod 4
        r5 = A^(B^C) mod 5
  for r in 0..<10:
    if r mod 2 == r2 and r mod 5 == r5:
      echo r;break
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}

