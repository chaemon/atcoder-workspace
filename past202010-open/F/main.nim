include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let N, K = nextInt()
  ct := initTable[string, int]()
  for i in 0..<N:
    let S = nextString()
    if S notin ct: ct[S] = 0
    ct[S].inc
  rct := initTable[int, seq[string]]()
  for s, c in ct:
    if c notin rct: rct[c] = Seq[string]
    rct[c].add(s)
  var v = Seq[(int, seq[string])]
  for k, val in rct:
    v.add((k, val))
  v.sort(SortOrder.Descending)
  var s = 0
  for (k, v) in v:
    let s2 = s + v.len
    if s2 >= K:
      if v.len != 1:
        echo "AMBIGUOUS"
      else:
        echo v[0]
      break
    s = s2

