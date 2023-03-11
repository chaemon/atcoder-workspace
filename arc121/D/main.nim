include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, a:seq[int]) =
  var neg, pos = Seq[int]
  for i in N:
    if a[i] < 0: neg.add a[i]
    else: pos.add a[i]
  neg.sort()
  pos.sort()
  var ans = int.inf
  for i in 0..<N:
    if (N + i) mod 2 != 0: continue
    var
      min_val = int.inf
      max_val = -int.inf
    var p = neg & 0.repeat(i) & pos
    for i in 0..<p.len:
      let j = p.len - i
      if i > j: break
      let s = p[i] + p[^(i + 1)]
      min_val.min=s
      max_val.max=s
    ans.min=max_val - min_val
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
#}}}

