include src/nim_acl/extra/header/chaemon_header

var x:int

# input part {{{
proc main()
block:
  x = nextInt()
#}}}

proc main() =
  print 1 - x
  return

main()

