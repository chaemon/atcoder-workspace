include atcoder/extra/header/chaemon_header


proc solve() =
  let T = nextInt()
  for _ in 0..<T:
    let N = nextInt()
    let A = newSeqWith(N, nextInt())
    var ldp, rdp = Seq(N, N, -1)
    if N == 1:
      echo "First";continue
    proc R(i, j:int):int
    proc L(i, j:int):int =
      if i > j: return 0
      if ldp[i][j] >= 0: return ldp[i][j]
      let b = A[j]
      let Rw = R(i, j - 1)
      if b <= Rw: result = 0
      else: result = L(i, j - 1) - Rw + b
      ldp[i][j] = result
    proc R(i, j:int):int =
      if i > j: return 0
      if rdp[i][j] >= 0: return rdp[i][j]
      let a = A[i]
      let Lw = L(i + 1, j)
      if a <= Lw: result = 0
      else: result = R(i + 1, j) - Lw + a
      rdp[i][j] = result
    let
      a = A[0]
      b = A[^1]
      Lw = L(1, N - 2)
      Rw = R(1, N - 2)
    if a <= Lw and b <= Rw: # N
      echo "First";continue
    let c = a - Lw
    if c > 0 and a == Lw + c and b == Rw + c: # P
      echo "Second";continue
    if c > 0 and a == Lw + c and b < Rw + c: # L
      echo "First";continue
    echo "Second"
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
