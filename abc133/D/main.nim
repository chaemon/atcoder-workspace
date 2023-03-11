import sequtils, tables
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

let N = nextInt()
let A = newSeqWith(N,nextInt())

var s = 0
for i in 0..N-1:
  s += A[i]
s = s div 2

var t = 0

for i in countup(1,N-1,2):
  t += A[i]

var x = s - t

for i in 0..N-1:
  stdout.write x*2," "
  x = A[i] - x
echo ""
