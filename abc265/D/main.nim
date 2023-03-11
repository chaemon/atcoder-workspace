const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, P:int, Q:int, R:int, A:seq[int]):
  var s = Seq[int]
  s.add 0
  for i in N:
    s.add s[^1] + A[i]
  var S:int
  proc f(n:int):bool =
    if n >= s.len: return true
    S <= s[n]
  for i in N:
    # 開始がi
    block:
      S = s[i] + P
      var j = f.minLeft(0 ..< s.len)
      if j >= s.len or s[j] != S: continue
    block:
      S = s[i] + P + Q
      var j = f.minLeft(0 ..< s.len)
      if j >= s.len or s[j] != S: continue
    block:
      S = s[i] + P + Q + R
      var j = f.minLeft(0 ..< s.len)
      if j >= s.len or s[j] != S: continue
    echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var R = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, P, Q, R, A)
else:
  discard

