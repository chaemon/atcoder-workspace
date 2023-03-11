include atcoder/extra/header/chaemon_header


proc solve() =
  let N = nextInt()
  let A = newSeqWith(2^N, nextInt())
  var v = toSeq[int](0 ..< 2^N)
  for i in 0..<N:
#    debug v
    if i == N - 1:
      if A[v[0]] > A[v[1]]:
        echo v[1] + 1;return
      else:
        echo v[0] + 1;return
    var nv = newSeq[int]()
    for j in 0..<(v.len div 2):
      if A[v[j * 2]] > A[v[j * 2 + 1]]:
        nv.add(v[j * 2])
      else:
        nv.add(v[j * 2 + 1])
    swap(v, nv)
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
