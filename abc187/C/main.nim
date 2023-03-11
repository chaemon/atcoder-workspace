include atcoder/extra/header/chaemon_header


proc solve(N:int, S:seq[string]) =
  var a = initTable[string, array[2,bool]]()
  for S in S:
    var p:int
    var neg = 0
    if S[0] == '!':
      neg = 1
      let S = S[1 .. ^1]
      if S notin a: a[S] = [false, false]
      a[S][neg] = true
    else:
      if S notin a: a[S] = [false, false]
      a[S][neg] = true
  for k,v in a:
    if v[0] and v[1]:
      echo k;return
  echo "satisfiable"
  return

# input part {{{
block:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
#}}}
