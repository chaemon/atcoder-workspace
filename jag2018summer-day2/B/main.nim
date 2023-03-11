include atcoder/extra/header/chaemon_header

ans := 0

let N = nextInt()

for a in 0..<5: # 1
  for b in 0..<2: # 5
    for c in 0..<5: # 10
      for d in 0..<2: # 50
        for e in 0..<5: # 100
          let f = N - a - b - c - d - e
          if f >= 0: ans.inc

echo ans
