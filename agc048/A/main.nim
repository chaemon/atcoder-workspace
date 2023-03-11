include atcoder/extra/header/chaemon_header

const t = "atcoder"

proc solve() =
  let T = nextInt()
  for _ in 0..<T:
    let S = nextString()
    var ans = int.inf
    var flag = true
    for i in 0..<S.len:
      if S[i] != 'a': flag = false
    if flag:
      echo -1;continue
    for l in 0..t.len:
      var psum = 0
      var valid = true
      var S2 = S
      for i in 0..<l:
        var found = false
        for j in i..<S2.len:
          if t[i] == S2[j]:
            S2 = S2[0..<i] & S2[j] & S2[i..<j] & S2[j+1..^1]
            psum += j - i
            found = true
            break
        if not found: valid = false;break
      if not valid: continue # for l
      if l < t.len:
        var found = false
        for j in l..<S2.len:
          if t[l].ord < S2[j].ord:
            S2 = S2[0..<l] & S2[j] & S2[l..<j] & S2[j+1..^1]
            psum += j - l
            found = true
            break
        if not found: valid = false
      else:
        if S.len == t.len: valid = false
      if not valid: continue # for l
#      assert psum mod 2 == 0
#      stderr.write l, " ", psum, "\n"
      ans.min=psum
#    stderr.write "\n"
    if ans == int.inf: echo -1
    else: echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
