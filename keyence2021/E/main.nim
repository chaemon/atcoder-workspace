include atcoder/extra/header/chaemon_header

var dp = Array(402, 402, 402, int32.inf)

proc solve(N:int, a:seq[int]) =
  proc calc(i, j, s:int):int32 = # i..<j
    ret =& dp[i][j][s]
    if ret != int32.inf: return ret
    if i == 0 and j == N:
      if s == 0:
        ret = 0
      else:
        ret = -int32.inf
    else:
      if (j - i + s) mod 2 == 0: # snuke
        ret = calc(i, j, s + 1)
      else: # ant
        if i - 1 >= 0:
          if j < N:
            if a[i - 1] > a[j]:
              ret = calc(i - 1, j, s)
            else:
              ret = calc(i, j + 1, s)
          else:
            ret = calc(i - 1, j, s)
        else:
          ret = calc(i, j + 1, s)
      if s > 0:
        if i - 1 >= 0: ret.max=calc(i - 1, j, s - 1) + a[i - 1].int32
        if j < N: ret.max=calc(i, j + 1, s - 1) + a[j].int32
    return ret
  for i in 0..N:
    echo calc(i, i, 0)

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
#}}}
