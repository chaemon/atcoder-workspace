const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header


const YES = "Yes"
const NO = "No"

# Failed to predict input format
block main:
  let N = nextInt()
  var S, T = Seq[string]
  for _ in N:
    S.add nextString()
    T.add nextString()
  for i in N:
    for j in i + 1 ..< N:
      if S[i] == S[j] and T[i] == T[j]:
        echo YES;break main
  echo NO
  discard

