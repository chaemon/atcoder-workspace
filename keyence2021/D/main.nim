include atcoder/extra/header/chaemon_header
import atcoder/extra/other/bitutils
import bitops

let mp =
  [
  0,0,# dummy
  seqToBits[int](@[2, 1, 0]), # 2
  seqToBits[int](@[3, 1, 0]), # 3
  seqToBits[int](@[4, 1, 0]), # 4
  seqToBits[int](@[5, 2, 0]), # 5
  seqToBits[int](@[6, 1, 0]), # 6
  seqToBits[int](@[7, 3, 0]), # 7
  seqToBits[int](@[8, 4, 3, 2, 0]) # 8
  ]

#proc echo(a:varargs[string, `$`]) =
#  let a = a.join("")
#
#  system.echo(a)

proc check(N:int, ans:seq[string]) =
  assert ans.len == 2^N - 1
  for i in 0..<2^N:
    for j in i+1..<2^N:
      var ct = 0
      for k in 0..<ans.len:
        if ans[k][i] == ans[k][j]:ct.inc
      assert ct == 2^(N-1) - 1

proc solve(N:int) =
  if N == 1:
    echo 1
    echo "AB"
    return

  var v = newSeq[int]()
  var a = 1
  while true:
    v.add(a)
    a <<= 1
    if a[N] == 1:
      a = a xor mp[N]
    if a == 1: break
  assert v.len == 2^N - 1
  ans := newSeq[string]()
  for i in v.len:
    var vs = collect(newSeq): (for j in N:v[(i + j) mod v.len])
    var a = "?".repeat(2^N)
    for b2 in 2^N:
      var p = 0
      for k in 0..<N:
        if b2[k] == 1:
          p = p xor vs[k]
      if b2[0] == 0:
        a[p] = 'A'
      else:
        a[p] = 'B'
    ans.add(a)
  check(N, ans)
  echo ans.len
  for a in ans:
    echo a
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
