when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(T_x:int, T_y:int, V_T:int, A_x:int, A_y:int, V_A:int):
  if V_T > V_A: # T君の方が早ければ無限に遠いところでは必ず勝てる
    echo "inf"
  elif V_T < V_A: # V_T : V_Aに内分と外分する点を探す
    let
      m = float(V_T)
      n = float(V_A)
      P_x = (float(T_x) * n + float(A_x) * m) / (m + n)
      P_y = (float(T_y) * n + float(A_y) * m) / (m + n)
      Q_x = (float(T_x) * n - float(A_x) * m) / (-m + n)
      Q_y = (float(T_y) * n - float(A_y) * m) / (-m + n)
    let
      O_x = (P_x + Q_x) * 0.5
      O_y = (P_y + Q_y) * 0.5
      r = sqrt((P_x - O_x)^2 + (P_y - O_y)^2)
      d = abs(O_x)
    # O(O_x, O_y)とx=0の距離
    if d > r:
      echo 0
    else:
      echo 2.0 * sqrt(r^2 - d^2)
  else:
    if T_y != A_y:
      echo "inf"
    else:
      if abs(T_x) <= abs(A_x):
        echo "inf"
      else:
        echo 0
  discard

when not defined(DO_TEST):
  var T_x = nextInt()
  var T_y = nextInt()
  var V_T = nextInt()
  var A_x = nextInt()
  var A_y = nextInt()
  var V_A = nextInt()
  solve(T_x, T_y, V_T, A_x, A_y, V_A)
else:
  discard

