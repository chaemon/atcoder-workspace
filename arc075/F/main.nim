include "atcoder/extra/header/chaemon_header.nim"

import BigNum

var first = true

var ans_naive = initTable[int,int]()

proc solve_naive(D:int):int =
  if first:
    for N in 1..10000000:
      var d = newSeq[int]()
      var N2 = N
      while N2 > 0:
        d.add(N2 mod 10)
        N2 = N2 div 10
      var d2 = d
      d2.reverse
      var revN = 0
      var p = 1
      for d in d2:
        revN += d * p
        p *= 10
      let D = revN - N
      if D notin ans_naive:
        ans_naive[D] = 0
      ans_naive[D].inc
  first = false
  return if D in ans_naive: ans_naive[D] else: 0

proc solve(D:int) =
  const B = 30
  var
    p10 = newSeq[Int]()
    p = newInt(1)
  for i in B + 1:
    p10.add(p.clone())
    if i == B: break
    p *= 10
  proc calc_pattern(t:int, start:bool):int =
    assert abs(t) < 10
    # rev(N) - N
    if start and t >= 0:
      return 10 - t - 1
    else:
      return 10 - abs(t)
  proc calc(d:int):Int =
    var
      s = 0
      t = d - s
      dp = newSeq[(Int,Int)]()
    dp.add((newInt(D), newInt(1)))
    while s <= t:
      var dp2 = newSeq[(Int,Int)]()
      let p = p10[t - s] - 1
#      debug p
#      debug dp
      let start = if s == 0: true else: false
      for (D, n) in dp:
        var r = (toInt((-D) mod 10) + 10) mod 10
        if r > 0: r -= 10
        let T = D - r * p
        if T mod 10 == 0:
          let 
            D2 = T div 10
            n2 = n * calc_pattern(r, start)
#          debug D, n, r, D2, n2
          dp2.add((D2, n2))
        if r != 0:
          r += 10
          let T = D - r * p
          if T mod 10 == 0:
            let 
              D2 = T div 10
              n2 = n * calc_pattern(r, start)
#            debug D, n, r, D2, n2
            dp2.add((D2, n2))
#        debug dp2
      s.inc
      t.dec
      swap dp, dp2
#    debug dp
    result = newInt(0)
    for (D, n) in dp:
      if D == newInt(0):
        result += n
#    debug d, result
  var ans = newInt(0)
  for d in 1..B:
    ans += calc(d)
#  let ans_naive = solve_naive(D)
#  debug ans, ans_naive
#  assert ans == ans_naive
  echo ans

proc test() =
  for D in 1..10000:
#  for D in 9..9:
    echo "D = ", D
    solve(D)

# input part {{{
block:
#  test()
  var D = nextInt()
  solve(D)
#}}}
