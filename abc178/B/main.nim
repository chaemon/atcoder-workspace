include src/nim_acl/extra/header/chaemon_header

var a:int
var b:int
var c:int
var d:int

# input part {{{
proc main()
block:
  a = nextInt()
  b = nextInt()
  c = nextInt()
  d = nextInt()
#}}}

proc main() =
  print max([a * c, b * c, a * d, b * d])
  return

main()

