import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

var
  s = readLine(stdin)
  N = false
  E = false
  W = false
  S = false

for a in s:
  case a:
    of 'N':
      N = true
    of 'E':
      E = true
    of 'W':
      W = true
    of 'S':
      S = true
    else:
      discard

if (N and not S) or (S and not N):
  echo "No"
elif (E and not W) or (W and not E):
  echo "No"
else:
  echo "Yes"
