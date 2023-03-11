#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
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

template cfor(a,b,c,body:untyped): untyped =
  block:
    a
    var first = true
    while true:
      if first: first = false
      else: c
      if not b: break
      body

proc solve(S:string) =
  var
    T = newSeq[int]()
  block:
    var i = 0
    while i < S.len:
      var j = i
      T.add(ord(S[i]) - ord('A'))
      while j < S.len and S[j] == S[i]: j += 1
      i = j
  var ct = [(0,0),(0,1),(0,2)]
  for t in T: ct[t][0] += 1
  ct.sort()
  for t in T.mitems:
    if t == ct[0][1]: t = 0
    elif t == ct[1][1]: t = 1
    elif t == ct[2][1]: t = 2
    else: assert(false)
  echo T
  let N = ct[0][0]
  var
    start = newSeqWith(N+1,-1)
    reps = newSeqWith(N+1,0)
    rem = newSeqWith(N+1,false)
    a = newSeq[int]()
  block:
    var
      i = 0
      j = 0
    while i <= T.len:
      if i == T.len or T[i] == 0:
        if a.len > 0:
          start[j] = a[0]
          reps[j] = a.len div 2
          rem[j] = if a.len mod 2 == 1: true else: false
        else:
          start[j] = -1
          reps[j] = 0
          rem[j] = false
        j += 1
        a = newSeq[int]()
      else:
        a.add(T[i])
      i += 1
  var
    one = N
    two = N
    ans = newSeq[int]()
  debug(N)
  for i in 0..N:
    var t = min(min(one,two),reps[i])
    one -= t
    two -= t
    for i in 0..<t: ans.add(start[i]);ans.add(3 - start[i])
    if one > 0 and start[i] == 1 and rem[i]:ans.add(1);one-=1
    if two > 0 and start[i] == 2 and rem[i]:ans.add(2);two-=1
    if i < N: ans.add(0)
    debug(i,t,start[i],ans)
  assert(one == 0 and two == 0)
  for i in 0..<ans.len:
    stdout.write(chr(ct[ans[i]][1]))
  echo("")
  return

#{{{ main function
proc main() =
  var S = ""
  S = nextString()
  solve(S);
  return

main()
#}}}
