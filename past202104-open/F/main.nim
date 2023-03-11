include atcoder/extra/header/chaemon_header

const DEBUG = true

# Failed to predict input format
block main:
  let N, L, T, X = nextInt()
  var
    prev = 0
    t = 0
  for i in 0..<N:
    let A, B = nextInt()
    while true:
      if B < L:
        prev = 0
        t += A
        break
      else:
        if prev + A < T:
          prev += A
          t += A
          break
        elif prev + A == T:
          prev = 0
          t += A + X
          break
        else:
          if prev == 0: echo "forever";break main
          else:
            t += T - prev + X
            prev = 0
  echo t
  discard

