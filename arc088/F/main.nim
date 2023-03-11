include atcoder/extra/header/chaemon_header
import atcoder/extra/graph/graph_template
import atcoder/extra/other/binary_search

proc calc(g:Graph[int], k:int):bool =
  proc calc_vec(v:seq[int], k:int):int =
    assert v.len mod 2 == 1
    let t = v.len div 2
    var
      min_index = v.len - 1
      min_val = v[min_index]
      a = newSeq[tuple[i,j,s:int]]()
    for i in 0..<t:
      let j = 2 * t - 1 - i
      let s = v[i] + v[j]
      if s > k: return -1
      a.add((i, j, s))
    for i in 0..<t:
      let p = i
      a[p].j.inc
      a[p].s = v[a[p].i] + v[a[p].j]
      if a[p].s > k: return min_val
      min_index.dec
      min_val = v[min_index]
    for i in 0..<t:
      let p = t - 1 - i
      a[p].i.inc
      a[p].s = v[a[p].i] + v[a[p].j]
      if a[p].s > k: return min_val
      min_index.dec
      min_val = v[min_index]
    return min_val
  var valid = true

  proc dfs(u:int, p = -1):int =
    if not valid: return
    var v = newSeq[int]()
    for e in g[u]:
      if e.dst == p: continue
      if not valid: return
      let l = dfs(e.dst, u) + 1
      if l > k: valid = false;return
      v.add(l)
    if not valid: return
    v.sort()
    if v.len mod 2 == 0:
      var found = true
      for i in 0..<v.len:
        let j = v.len - 1 - i
        if i >= j: break
        if v[i] + v[j] > k:
          found = false;break
      if found: return 0
      if p != -1:
        if v.len > 0:
          let min_val = calc_vec(v[0..<v.len - 1], k)
          if min_val >= 0: return min_val
      valid = false
      return
    else:
      let min_val = calc_vec(v, k)
      if min_val == -1:
        valid = false
        return
      else:
        return min_val
  let t = dfs(0)
  if t > k: valid = false
  return valid

proc solve(N:int, a:seq[int], b:seq[int]) =
  var g = initUndirectedGraph(N, a, b)
  var ans = 1
  for u in 0..<N:
    var d = max(0, (g[u].len + 1) div 2 - 1)
    ans += d
  f(k) => g.calc(k)
  echo ans, " ", f.minLeft(1..N)
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
  return

main()
#}}}
