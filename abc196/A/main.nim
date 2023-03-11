include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(a:int, b:int, c:int, d:int) =
  var ans = -int.inf
  for x in a..b:
    for y in c..d:
      ans.max= x - y
  echo ans
  return

# input part {{{
block:
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  solve(a, b, c, d)
#}}}

