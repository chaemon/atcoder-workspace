include atcoder/extra/header/chaemon_header

var A:int
var R:int
var N:int

#{{{ input part
proc main()
block:
  A = nextInt()
  R = nextInt()
  N = nextInt()
#}}}

proc main() =
  if R == 1:
    echo A
  else:
    for i in 0..<N-1:
      A *= R
      if A > 10^9:
        echo "large";return
    echo A
  return

main()
