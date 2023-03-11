include atcoder/extra/header/chaemon_header


proc solve(N:int, s:string) =
  var st = newSeq[char]()
  var ans = 0
  for s in s:
    if s in "fox":
      st.add s
      while true:
        if st.len >= 3 and st[^3..^1] == "fox":
          for i in 0..<3:
            discard st.pop()
        else: break
    else:
      ans.inc
      ans += st.len
      st = newSeq[char]()
  ans += st.len
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var s = nextString()
  solve(N, s)
#}}}
