include atcoder/extra/header/chaemon_header

N := nextInt()
a := Seq(N, nextInt())

for i in 0..<N:
  if a[i] == 1:
    echo i + 1
