include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let H, W = nextInt()
  let S = Seq(H, nextString())
  var ans = 0
  for i in 0..<H - 1:
    for j in 0..<W - 1:
      var s = 0
      for x in i..i+1:
        for y in j..j+1:
          if S[x][y] == '#':s.inc
      if s == 1 or s == 3: ans.inc
  echo ans
  discard

