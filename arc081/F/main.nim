#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

proc histogram(a:seq[int]):int = 
  var
    s = newSeq[(int,int)]()
  result = 0
  for i in 0..a.len:
    var
      h = 0
      head = i
    if i < a.len:
      h = a[i]
    while s.len > 0:
      var (j, hj) = s[s.len-1]
      if hj >= h:
        result.max= hj * (i - j + 1)
        head = j
        discard s.pop()
      else:
        break
    s.add((head,h))
  return result

proc main():void =
  var
    H = nextInt()
    W = nextInt()
    S = newSeqWith(H,nextString())
    ans = max(H,W)
    same = newSeqWith(H,newSeq[int](W))
    diff = newSeqWith(H,newSeq[int](W))
  for j in 0..W-2:
    var
      s = 0
      d = 0
    for i in countdown(H-1,0):
      if S[i][j]==S[i][j+1]:
        d += 1;s = 0
      else:
        s += 1;d = 0
      same[i][j] = s
      diff[i][j] = d
  for i in 0..H-2:
    var a = newSeq[int](0)
    for j in 0..W-2:
      if S[i][j]==S[i][j+1]:
        a.add(diff[i+1][j] + 1)
      else:
        a.add(same[i+1][j] + 1)
    ans.max=histogram(a)
  echo ans

main()

