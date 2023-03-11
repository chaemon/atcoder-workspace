include atcoder/extra/header/chaemon_header

# default-table {{{
import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, B.default)
  tables.`[]`(self, key)
#}}}

import atcoder/segtree

const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  var da, db = initTable[int, seq[int]]()
  for i in 0..<N: da[A[i] + i].add(i)
  for i in 0..<N: db[B[i] + i].add(i)
  var p = Seq[N: int]
  for k, v in da:
    if v.len != db[k].len: echo -1;return
    for i in v.len: p[db[k][i]] = v[i]
  var st = initSegTree(N, (a, b:int)=>a+b, ()=>0)
  ans := 0
  for i in 0..<N:
    ans += st[p[i]..^1]
    st[p[i]] = 1
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
#}}}

