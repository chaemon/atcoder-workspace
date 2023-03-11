include atcoder/extra/header/chaemon_header


proc solve() =
  let C = nextString()
  if C[0] == C[1] and C[1] == C[2]:
    echo "Won"
  else:
    echo "Lost"
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
