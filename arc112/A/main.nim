include atcoder/extra/header/chaemon_header


const DEBUG = true

proc calc(L, R:int) =
  var ans = 0
  if R - L < L:
    discard
  elif R - L <= R:
    let d = R - L
    ans += (d + L) * (d - L + 1) div 2 + (1 - L) * (d - L + 1)
  else:
    ans += (R + L) * (R - L + 1) div 2 + (1 - L) * (R - L + 1)
    ans += (R - L + 1) * (R - L - R)
  echo ans

block main:
  let T = nextInt()
  for _ in T:
    let L, R = nextInt()
    calc(L, R)
  discard

