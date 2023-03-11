include atcoder/extra/header/chaemon_header


proc solve(N:int, A:seq[int]) =
  var ans = 0
  for l in 0..<N:
    for r in l..<N:
      var valid = true
      for i in l..r-1:
        if A[i] > A[i+1]: valid = false
      if valid: ans.max=r - l + 1
  print ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}
