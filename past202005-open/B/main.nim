import atcoder/extra/header/chaemon_header

proc main() =
  let N, M, Q = nextInt()
  solved := Seq(N, M, false)
  ct := Seq(M, 0)
  for i in 0..<Q:
    let q = nextInt()
    if q == 1:
      let n = nextInt() - 1
      var s = 0
      for i in 0..<M:
        if solved[n][i]:
          s += N - ct[i]
      echo s
    else:
      let n, m = nextInt() - 1
      solved[n][m] = true
      ct[m].inc
  return

main()
