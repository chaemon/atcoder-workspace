include atcoder/extra/header/chaemon_header


proc solve(N:int, P:seq[int]) =
  var P = P
  var i = 0
  var ans = newSeq[int]()
  while i < N - 1:
    if P[i] == i:
      echo -1;return
    else:
      var j = i
      while P[j] != i: j.inc
      for k in countdown(j - 1, i):
        ans.add(k)
        swap P[k], P[k + 1]
      for k in i..<j:
        if P[k] != k:
          echo -1;return
      i = j
  assert(ans.len == N - 1)
  block:
    var ans = ans
    ans.sort()
    for i in 0..<ans.len:
      assert ans[i] == i
  for a in ans:
    echo a + 1
  return

proc test() =
  let N = 6
  var a = newSeq[int](N)

# input part {{{
block:
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  solve(N, P)
#}}}
