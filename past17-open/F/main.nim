when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type T = ref object
  c:seq[T]
  op:char
  n:mint

solveProc solve(N:int, p:seq[int], S:seq[string]):
  Pred p
  p = -1 & p
  var a = newSeqWith(N, new(T))
  for i in N:
    if i == 0: continue
    a[p[i]].c.add a[i]
  for i in N:
    if a[i].c.len == 0:
      a[i].n = mint(parseInt(S[i]))
    elif a[i].c.len == 2:
      a[i].op = S[i][0]
    else:
      doAssert false
  proc calc(v:T):mint =
    if v.c.len == 0:
      return v.n
    else:
      if v.op == '+':
        return calc(v.c[0]) + calc(v.c[1])
      else:
        return calc(v.c[0]) * calc(v.c[1])
  echo calc(a[0])
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N-2+1, nextInt())
  var S = newSeqWith(N, nextString())
  solve(N, p, S)
else:
  discard

