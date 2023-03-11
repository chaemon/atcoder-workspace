const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

proc `-`(a, b:char):int = a.ord - b.ord
proc `+`(a:char, n:int):char = (a.ord + n).chr

solveProc solve(N:int, K:int, S:string):
  var
    next = Seq[S.len + 1, 26: S.len]
    ans = ""
  for i in 0 ..< S.len << 1:
    next[i] = next[i + 1]
    next[i][S[i] - 'a'] = i
  i := 0
  while ans.len < K:
    # i以降で次の文字をどうするか
    for j in 26:
      let t = next[i][j]
      # tを採用
      if ans.len + S.len - t >= K:
        i = t + 1
        ans.add 'a' + j
        break
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var S = nextString()
  solve(N, K, S)
#}}}

