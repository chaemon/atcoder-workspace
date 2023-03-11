const
  DO_CHECK = true
  DEBUG = true

include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], A:seq[int]):
  var posL, posR = newSeq[int]()
  block:
    var L, R = initSet[int]()
    L.incl 0
    R.incl 0
    for i in N:
      if X[i] < 0: L.incl -X[i]
      elif X[i] > 0: R.incl X[i]
    posL = L.toSeq.sorted
    posR = R.toSeq.sorted
  var
    cL = newSeq[seq[int]](posL.len)
    cR = newSeq[seq[int]](posR.len)
  block:
    for i in N:
      if X[i] < 0:
        let j = posL.lowerBound(-X[i])
        cL[j].add A[i]
      elif X[i] > 0:
        let j = posR.lowerBound(X[i])
        cR[j].add A[i]
  for i in cL.len: cL[i].sort
  for i in cR.len: cR[i].sort
  var
    dp0 = Seq[posL.len, posR.len, N + 1: int.inf]
    dp1 = Seq[posR.len, posL.len, N + 1: int.inf]
  # dp0[i][j]は左i -> 右jを訪れた場合のロスの最小値
  # dp1[i][j]は右i -> 左jを訪れた場合のロスの最小値
  for c in 0 .. N:
    dp0[0][0][c] = 0
    dp1[0][0][c] = 0
  for i in posL.len:
    for j in posR.len:
      for c in 0 .. N:
        block:
          # dp0[i][j]をdp1[j][i + 1]に伝搬させる
          if i + 1 < posL.len:
            var
              cost = 0
              d = posL[i + 1] + posR[j]
            for t in 0 ..< cL[i + 1].len:
              # 最初のt個を諦める。残りを取りに行く
              let p = c - (cL[i + 1].len - t)
              if p >= 0:
                dp1[j][i + 1][p].min= dp0[i][j][c] + d * c + cost
              cost += cL[i + 1][t]
            # jにいたまま全部あきらめる
            dp0[i + 1][j][c].min= dp0[i][j][c] + cost
          # dp0[i][j]をdp0[i][j + 1]に伝搬させる
          if j + 1 < posR.len:
            cost := 0
            d := posR[j + 1] - posR[j]
            for t in 0 .. cR[j + 1].len:
              # 最初のt個を諦める。残りを取りに行く
              let p = c - (cR[j + 1].len - t)
              if p >= 0:
                dp0[i][j + 1][p].min= dp0[i][j][c] + d * c + cost
              if t < cR[j + 1].len:
                cost += cR[j + 1][t]
        block:
          # dp1[j][i]をdp0[i][j + 1]に伝搬させる
          if j + 1 < posR.len:
            var
              cost = 0
              d = posR[j + 1] + posL[i]
            for t in 0 ..< cR[j + 1].len:
              # 最初のt個を諦める。残りを取りに行く
              let p = c - (cR[j + 1].len - t)
              if p >= 0:
                dp0[i][j + 1][p].min= dp1[j][i][c] + d * c + cost
              cost += cR[j + 1][t]
            # iにいたまま全部あきらめる
            dp1[j + 1][i][c].min= dp1[j][i][c] + cost
          # dp1[j][i]をdp1[j][i + 1]に伝搬させる
          if i + 1 < posL.len:
            cost := 0
            d := posL[i + 1] - posL[i]
            for t in 0 .. cL[i + 1].len:
              # 最初のt個を諦める。残りを取りに行く
              let p = c - (cL[i + 1].len - t)
              if p >= 0:
                dp1[j][i + 1][p].min= dp1[j][i][c] + d * c + cost
              if t < cL[i + 1].len:
                cost += cL[i + 1][t]
  let d = min(dp0[^1][^1][0], dp1[^1][^1][0])
  echo A.sum - d
  return

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    A[i] = nextInt()
  solve(N, X, A)
else:
  discard

