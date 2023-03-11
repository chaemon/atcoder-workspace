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

proc solve() =
  let N = nextInt()
  var A = newSeqWith(N, nextInt())
  var d = newSeq[int]()
  for i in 0..<N:
    for t in A[i].divisor:
      d.insert(t)
  var n = -1
  var ans = -1
  for d in d:
    if d == 1: continue
    var k = 0
    for i in 0..<N:
      if A[i] mod d == 0: k.inc
    if n < k:
      n = k
      ans = d
  echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
