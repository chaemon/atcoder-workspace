include atcoder/extra/header/chaemon_header
import std/complex


const DEBUG = true

# Failed to predict input format
block main:
  let N = nextInt()
  var x0, y0, x1, y1 = nextFloat()
  let p = complex[float]((x0 + x1) * 0.5, (y0 + y1) * 0.5)
  var v = complex[float](x0, y0) - p
  v *= rect(1.0, PI * 2.0 / N)
  v += p
  echo v.re, " ", v.im
  discard
