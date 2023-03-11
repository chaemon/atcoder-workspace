include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/combination

proc solve(a:int, b:int, c:int, d:int) =
  let m = max([a, b, c, d])
  var ans = mint(0)
  for t in -m..m:
    var valid = true
    if a + t < 0 or a - t < 0: valid = false
    if b + t < 0 or b - t < 0: valid = false
    if c + t < 0 or c - t < 0: valid = false
    if d + t < 0 or d - t < 0: valid = false
    if not valid: continue

    var p = mint(1)
    block:
      var
        n = c + d
        r = d - t
      if n >= 0 and n mod 2 == 0 and r >= 0 and r mod 2 == 0:
        n = n div 2
        r = r div 2
        debug t, n, r
        p *= mint.C(n, r)
      else:
        p = 0
    block:
      var
        n = d + a
        r = a - t
      if n >= 0 and n mod 2 == 0 and r >= 0 and r mod 2 == 0:
        n = n div 2
        r = r div 2
        debug t, n, r
        p *= mint.C(n, r)
      else:
        p = 0
    block:
      var
        n = a + b
        r = a + t
      if n >= 0 and n mod 2 == 0 and r >= 0 and r mod 2 == 0:
        n = n div 2
        r = r div 2
        debug t, n, r
        p *= mint.C(n, r)
      else:
        p = 0
    block:
      var
        n = c + b
        r = c - t
      if n >= 0 and n mod 2 == 0 and r >= 0 and r mod 2 == 0:
        n = n div 2
        r = r div 2
        debug t, n, r
        p *= mint.C(n, r)
      else:
        p = 0
    debug t, p
    ans += p
  echo ans
  return

# input part {{{
block:
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  solve(a, b, c, d)
#}}}
