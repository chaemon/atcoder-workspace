const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header
import atcoder/string as string_lib
import deques

solveProc solve(N:int, S:string):
  sa := S.suffixArray
  lcp := lcp_array(S, sa)
  proc calc(lcp:seq[int]):seq[int] =
    type P = tuple[l, h:int]
    q := initDeque[P]()
    ans := 0
    result.add ans
    for i in lcp.len:
      l := 1
      while q.len > 0:
        p := q.popFirst
        if p.h < lcp[i]:
          q.addFirst(p)
          break
        else:
          ans -= p.l * p.h
          l += p.l
      q.addFirst (l, lcp[i])
      ans += l * lcp[i]
      result.add ans
  ans := Seq[N: int]
  a := calc(lcp)
  b := calc(reversed(lcp)).reversed
  for i in a.len:
    ans[sa[i]] = N - sa[i] + a[i] + b[i]
  for a in ans:
    echo a
  return

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)

