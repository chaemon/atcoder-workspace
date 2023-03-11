include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(N:int, a:seq[int], b:seq[int]) =
  let
    sa = a.sum
    sb = b.sum
  if sa > sb: echo NO;return
  # sa + 2k == sb + k
  let k = sb - sa
  var ka = 0
  var kb = 0
  for i in 0..<N:
    if a[i] <= b[i]:
      ka += (b[i] - a[i] + 1) div 2
      if (b[i] - a[i]) mod 2 == 1:
        kb.inc
  if kb > k or ka > k: echo NO;return
  ka = k - ka
  kb = k - kb

  var s = 0
  for i in 0..<N:
    if a[i] > b[i]:
      s += a[i] - b[i]
  if s > kb: echo NO; return
  echo YES
  return


# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  solve(N, a, b)
#}}}
