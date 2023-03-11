include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int]) =
  var rank = Seq[N * 2: int]
  var v = collect(newSeq):
    for i in N * 2: (A:A[i], i:i)
  v.sort()
  for r in N * 2:
    let i = v[r].i
    rank[i] = r
  var ans = "?".repeat(N * 2)
  var lower:bool
  var stack = Seq[int]
  for i in N * 2:
    if stack.len == 0:
      if rank[i] < N: lower = true
      else: lower = false
      stack.add(i)
    elif lower:
      if rank[i] < N:
        stack.add(i)
      else:
        let j = stack.pop()
        ans[j] = '('
        ans[i] = ')'
    else:
      if rank[i] < N:
        let j = stack.pop()
        ans[j] = '('
        ans[i] = ')'
      else:
        stack.add(i)
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(2*N, nextInt())
  solve(N, A)
#}}}

