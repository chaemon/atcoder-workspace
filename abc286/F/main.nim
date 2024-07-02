when defined SecondCompile:
  const DO_CHECK = false
else:
  const DO_CHECK = true
const
  USE_DEFAULT_TABLE = true

const DO_TEST = false

include lib/header/chaemon_header
import atcoder/math
import lib/other/interactive


#solveProc solve():
solveInteractive solve():
  var
    p = @[2^2, 3^2, 5, 7, 11, 13, 17, 19, 23]
    M = p.sum
  doAssert M <= 110 and 10^9 <= p.foldl(a * b)
  when DO_TEST:
    var
      M0: int 
      A0: seq[int]
      N0 = 198928
  proc ask1(M:int, A:seq[int]) =
    askEcho M
    askEcho A.join(" ")
    Judge(strm):
      M0 = strm.nextInt()
      for i in M0:
        A0.add strm.nextInt()
  proc ask2():seq[int] =
    Judge(strm):
      proc apply(a:seq[int]):seq[int] =
        result = newSeq[int](M0)
        for i in M0:
          result[i] = A0[a[i]]
      result = (0 ..< M0).toSeq
      for i in N0: result = result.apply
      judgeEcho (result.succ).join(" ")
    result = Seq[M: nextInt()].pred
  block:
    var
      base = 0
      a: seq[int]
    for d in p:
      var u = (base ..< base + d).toSeq
      u = u[^1] & u[0 .. ^2]
      a &= u
      base += d
    ask1(M, a)
  block:
    var
      base = 0
      r = Seq[int]
      B = ask2()
    for d in p:
      for i in base ..< base + d:
        if B[i] == base:
          r.add i - base
      base += d
    ans := crt(r, p)[0]
    askEcho ans
    when DO_TEST:
      doAssert ans == N0
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

