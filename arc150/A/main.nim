when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve(N, K: int, S:string):
  if S.find('1') != -1:
    l := 0
    r := N - 1
    while S[l] != '1': l.inc
    while S[r] != '1': r.dec
    # 1の間に0があったらだめ
    if S[l .. r].find('0') != -1:
      echo NO;return
    # 1の長さがKを超えたらだめ
    if r - l + 1 > K:
      echo NO;return
    elif r - l + 1 == K:
      echo YES;return
    # 1の間を埋める
    l0 := l - 1
    r0 := r + 1
    while l0 >= 0 and S[l0] == '?': l0.dec
    while r0 < N and S[r0] == '?': r0.inc
    # l0 + 1 .. r0 - 1が区間
    if (r0 - 1) - (l0 + 1) + 1 < K:
      echo NO
    elif l == l0 + 1 or r == r0 - 1:
      echo YES
    elif (r0 - 1) - (l0 + 1) + 1 == K:
      echo YES
    else:
      echo NO
  else:
    # 0と?しかない
    # 0の間の?を埋める
    var v = @[-1]
    for i in N:
      if S[i] == '0': v.add i
    v.add N
    found := false
    for i in v.len - 1:
      let l = v[i + 1] - v[i] - 1
      if l > K: echo NO;return
      elif l == K:
        if found: echo NO;return
        found = true
    if found: echo YES
    else: echo NO
  Naive:
    ct := 0
    for i in 0 .. N - K:
      var T = '0'.repeat(N)
      for j in K:
        T[i + j] = '1'
      ok := true
      for j in N:
        if S[j] != '?':
          if T[j] != S[j]:
            ok = false
      if ok: ct.inc
#      debug T, ok
    echo if ct == 1: YES else: NO
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let N, K = nextInt()
    let S = nextString()
    solve(N, K, S)
else:
  var s = ['0', '1', '?']
  let N = 4
  for a in 0 .. 2:
    for b in 0 .. 2:
      for c in 0 .. 2:
        for d in 0 .. 2:
          let S = s[a] & s[b] & s[c] & s[d]
          for K in 1 ..< N:
            test(N, K, S)
  discard
