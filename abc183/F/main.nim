include atcoder/extra/header/chaemon_header

type S = object
  t:Table[int,int]
  a:seq[int]

proc rank(s:S):int = s.a.len + s.t.len

proc solve() =
  let N, Q = nextInt()
  let C = newSeqWith(N, nextInt() - 1)
  var data = Seq(N, S)
  for i in 0..<N:
    var t = initTable[int,int]()
    t[C[i]] = 1
    data[i] = S(a: @[i], t:t)
  var id = (0..<N).toSeq()
  for i in 0..<Q:
    let q = nextInt()
    if q == 1:
      var a, b = nextInt() - 1
      var (ida, idb) = (id[a], id[b])
      if ida != idb:
        if rank(data[ida]) < rank(data[idb]):
          swap(a, b)
          swap(ida, idb)
        for v in data[idb].a:
          id[v] = ida
          data[ida].a.add(v)
        for k, v in data[idb].t:
          if k in data[ida].t:
            data[ida].t[k] += v
          else:
            data[ida].t[k] = v
    else:
      let x, y = nextInt() - 1
      echo if y in data[id[x]].t: data[id[x]].t[y] else: 0
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
