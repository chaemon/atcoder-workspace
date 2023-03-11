const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

let X = nextString()

proc adj(a, b:char):bool =
  if a == '9':
    if b == '0': return true
    else: return false
  else:
    return a.ord + 1 == b.ord

block:
  if X[0] == X[1] and X[1] == X[2] and X[2] == X[3]:
    echo "Weak";break
  if adj(X[0], X[1]) and adj(X[1], X[2]) and adj(X[2], X[3]):
    echo "Weak";break
  echo "Strong"


