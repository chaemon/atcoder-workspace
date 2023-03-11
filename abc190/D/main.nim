include atcoder/extra/header/chaemon_header

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

const DEBUG = false

proc solve(N:int) =
  let d = N.divisor
  debug d
  var ans = 0
  for n in d:
    # n: odd
    if n mod 2 == 1:
      debug n
      ans.inc
    # n: even
    let n2 = n * 2
    let t = N div n - (n2 - 1)
    if t mod 2 == 0: ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
