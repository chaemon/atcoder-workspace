include atcoder/extra/header/chaemon_header

import BigNum

block solve:
  a := nextString()
  N := newInt(a)
  P := N^2
  Q := (N + 1)^2
  u := newInt(1)
  while u < Q: u *= 100
  while true:
    p := (P + u - 1) div u
    q := (Q + u - 1) div u
    if p < q:
      echo p
      break solve
    u = u div 100
