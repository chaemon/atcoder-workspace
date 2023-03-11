include atcoder/extra/header/chaemon_header

var A:int
var B:int

# input part {{{
block:
  A = nextInt()
  B = nextInt()
#}}}

block main:
  # write code here
  echo (A + B) div 2, " ", (A - B) div 2
  break
