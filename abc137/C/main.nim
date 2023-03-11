import sequtils,tables
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


proc solve(N:int, s:seq[string]):void =
  proc get(s:string):seq[int] =
    result = newSeqWith(26,0)
    for i in 0..<s.len:
      result[ord(s[i]) - ord('a')] += 1
  var t = newTable[seq[int],int]()
  for i in 0..<N:
    let v = get(s[i])
    if not (v in t): t[v] = 0
    t[v] += 1
  var ans = 0
  for k,v in t:
    ans += v * (v - 1) div 2
  echo ans
  discard

proc main():void =
  var N = 0
  N = nextInt()
  var s = newSeqWith(N, "")
  for i in 0..<N:
    s[i] = nextString()
  solve(N, s);
  return

main()
