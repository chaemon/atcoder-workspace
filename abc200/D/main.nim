include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(N:int, A:seq[int]) =
  var ans = Seq[200: seq[int]]
  let M = min(N, 10)
  for b in 0..<2^M:
    var s = 0
    v := Seq[int]
    for i in 0..<M:
      if b[i]:
        v.add(i + 1)
        s += A[i]
        s = s mod 200
    if ans[s].len > 0:
      echo YES
      echo $(ans[s].len) & " " & ans[s].join(" ")
      echo $(v.len) & " " & v.join(" ")
      return
    ans[s] = v
  echo NO
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

