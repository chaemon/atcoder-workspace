include atcoder/extra/header/chaemon_header


proc solve(N:int, L:int, A:seq[int], B:seq[int]) =
  if N == L:
    echo 0
    return
  var
    ans = 0
    l = 0
    r = L - 1
    li = 0
    ri = N - 1
  while B[li] == l:
    if A[li] != l:ans.inc
    l.inc
    li.inc
  while B[ri] == r:
    if A[ri] != r: ans.inc
    r.dec
    ri.dec
  # consider li..ri
  if li > ri:
    echo ans
    return
  var rs = newSeq[Slice[int]]()
  var i = li
  while i <= ri:
    var j = i + 1
    while j <= ri and B[j - 1] + 1 == B[j]: j.inc
    # index i..<j is consective
    var c = 0
    for k in i..<j:
      if A[k] == B[k]:c.inc
    if c > 0:
      ans += j - i - c
    else:
      rs.add(i..<j)
    i = j
#  echo rs
  var ans_rs = newSeqWith(rs.len, int.inf)
  block:
    var
      tbl = initTable[int,int]() # diff, index
      t = 0
    for i in 0..<N:
      if i == rs[t].a:
        if B[i] < A[i]: # do left
          if i - B[i] in tbl:
            ans_rs[t].min= rs[t].len + (i - 1 - tbl[i - B[i]])
        else:
          # cannot do left
          discard
        t.inc
      tbl[i - A[i]] = i
  block:
    var
      tbr = initTable[int,int]() # diff, index
      t = rs.len - 1
    for i in countdown(N - 1, 0):
      if i == rs[t].b:
        if A[i] < B[i]: # do right
          if i - B[i] in tbr:
            ans_rs[t].min= rs[t].len + (tbr[i - B[i]] - i - 1)
        else:
          # cannot do left
          discard
        t.dec
      tbr[i - A[i]] = i
#  echo ans_rs
  for p in ans_rs:
    if p == int.inf: echo -1;return
    ans += p
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var L = nextInt()
  var A = newSeqWith(N, nextInt() - 1)
  var B = newSeqWith(N, nextInt() - 1)
  solve(N, L, A, B)
#}}}
