include atcoder/extra/header/chaemon_header


proc solve(N:int, T:string) =
  if T.len <= 2:
    if T == "1": echo 2 * 10^10
    elif T == "0":echo 10^10
    elif T == "11": echo 10^10
    elif T == "10": echo 10^10
    elif T == "01": echo 10^10 - 1
    else: echo 0
    return
  var r:int
  if T.startsWith("11"):
    r = 0
  elif T[0] == '1':
    r = 1
  else:
    r = 2
  block:
    var r = r
    for i in 0..<N:
      if r == 2:
        if T[i] != '0':
          echo 0;return
      else:
        if T[i] != '1':
          echo 0;return
      r.inc
      if r == 3: r = 0
  ans := 10^10 - (r + N + 2) div 3 + 1
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var T = nextString()
  solve(N, T)
#}}}
