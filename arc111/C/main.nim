include atcoder/extra/header/chaemon_header

import streams

const DEBUG = true

include atcoder/extra/other/special_judge

proc solve(N:int, a:seq[int], b:seq[int], p:seq[int]) =
  var vis = Seq(N, false)
  var ans = newSeq[(int,int)]()
  for i in 0..<N:
    if vis[i]: continue
    vis[i] = true
    if i == p[i]: continue
    var j = i
    var v = newSeq[int]()
    while true:
      vis[j] = true
      v.add(j)
      if a[j] <= b[p[j]]:
        echo -1;return
      j = p[j]
      if j == i: break
    min_weight := int.inf
    min_index := -1
    for vi,j in v:
      if b[j] < min_weight:
        (min_weight, min_index) = (b[j], vi)
#    debug v, min_index
    min_index.dec
    if min_index < 0:
      min_index = v.len - 1
    j := min_index
    while true:
      j2 := j - 1
      if j2 < 0: j2 = v.len - 1
      if j2 == min_index: break
      ans.add((v[j], v[j2]))
      j = j2
  echo ans.len
  for (j, j2) in ans:
    echo j + 1, " ", j2 + 1

  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  var p = newSeqWith(N, nextInt() - 1)
  solve(N, a, b, p)

  check:
    block check:
      for i in 0..<N:
        if p[i] != i and a[i] <= b[p[i]]:
          let t = strm.nextInt()
          assert t == -1
          stderr.write("check passed 2!!")
          break check
      let t = strm.nextInt()
      var p = p
      for i in 0..<t:
        let x, y = strm.nextInt() - 1
        assert x != y
        if a[x] <= b[p[x]] or a[y] <= b[p[x]]: assert false
        swap(p[x], p[y])
      for i in 0..<N:
        assert p[i] == i
      stderr.write("check passed!!")
#}}}
