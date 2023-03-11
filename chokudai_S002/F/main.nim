include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  s := initSet[(int,int)]()
  for i in 0..<N:
    (A, B) := (A[i], B[i])
    if A > B: swap(A, B)
    s.incl((A, B))
  echo s.len
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
#}}}

