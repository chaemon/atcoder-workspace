const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc doAssert2(b:bool) =
  if not b:
    while true:
      echo "Hello World"

solveProc solve(S:string, T:string, K:int, C:seq[string], A:seq[string]):
  var
    dp0 = Seq[26, T.len + 1, T.len + 1: int16(-1)] # 文字iからT[j ..< k]にするためのコスト
    dp1 = Seq[K, 52, T.len + 1, T.len + 1: int16(-1)] # A[i]のインデックスjからの部分文字列をT[k ..< l]にするためのコスト
  proc calc1(i, j, k, l: int):int16
  proc calc0(c, i, j: int):int16 =
    doAssert2 dp0[c][i][j] != -2
    #x =& dp0[c][i][j] # できない！！ -> できるようになった
    if dp0[c][i][j] != -1: return dp0[c][i][j]
    dp0[c][i][j] = -2
    result = int16.inf
    if i + 1 == j and c == T[i] - 'a': #何もしないでいい
      result = 0
    else:
      for k in K:
        if C[k][0] - 'a' != c: continue
        # C[k]をA[k]を変換
        let u = calc1(k, 0, i, j)
        if u < int16.inf:
          result.min=u + 1
    dp0[c][i][j] = result
  proc calc1(i, j, k, l:int):int16 =
    if dp1[i][j][k][l] != -1: return dp1[i][j][k][l]
    result = int16.inf
    if l - k < A[i].len - j:
      result = int16.inf
    elif j == A[i].len:
      if k == l: result = 0
      else: result = int16.inf
    else:
      # A[i][j]をk ..< k2にする
      for k2 in k + 1 .. l:
        let
          c = A[i][j] - 'a'
          v = calc1(i, j + 1, k2, l)
        if v == int16.inf: continue
        let u = calc0(c, k, k2)
        if u == int16.inf: continue
        result.min= u + v
    dp1[i][j][k][l] = result
  var dp2 = Seq[S.len + 1, T.len + 1: int16(-1)] # Sのi以降をTのj以降にするコスト
  proc calc2(i, j:int):int16 =
    if dp2[i][j] != -1: return dp2[i][j]
    if i == S.len:
      if j == T.len:
        result = 0
      else:
        result = int16.inf
    elif S.len - i > T.len - j:
      result = int16.inf
    elif j == T.len:
      result = int16.inf
    else:
      result = int16.inf
      for j2 in j + 1 .. T.len:
        # S[i]をj ..< j2にして
        let
          c = S[i] - 'a'
          v = calc2(i + 1, j2)
        if v == int16.inf: continue
        let u = calc0(c, j, j2)
        if u == int16.inf: continue
        result.min= u + v
    dp2[i][j] = result
  #echo calc1(0, 0, 1, 2) # aをbにできるか
  let ans = calc2(0, 0)
  if ans == int16.inf:
    echo -1
  else:
    echo ans
  discard

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  var K = nextInt()
  var C = newSeqWith(K, "")
  var A = newSeqWith(K, "")
  for i in 0..<K:
    C[i] = nextString()
    A[i] = nextString()
  solve(S, T, K, C, A)
else:
  discard

