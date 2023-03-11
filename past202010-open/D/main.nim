include atcoder/extra/header/chaemon_header


const DEBUG = true

proc calcA(S:string):string =
  result = '.'.repeat(S.len)
  for i in 0..<S.len:
    if S[i] == '#': result[i] = '#'
    if i + 1 < S.len and S[i + 1] == '#': result[i] = '#'
proc calcB(S:string):string =
  result = '.'.repeat(S.len)
  for i in 0..<S.len:
    if S[i] == '#': result[i] = '#'
    if i - 1 >= 0 and S[i - 1] == '#': result[i] = '#'


proc solve(N:int, S:string) =
  var ans_val = int.inf
  var ans_X, ans_Y:int
  let S_ans = '#'.repeat(N)
  for x in 0..50:
    for y in 0..50:
      var S = S
      for i in 0..<x: S = S.calcA()
      for i in 0..<y: S = S.calcB()
      if S != S_ans: continue
      if x + y < ans_val:
        ans_val = x + y
        ans_X = x
        ans_Y = y
  echo ans_X, " ", ans_Y
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

