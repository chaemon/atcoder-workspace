include atcoder/extra/header/chaemon_header

proc `<`(a, b:seq[int]):bool =
  for i in a.len:
    if a[i] != b[i]: return a[i] < b[i]
  return true


const DEBUG = true

proc solve(B:int, C:int) =
  v := newSeq[seq[int]]()
  #00
  block sub:
    let t = C div 2
    v.add(sorted(@[B - t, B]))
  #10
  block sub:
    if C - 1 < 0: break sub
    let t = (C - 1) div 2
    v.add(sorted(@[-B - t, -B]))
  #01
  block sub:
    if C - 1 < 0: break sub
    let t = (C - 1) div 2
    v.add(sorted(@[-B, -(B - t)]))
  #11
  block sub:
    if C - 2 < 0: break sub
    let t = (C - 2) div 2
    v.add(sorted(@[B, -(-B - t)]))
  v.sort()
  ans := 0
  prev := -int.inf
  for p in v:
    l := p[0]
    r := p[1]
    if prev < l:
      prev = l
      prev = r
      ans += r - l + 1
    elif prev <= r:
      ans += r - prev 
      prev = r
    else:
      discard
  echo ans

  return

# input part {{{
block:
  var B = nextInt()
  var C = nextInt()
  solve(B, C)
#}}}
