include atcoder/extra/header/chaemon_header

proc solve(N:int, M:int, H:seq[int], W:seq[int]) =
  var lower0, upper0 = 0
  var lower1, upper1 = 0
  for i in 0..<N:
    if i mod 2 == 0: upper1 += H[i]
    else: lower1 += H[i]
  var v = newSeq[(int, int)]()
  for i in 0..<N:v.add((H[i], 0))
  for i in 0..<M:v.add((W[i], 1))
  v.sort()
  var
    z = 0
    ans = int.inf
  # lower, upper, lower, upper
  for (h, t) in v:
    if t == 0:
      if z mod 2 == 0: # add: lower
        upper1 -= h
        lower0 += h
      else:
        lower1 -= h
        upper0 += h
      z.inc
    else:
      if z mod 2 == 0: # teacher: lower
        ans.min= upper0 + upper1 - lower0 - lower1 - h
      else:
        ans.min= upper0 + upper1 + h - lower0 - lower1
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var H = newSeqWith(N, nextInt())
  H.sort()
  var W = newSeqWith(M, nextInt())
  W.sort()
  solve(N, M, H, W)
#}}}
