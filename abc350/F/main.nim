when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
#include lib/header/header

import std/strutils, std/unicode

type ST = ref object
  child:seq[ST]
  c:char

solveProc solve(S:string):
  var
    root = new(ST)
    i = 0
  root.c = '\0'
  proc dfs(i:var int, h:int): ST =
    result = new(ST)
    result.c = '\0'
    if S[i] == '(':
      i.inc
      while S[i] != ')':
        result.child.add(dfs(i, h + 1))
      doAssert S[i] == ')'
      i.inc
    else:
      result.c = S[i]
      if h mod 2 == 0:
        if result.c in 'a'..'z':
          result.c = result.c + ('A' - 'a')
        else:
          result.c = result.c + ('a' - 'A')
      i.inc
    if h mod 2 == 1:
      result.child.reverse
  while i < S.len:
    root.child.add(dfs(i, 1))
  var ans = ""
  proc dfs2(p:ST) =
    if p.c != '\0':
      ans.add p.c
    else:
      for q in p.child:
        dfs2(q)
  dfs2(root)
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

