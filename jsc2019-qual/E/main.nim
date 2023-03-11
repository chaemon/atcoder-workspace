include atcoder/extra/header/chaemon_header

import atcoder/dsu

proc solve(N:int, H:int, W:int, R:seq[int], C:seq[int], A:seq[int]) =
  let D = 10^5
  var dsu = initDSU(D * 2)
  var v = newSeq[(int, int, int)]()
  var num_e = Seq(D * 2, 0)
  for i in 0..<N: v.add((-A[i], R[i], C[i]))
  var ans = 0
  v.sort()
  for i in 0..<N:
    var (A, R, C) = v[i]
    A *= -1
    let
      a = dsu.leader(R)
      b = dsu.leader(C + D)
    if a != b:
      let ns = num_e[a] + num_e[b]
      if dsu.size(a) + dsu.size(b) >= ns + 1:
        dsu.merge(a, b)
        ans += A
        let r = dsu.leader(a)
        num_e[r] = ns + 1
    else:
      if dsu.size(a) > num_e[a]:
        ans += A
        num_e[a].inc
  echo ans
  return

proc main() =
  var N = 0
  N = nextInt()
  var H = 0
  H = nextInt()
  var W = 0
  W = nextInt()
  var R = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    R[i] = nextInt()
    C[i] = nextInt()
    A[i] = nextInt()
    R[i].dec;C[i].dec
  solve(N, H, W, R, C, A);
  return

main()
