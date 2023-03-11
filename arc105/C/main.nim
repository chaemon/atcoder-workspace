const DO_CHECK = true
include atcoder/extra/header/chaemon_header

const DEBUG = true

solveProc solve(N:int, M:int, w:seq[int], l:seq[int], v:seq[int]):
  let vmin = v.min
  for i in 0..<N:
    if w[i] > vmin:
      echo -1;return
  var a = (0..<N).toSeq
  let vd = v.toSet().toSeq.sorted()
  var l_min = newSeqWith(v.len, 0)
  for i in 0..<M:
    let j = vd.binarySearch(v[i])
    assert(j >= 0)
    l_min[j].max=l[i]
  for i in 1..<v.len:
    l_min[i].max=l_min[i - 1]
  var ans = int.inf
  while true:
    var d = newSeq[int](N - 1)
    for i in 1..<N:
      var ws = w[a[i]]
      var ls = 0
      var d0 = 0
      for j in countdown(i - 1, 0):
        ws += w[a[j]]
        var k = vd.lowerBound(ws)
        k.dec
        if k >= 0 and l_min[k] >= ls:
          d0.max=l_min[k] - ls
        if j == 0: break
        ls += d[j - 1]
      d[i - 1] = d0
    ans.min=d.sum
    if not a.nextPermutation(): break
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var w = newSeqWith(N, nextInt())
  var l = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    l[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, w, l, v)
#}}}
