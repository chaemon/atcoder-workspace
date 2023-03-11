import sequtils, tables

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

var
  L = nextInt()
  R = nextInt()

if R - L + 1 >= 2019:
  echo 0
else:
  var m = 2019
  for i in L..R:
    for j in i+1..R:
      m = min(i*j mod 2019,m)
  echo m
