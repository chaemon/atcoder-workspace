include atcoder/extra/header/chaemon_header

var N:int

# input part {{{
proc main()
block:
  N = nextInt()
#}}}

# {{{ divisor
when not defined ATCODER_DEVISOR_HPP:
  const ATCODER_DEVISOR_HPP = 1
  import algorithm
  proc divisor(n:int):seq[int] =
    result = newSeq[int]()
    var i = 1
    while i * i <= n:
      if n mod i == 0:
        result.add(i)
        if i * i != n: result.add(n div i)
      i += 1
    result.sort(cmp[int])
# }}}

import atcoder/math

proc main() =
  var ds = divisor(N)
  var ans = int.inf
  for d in ds:
    let d2 = N div d
    if gcd(d, d2) > 1: continue
    # k = 2t + 1
    while true:
      if d mod 2 == 0: break
      var r = newSeq[int]()
      var r0 = - invMod(2, d) mod d
      if r0 < 0: r0 += d
      r.add r0
      r.add d2 - 1
      let a = crt(r, @[d, d2])
      if a == (0, 0):
        break
      let t = a[0]
      let k = 2 * t + 1
      ans.min=k
      break
    # k = 2t
    while true:
      if d2 mod 2 == 0: break
      var r = newSeq[int]()
      var r1 = - invMod(2, d2) mod d2
      if r1 < 0: r1 += d2
      r.add 0
      r.add r1
      let a = crt(r, @[d, d2])
      if a == (0, 0):
        break
      var t = a[0]
      if t == 0: t += a[1]
      let k = 2 * t
      ans.min=k
      break
  echo ans
  return

main()

