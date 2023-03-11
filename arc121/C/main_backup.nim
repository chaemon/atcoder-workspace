include atcoder/extra/header/chaemon_header

const DEBUG = true
proc solve(N:int, p:seq[int]) =
  var
    p = p
    ans = Seq[int]
    ct = 0
    target = 0
  if N == 2:
    if p[0] == 0:
      echo 0
      echo ""
    else:
      echo 1
      echo 1
    return
  doAssert N >= 3
  let even = if (N - 3) mod 2 == 0: N - 3: else: N - 2
  let odd = if (N - 3) mod 2 == 1: N - 3: else: N - 2
  while target < N:
    if target >= N - 3: # only one choice
      while true:
        var valid = true
        for j in target..<N:
          if p[j] != j: valid = false
        if valid: break
        var t = -1
        if ct == 0:
          t = even
          ans.add(even)
        else:
          t = odd
          ans.add(odd)
        swap(p[t], p[t + 1])
        ct = 1 - ct
      break
    var i = -1
    for j in 0..<p.len:
      if p[j] == target:
        i = j;break
    doAssert i != -1
    debug target, i, p, ct
    while p[i] != i:
      debug p
      if ct == 0:
        if i mod 2 == 1:
          ans.add(i - 1)
          swap(p[i], p[i - 1])
          i.dec
        else:
          var t = even
          if i in [even, even + 1]: t -= 2
          debug t
          ans.add(t)
          swap(p[t], p[t + 1])
      else:
        if i mod 2 == 0:
          ans.add(i - 1)
          swap(p[i], p[i - 1])
          i.dec
        else:
          var t = odd
          if i in [odd, odd + 1]: t -= 2
          debug t
          ans.add(t)
          swap(p[t], p[t + 1])
      ct = 1 - ct
    target.inc
    i = -1
  for a in ans.mitems: a.inc
  echo ans.len
  echo ans.join(" ")
  doAssert p == (0..<N).toSeq
  doAssert(ans.len <= N^2)

proc solve() =
  let N = nextInt()
  var p = Seq[N:nextInt() - 1]
  solve(N, p)

proc test() =
  const N = 5
  solve(N, @[0, 2, 1, 3, 4])

#  var a = (0..<N).toSeq
#  while true:
#    echo "test: ", a
#    solve(N, a)
#    if not a.nextPermutation(): break
#  echo "test end"

test()

let T = nextInt()

for _ in T: solve()


