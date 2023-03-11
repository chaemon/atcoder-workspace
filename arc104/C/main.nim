include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"
var N:int
var A:seq[int]
var B:seq[int]

# input part {{{
block:
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    if A[i] >= 0: A[i].dec
    if B[i] >= 0: B[i].dec
#}}}

block main:
  var left = newSeqWith(N * 2, -1)
  var right = newSeqWith(N * 2, -1)
  var A_exist = newSeqWith(N * 2, false)
  var B_exist = newSeqWith(N * 2, false)
  var reserved = newSeqWith(N * 2, -1)
  proc check(i, j:int):bool =
    if A_exist[i]:
      if right[i] != -1:
        if right[i] != j: return false
      else:
        if A_exist[j] or B_exist[j]: return false
    if B_exist[j]:
      if left[j] != -1:
        if left[j] != i: return false
      else:
        if A_exist[i] or B_exist[i]: return false
    let C = j - i + 1
#    if reserved[i] != -1 and reserved[i] != C: return false
#    if reserved[j] != -1 and reserved[j] != C: return false
    for k in i..j:
      if reserved[k] != -1 and reserved[k] != C: return false
    return true

  for i in 0..<N:
    if A[i] >= 0 and B[i] >= 0 and A[i] >= B[i]:
      echo NO
      break main
    if A[i] != -1:
      if A_exist[A[i]]: echo NO;break main
      A_exist[A[i]] = true
    if B[i] != -1:
      if B_exist[B[i]]: echo NO;break main
      B_exist[B[i]] = true
    if A[i] != -1 and B[i] != -1:
      left[B[i]] = A[i]
      right[A[i]] = B[i]
      let C = B[i] - A[i] + 1
      for j in A[i]..B[i]:
        if reserved[j] != -1 and reserved[j] != C: echo NO;break main
        reserved[j] = C
  var dp = newSeq[bool](N * 2 + 1)
  dp[0] = true
  for i in countup(0, N * 2 - 1, 2):
    if not dp[i]: continue
    for k in 1..N:
      # i -> i + k
      # i + 1 -> i + k + 1
      # ...
      # i + k - 1 -> i + k * 2 - 1
      if i + k * 2 > N * 2: break
      var valid = true
      for j in 0..k - 1:
        if not check(i + j, i + j + k):valid = false
      if valid:
#        echo i, " -> ", i + k * 2
        dp[i + k * 2] = true
  if dp[N * 2]:
    echo YES
  else:
    echo NO
  break
