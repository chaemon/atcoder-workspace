#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

let YES = "Yes"
let NO = "No"

proc solve(S:string) =
  var valid = true
  for i in 0..<S.len:
    if i mod 2 == 0 and S[i] == 'L':
      valid = false
#      stderr.write("No: ",i)
    if i mod 2 == 1 and S[i] == 'R':
      valid = false
#      stderr.write("No: ",i)
  echo if valid: "Yes" else: "No"
  return

#{{{ main function
proc main() =
  var S = ""
  S = nextString()
  solve(S);
  return

main()
#}}}
