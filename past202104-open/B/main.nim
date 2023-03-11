include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(S:string) =
  var i = 0
  while i < S.len:
    if S[i..<i+4] == "post":
      echo i div 4 + 1;return
    i += 4
  echo "none"
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

