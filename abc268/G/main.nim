when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type Node = ref object
  ct, e:int
  next:array[26, Node]


solveProc solve(N:int, S:seq[string]):
  root := Node()
  for s in S:
    var nd = root
    for c in s:
      let i = c - 'a'
      nd.ct += 1
      if nd.next[i] == nil:
        nd.next[i] = Node()
      nd = nd.next[i]
    nd.e += 1
  for s in S:
    var
      nd = root
      ss = 0 # sの部分文字列
    for c in s:
      ss += nd.e
      let i = c - 'a'
      nd = nd.next[i]
    var st = nd.ct
    echo mint(ss) + mint(N - 1 - ss - st) / 2 + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

