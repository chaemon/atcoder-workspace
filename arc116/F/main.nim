include atcoder/extra/header/chaemon_header


#const DEBUG = true

# Failed to predict input format
block main:
  let K = nextInt()
  var odd, even = Seq[int]
  s := 0
  for _ in 0..<K:
    let N = nextInt()
    var A = Seq[N: nextInt()]
    if N == 1:
      s += A[0]
      continue
    let i = N div 2
    if N == 2:
      # i - 1, i
      let
        t = max(A[i - 1], A[i])
        a = min(A[i - 1], A[i])
      even.add(t - a)
      s += a
    elif N mod 2 == 0:
      let
        t = max(
              min(
                max(A[i - 2], A[i - 1]),
                max(A[i - 1], A[i])), 
              min(
                max(A[i - 1], A[i]),
                max(A[i], A[i + 1])))
        a = min(
              max(
                min(A[i - 2], A[i - 1]),
                min(A[i - 1], A[i])), 
              max(
                min(A[i - 1], A[i]),
                min(A[i], A[i + 1])))
      even.add(t - a)
      s += a
    else:
      # i - 1, i, i + 1
      let
        t = max(min(A[i - 1], A[i]), min(A[i + 1], A[i]))
        a = min(max(A[i - 1], A[i]), max(A[i + 1], A[i]))
      odd.add(t - a)
      s += a
  odd.sort(SortOrder.Descending)
  even.sort(SortOrder.Descending)
  debug even, odd, s
  var i, j = 0
  takahashi := true
#  while i < odd.len:
#    if odd[i] < 0: break
#    s += odd[i]
#    i.inc
  while j < even.len:
    if takahashi:
      s += even[j]
      debug j
    takahashi = not takahashi
    j.inc
  while i < odd.len:
    if takahashi:
      s += odd[i]
      debug i
    i.inc
  echo s
  discard

