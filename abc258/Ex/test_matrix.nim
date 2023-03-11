#import lib/math/matrix

import std/sequtils, std/algorithm

type StaticMatrix*[T; p:static[tuple]] = object
  data*:array[2, array[2, T]]

type StaticMatrixObj*[T; p:static[tuple]] = object
#type StaticMatrixObj*[T; p:static[string]] = object
type StaticVector*[T:not array; N:static[int]] = array[N, T]

type SomeVector* = StaticVector


template height*[M:StaticMatrix](self: M):int = 2 #M.N
template width*[M:StaticMatrix](self: M):int = 2 #M.M
proc getZero*[M:StaticMatrix | StaticMatrixObj](self:typedesc[M] or M):auto =
  block:
    M.p.zero()
proc getUnit*[M:StaticMatrix | StaticMatrixObj](self:typedesc[M] or M):auto =
  block:
    M.p.unit()

proc `[]`*[M:StaticMatrix](self:M, i, j:int):M.T = self.data[i][j]
proc `[]=`*[M:StaticMatrix](self:var M, i, j:int, a:M.T) = self.data[i][j] = a


proc init*[M:StaticMatrixObj | StaticMatrix](self:typedesc[M] or M, n, m:static[int]):auto =
  #var A: StaticMatrix[M.T, n, m, M.p]
  const zero = M.p.zero
  const unit = M.p.unit
  var A: StaticMatrix[M.T, (zero:zero, unit:unit)]
  for i in 0 ..< n:
    for j in 0 ..< m:
      A[i, j] = A.getZero()
  return A
proc init*[M:StaticMatrixObj | StaticMatrix](self:typedesc[M] or M, n:static[int]):auto = M.init(n, n)

template StaticMatrixType*(T:typedesc, zero0:untyped):auto =
  StaticMatrixObj[T, (zero:(proc():T = T(0)), unit:(proc():T = T(1)))]
  #StaticMatrixObj[T, "hogehoge"]

proc init*[M:StaticMatrixObj | StaticMatrix; n:static[int], S](self:M or typedesc[M], a:array[n, S]):auto =
  return M.initVector(a)
proc init*[M:StaticMatrixObj | StaticMatrix; n, m:static[int], S](self:M or typedesc[M], a:array[n, array[m, S]]):auto =
  const h = a.len
  const w = a[0].len
  result = M.init(h, w)
  for i in 0..<result.height:
    for j in 0..<result.width:
      result[i, j] = M.T(a[i][j])

proc hoge*[M:StaticMatrix](self: typedesc[M], n:static[int]) =
  echo "hoge!!"
  echo M.getZero()
  echo M.getUnit()

proc unit*[M:StaticMatrix](self: typedesc[M], n:static[int]):M =
  result = M.init(n)
  for i in 0..<n:
    result[i, i] = M.getUnit()
proc unit*[M:StaticMatrix](self: M, n:static[int] = -1):M =
  when n == -1:
    M.unit(self.height)
  else:
    M.unit(n)

type M = StaticMatrixType(int, int)


block:
  var A = M.init(2, 2)
  #A.type.hoge(2)
  echo A
  echo A.unit
block:
  var A = M.init([[1, 2], [3, 4]])
  #A.type.hoge(3)
  echo A.getZero()
  echo A
  echo A.unit
