include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve() =
  var N0 = nextInt()
  let M, T = nextInt()
  var
    t = 0
    N = N0
  for i in 0..<M:
    let A, B = nextInt()
    N -= A - t
    if N <= 0:
      echo NO
      return
    N += B - A
    N.min=N0
    t = B
  N -= T - t
  if N <= 0: echo NO;return
  echo YES
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
