const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import lib/structure/set_map

import macros

macro Var(p:varargs[untyped]):untyped =
  echo p.len
  for i in 0..<p.len:
    echo p[i].repr
  discard

Var a(3, 4), b:int

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[int]):
#  proc f(a, b:int):bool = a < b
#  var a = initSortedMultiSet(int, false, f)
#  var b = initSortedMultiSet(int, false, f)
#  var c = initSortedMultiSet(int, false, f)
  var a: SortedMultiSet(int)
  var b: SortedMultiSet(int)
  var c: SortedMultiSet(int)
  a.init()
  b.init()
  c.init()

#  var a = initSortedMultiSet(int)
#  var b = initSortedMultiSet(int)
#  var c = initSortedMultiSet(int)
  var A = sorted(A)
  var B = sorted(B)
  var C = sorted(C)
  var ans = 0
  for i in 0..<N:
    a.insert(A[i])
    b.insert(B[i])
    c.insert(C[i])
    var x = *a.begin
    var it = b.upper_bound(x)
    if it != b.end:
      var it2 = c.upper_bound(*it)
      if it2 != c.end:
        a.erase(a.begin)
        b.erase(it)
        c.erase(it2)
        ans.inc
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  solve(N, A, B, C)
#}}}

