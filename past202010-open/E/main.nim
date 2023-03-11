include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, S:string) =
  var a = (0..<N).toSeq
  while true:
    var s = collect(newSeq):
      for i in 0..<N:S[a[i]]
    let S2 = s.join("")
    if not (S == S2 or S.reversed == S2):
      echo S2
      return
    if not a.nextPermutation(): break
  echo "None"
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

