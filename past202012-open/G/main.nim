include atcoder/extra/header/chaemon_header
import atcoder/extra/other/bitutils

import atcoder/extra/other/direction

proc main():void =
  let H, W = nextInt()
  let S = newSeqWith(H, nextString())
  var v = Seq[2^(H * W), H * W: seq[(int, int)]]
  id(i, j:int) => i * W + j
  for i in 0..<H:
    for j in 0..<W:
      let p = id(i, j)
      v[1 << p][p] = @[(i, j)]
  for b in 0..<2^(H * W):
    for i in 0..<H:
      for j in 0..<W:
        let p = id(i, j)
        if v[b][p].len == 0: continue
        for (i2, j2) in (i, j).neighbor(dir4, (0..<H, 0..<W)):
          let p2 = id(i2, j2)
          if b[p2]: continue
          let b2 = b or [p2]
          if v[b2][p2].len > 0: continue
          v[b2][p2] = v[b][p] & (i2, j2)
  var b = 0
  for i in 0..<H:
    for j in 0..<W:
      if S[i][j] == '#':
        b[id(i, j)] = 1
  for i in 0..<H:
    for j in 0..<W:
      let p = id(i, j)
      if v[b][p].len > 0:
        echo v[b][p].len
        for t in v[b][p]:
          echo t[0] + 1, " ", t[1] + 1
        return

  return

main()
