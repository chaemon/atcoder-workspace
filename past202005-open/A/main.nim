include atcoder/extra/header/chaemon_header

var s:string
var t:string

#{{{ input part
proc main()
block:
  s = nextString()
  t = nextString()
#}}}

proc main() =
  if s == t:
    echo "same";return
  if s.toLower == t.toLower:
    echo "case-insensitive";return
  echo "different"
  return

main()
