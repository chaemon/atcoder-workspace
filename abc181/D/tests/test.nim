discard """
  cmd:      "nim cpp -r --styleCheck:hint $options $file"
  target:  "cpp"
  nimout:   ""
  action:   "run"
  exitcode: 0
  timeout:  60.0
"""

proc hello(n:int):int = n + 4

doAssert hello(1) == 5

block HOGE:
  doAssert hello(3) == 7
block HOGE2:
  doAssert hello(3) == 7
#discard """
#  errormsg: "undeclared identifier: 'not_defined'"
#"""
#assert not_defined == "not_defined", "not_defined is not defined"
