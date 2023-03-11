const DEBUG = true
const DO_TEST = false

include atcoder/extra/header/chaemon_header
import random
randomize()

const DEBUG = true
proc solve(N:int, p:seq[int]) =
  let N = nextInt()
  var ct = 0
  var ans = Seq[int]
  var p = p
  while true:
    debug p
    if p == (0..<N).toSeq: break
    var
      candidate = Seq[int]
      candidate2 = Seq[int]
    for i in countup(ct, N - 2, 2):
      if p[i] > p[i + 1]: candidate.add(i)
      candidate2.add(i)
    debug candidate
    var j = -1
    if candidate.len == 0:
      j = candidate2[rand(0..<candidate2.len)]
    else:
      j = candidate[rand(0..<candidate.len)]
    swap(p[j], p[j + 1])
    ans.add(j)
  echo ans.len
  for a in ans.mitems: a.inc
  echo ans.join(" ")

let T = nextInt()

for _ in T:
  let N = nextInt()
  let p = Seq[N: nextInt() - 1]
  solve(N, p)


