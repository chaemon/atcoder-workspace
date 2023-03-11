include atcoder/extra/header/chaemon_header

#import atcoder/modint
import atcoder/extra/math/modint_montgomery

#type mint = modint1000000007
const MOD = 1000000007
#useStaticMontgomery(mint, MOD)
useDynamicMontgomery(mint, 2020)
#type mint = modint
mint.setMod(MOD)

proc solve(H:int, W:int, T:int) =
#  echo mint.getParameters()
  var a, b:int
  var c = 1
  # T * a == k * H
  a = H div gcd(T, H)
  b = W div gcd(T, W)
  c *= H div a
  c *= W div b
  var ans = mint(0)
  ans += 1
  ans += (mint(2)^a - 1)
  ans += (mint(2)^b - 1)
  let g = gcd(a, b)
  ans += (mint(2)^g - 2)
  ans = ans ^ c
  echo ans
  return

#{{{ main function
proc main() =
  var H = 0
  H = nextInt()
  var W = 0
  W = nextInt()
  var T = 0
  T = nextInt()
  solve(H, W, T);
  return

main()
#}}}
