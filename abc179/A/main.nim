include atcoder/extra/header/chaemon_header

var S:string

# input part {{{
proc main()
block:
  S = nextString()
#}}}

proc main() =
  if S[^1] == 's':
    echo S & "es"
  else:
    echo S & "s"
  return

main()

