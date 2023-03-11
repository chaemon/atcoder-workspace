include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(N:int, x:seq[int], y:seq[int]) =
  for i in 0..<N:
    for j in i + 1..<N:
      for k in j + 1..<N:
        if (y[i] - y[j]) * (x[i] - x[k]) == (x[i] - x[j]) * (y[i] - y[k]):
          echo YES;return
  echo NO
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
#}}}
