include atcoder/extra/header/chaemon_header


const DEBUG = true


let T = nextInt()
for _ in T:
  let N = nextInt()
  if N mod 4 == 0:
    echo "Even"
  elif N mod 2 == 0:
    echo "Same"
  else:
    echo "Odd"

