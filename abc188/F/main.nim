include atcoder/extra/header/chaemon_header


proc solve(X:int, Y:int) =
  var mp = initTable[int,int]()
  proc dfs(x:int):int =
    if x in mp: return mp[x]
    result = abs(x - X)
    if x <= X: return
    if x mod 2 == 0:
      result.min=dfs(x div 2) + 1
    else:
      if x - 1 > 0:
        result.min=dfs((x - 1) div 2) + 2
      result.min=dfs((x + 1) div 2) + 2
    mp[x] = result
  echo dfs(Y)
  return

# input part {{{
block:
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
#}}}
