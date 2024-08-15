when defined SecondCompile:
  const DO_CHECK = false
else:
  const DO_CHECK = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

const DEBUG = false

include lib/header/chaemon_header

when DEBUG:
  var
    R = 0
    ans:seq[int]
    ct = 0
  for i in 500:
    ans.add -i
  for a in ans:
    R.max=abs(a)
  R.max=abs(ans.sum)
  import std/random
  randomize()
  ans.shuffle
  var
    erased = Seq[ans.len: false]

proc ask(i, j:int):bool = # i < j
  when not DEBUG:
    echo "? ", i + 1, " ", j + 1
    let Q = nextInt()
    if Q == -1: quit()
    return Q == 1
  else:
    ct.inc
    return ans[i] < ans[j]

proc add(i, j:int) =
  when not DEBUG:
    echo "+ ", i + 1, " ", j + 1
  else:
    doAssert not erased[i] and not erased[j]
    erased[i] = true
    erased[j] = true
    erased.add false
    let s = ans[i] + ans[j]
    doAssert abs(s) <= R
    ans.add s

# Failed to predict input format
solveProc solve():
  when not DEBUG:
    let N = nextInt()
  else:
    let N = ans.len
  var a = (0 ..< N).toSeq
  # ソートする
  proc f(l, r:int):seq[int] =
    if r - l == 1: return @[a[l]]
    let m = (l + r) div 2
    var
      a = f(l, m)
      b = f(m, r)
      i = 0
      j = 0
    while i < a.len or j < b.len:
      if i < a.len and j < b.len:
        if ask(a[i], b[j]):
          result.add a[i]
          i.inc
        else:
          result.add b[j]
          j.inc
      elif i < a.len:
        result.add a[i]
        i.inc
      elif j < b.len:
        result.add b[j]
        j.inc
      else:
        doAssert false
  a = f(0, N)
  #for i in N - 1:
  #  doAssert not ask(a[i + 1], a[i])
  # A[a[0]] <= A[a[1]] <= ... <= A[a[N - 1]]となっている
  for t in N - 1:
    # t + Nを追加
    let u = t + N
    add(a[0], a[^1])
    a = a[1 ..< ^1]
    var
      r = a.low
      count = a.high - a.low + 1
      step, pos: int
    while count != 0:
      step = count shr 1
      pos = r + step
      if ask(a[pos], u):
        r = pos + 1
        count -= step + 1
      else:
        count = step
    a = a[0 ..< r] & u & a[r ..< a.len]
  doAssert false
  echo "!"
  when DEBUG:
    debug ct
    doAssert ct <= 25000
  discard

when not DO_TEST:
  solve()
else:
  discard

