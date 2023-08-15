when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

const DO_TEST = false
include lib/header/chaemon_header
import lib/other/interactive

when DO_TEST:
  import random
  randomize()

# Failed to predict input format
#solveProc solve():
solveInteractive solve():
  # 1を探す
  when DO_TEST:
    let N0 = 20
    var P = (1 .. N0).toSeq
    random.shuffle(P)
    var ct = 0
    judgeEcho(N0)
  let N = nextInt()
  proc ask(i, j, k:int):bool =
    askEcho "? " & $i & " " & $j & " " & $k
    Judge(strm):
      let dummy = strm.nextString()
      let i, j, k = strm.nextInt() - 1
      ct.inc
      doAssert ct <= 25000
      judgeEcho if P[i] + P[j] > P[k]: "Yes" else: "No"
    let s = nextString()
    return s == "Yes"
  proc ans(P_out:seq[int]) =
    askEcho "! " & P_out.join(" ")
    Judge(strm):
      let dummy = strm.nextString()
      for i in N:
        doAssert P[i] == strm.nextInt()

  var
    d = initDeque[int]()
  for i in 1 .. N: d.addLast(i)

  while d.len >= 2:
    let i, j = d.popFirst()
    let
      r0 = ask(i, i, j)
      r1 = ask(j, j, i)
    if r0 and r1:
      continue
    if r0: d.addLast j
    else: d.addLast i
  let i1 = d.popFirst
  when DO_TEST:
    doAssert P[i1 - 1] == 1
  proc cmp(i, j:int):bool = # P[i] < P[j]かどうか？
    if i > N and j > N:
      return i < j
    elif i > N:
      return false
    elif j > N:
      return true
    else:
      return ask(j, i1, i)
  proc merge(a, b:seq[int]):seq[int] =
    doAssert a.len == b.len
    var i, j = 0
    let n = a.len
    while i < n or j < n:
      if i < n and j < n:
        if cmp(a[i], b[j]):
          result.add a[i]
          i.inc
        else:
          result.add b[j]
          j.inc
      elif i < n:
        result.add a[i]
        i.inc
      elif j < n:
        result.add b[j]
        j.inc
  proc getSorted(a:seq[int]):seq[int] =
    if a.len == 1: return a
    let n = a.len div 2
    var
      a0 = a[0 ..< n].getSorted
      a1 = a[n ..< n * 2].getSorted
    result = merge(a0, a1)
    #debug a, result
  let B = fastLog2(N - 1) + 1
  let Q = (1 .. 2^B).toSeq.getSorted()
  # Qは小さい順になっている
  var P_out = Seq[2^B: int]
  for i in 2^B:
    P_out[Q[i] - 1] = i + 1
  while P_out.len > N:
    discard P_out.pop()
  #debug P_out
  ans(P_out)
  discard

solve()
