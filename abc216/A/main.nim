const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

let S = nextString()
let f = S.find('.')
let X = S[0..<f].parseInt
let Y = S[^1].ord - '0'.ord

stdout.write X
if Y in 0..2:
  echo "-"
elif Y in 3..6:
  echo ""
else:
  echo "+"


