const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

when not declared ATCODER_SMAWK_HPP:
  const ATCODER_SMAWK_HPP* = 1
  # https://noshi91.github.io/Library/algorithm/smawk.cpp.html
  proc smawk*(row_size, col_size:int, select:proc(i, j, k:int):bool):seq[int] =
    proc solve(row, col:seq[int]):seq[int] =
      let n = row.len
      if n == 0: return
      var c2:seq[int]
      for i in col:
        while c2.len > 0 and select(row[c2.len - 1], c2[^1], i): discard c2.pop()
        if c2.len < n: c2.add(i)
      var r2:seq[int]
      for i in countup(1, n - 1, 2):
        r2.add(row[i])
      let a2 = solve(r2, c2)
      var ans = newSeq[int](n)
      block:
        var i = 0
        while i != a2.len:
          ans[i * 2 + 1] = a2[i];
          i.inc
      var j = 0
      for i in countup(0, n - 1, 2):
        ans[i] = c2[j]
        let e = if i + 1 == n: c2[^1] else: ans[i + 1]
        while c2[j] != e:
          j.inc
          if select(row[i], ans[i], c2[j]):
            ans[i] = c2[j]
      return ans
    var
      row = (0 ..< row_size).toSeq
      col = (0 ..< col_size).toSeq
    return solve(row, col)

when not declared ATCODER_CONCAVE_MAX_PLUS_CONVOLUTION_HPP:
  const ATCODER_CONCAVE_MAX_PLUS_CONVOLUTION_HPP* = 1
  proc concave_max_plus_convolution*[T](a, b:seq[T]):seq[T] =
    let
      n = a.len
      m = b.len
    proc get(i, j:int):int = a[j] + b[i - j]
    proc select(i, j, k:int):bool =
      if i < k:
        return false
      elif i - j >= m:
        return true
      else:
        return get(i, j) <= get(i, k)
    let amax = smawk(n + m - 1, n, select)
    result = newSeq[T](n + m - 1)
    block:
      var i = 0
      while i != n + m - 1:
        result[i] = get(i, amax[i])
        i.inc
    return

when false:
  var
    a = @[1, 2, 3, 4, 5, 4, 3]
    b = @[1, 10, 19, 27, 34, 39, 41]
  doAssert a.len == b.len
  proc isConcave(a:seq[int]):bool =
    # concave
    var d:seq[int]
    for i in a.len - 1:
      d.add a[i + 1] - a[i]
    for i in d.len - 1:
      if not (d[i] >= d[i + 1]): return false
    return true
  doAssert a.isConcave and b.isConcave
  var c = concave_max_plus_convolution(a, b)
  var c2 = newSeqWith(a.len + b.len - 1, -int.inf)
  for i in a.len:
    for j in b.len:
      c2[i + j].max=a[i] + b[j]
  doAssert c == c2
  echo "OK!!!"

solveProc solve(N:int, R:int, A:seq[int]):
  var
    R = R
    B = N - R
  if R > B: swap R, B
  proc calc(l, r:int):array[2, array[2, seq[int]]] =
    let n = r - l
    var L = (n + 1) div 2
    # 長さはL + 1で固定
    for i in 2:
      for j in 2:
        result[i][j] = newSeqWith(L + 1, -int.inf)
    if n == 1:
      result[0][0][0] = 0
      result[1][1][1] = A[l] + A[l + 1]
    else:
      let m = (l + r) div 2
      var
        a = calc(l, m)
        b = calc(m, r)
      for i in 2:
        for j in 2:
          for k in 2:
            if j == 1 and k == 1: continue
            for h in 2:
              var c = concave_max_plus_convolution(a[i][j], b[k][h])
              for t in c.len:
                if c[t] < 0: c[t] = -int.inf
              for t in c.len:
                if t > L: break
                if c[t] >= 0:
                  result[i][h][t].max=c[t]
  let a = calc(0, N - 2)
  var ans = -int.inf
  for i in 2:
    for j in 2:
      ans.max=a[i][j][R]
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var R = nextInt()
  var A = newSeqWith(N-1, nextInt())
  solve(N, R, A)
else:
  discard

