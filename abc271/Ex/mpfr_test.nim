#[
  mpfr wrapper (GNU MPFR 4.1.0)
  https://www.mpfr.org
]#

import lib/other/decimal_mpfr

set_precision(100)

block:
  var zero = newMpfr("0")
  var one = newMpfr("1")
  var p = pi()
  echo cos(p).toStr(100)


#when isMainModule:
#  proc test_mpfr =
#    echo "testing mpfr"
#
#    var
#      x1 = newMpfr(123.0)
#      x2 = newMpfr("345.67e3456")
#      xx1 = newMpfr(x1)
#
#    echo "x1=", x1, ", x2=", x2
#    x1 = "123.456"
#    let x11 = x1+x2
#    echo x11
#    var x3 = newMpfr()
#
#    let xxx4 = x1+x2.cos.tan
#    echo xxx4
#    for i in 0..10000: x3 = x1.sin.cos.tan
#
#    echo "x3=", $x3, ", x1=", $x1
#    echo x1+x3-x2*x1/x3
#
#    var
#      x4 = x1*x1
#      x5 = x1*x1*x1*x1
#
#    echo x1, ",", x4.sqrt, ",", x5.root(4)
#
#    # factorials
#    for i in 0..4000000:
#      if i %% 500000 == 0:
#        echo i, "! = ", !i.uint
#
#    x1 = 1
#    var i = 0
#
#    while x1 > "1e-45000":
#      i.inc
#      x1 /= 1.2e90
#      if i %% 100 == 0: echo i, ":", x1
#
#  import times, complex, sugar
#  import sequtils
#  proc test_cmpfr =
#
#    var
#      c0 = newCmpfr(1, 0)
#      z = newCmpfr(c0)
#      zv = newSeq[cmpfr](100)
#
#    # init all items in vect, notice that z=c0 will not work
#    for z in zv.mitems: z = newCmpfr(c0)
#
#    
#    let zzv = newSeqWith(101, newCmpfr(z))
#    for zz in zzv: z+=zz
#    echo "z=", z
#    z = c0
#
#    c0+=123.67
#    let n = 500
#    echo "generating mpfr ", n*n, " iters, @", mpfr_precision, " bit precision"
#
#    var t0 = now()
#    for i in 0..n*n: # simulate mandelbrot fractal generation
#      z = c0
#      for it in 0..200:
#        z = z*z+c0
#        if z.abs > 4.0: break
#    echo z
#    echo "lap mpfr:", (now()-t0).inMilliseconds, "ms"
#
#    var
#      dz = complex64(1, 0)
#      dc0 = dz
#
#    dc0 += complex64(123.67, 123.67)
#
#    t0 = now()
#    for i in 0..n*n:
#      dz = dc0
#      for it in 0..200:
#        dz = dz*dz+dc0
#        if dz.abs > 4.0: break
#    echo dz
#    echo "lap complex 64:", (now()-t0).inMilliseconds, "ms"
#
#  proc test_cmpfr_init =
#    var z, z0: cmpfr # not init
#
#    for i in 0..100000: z = z0 # ok, but does nothing
#    z = z0 # same
#
#    echo z, z0 # not init
#
#    for i in 0..100000: z0 = newCmpfr(1.0, 2.0)
#    z0 = newCmpfr(1.0, 2.0)
#    for i in 0..1000: z = z0.sin.cos.tan.acos.asin.asinh
#    for i in 0..100000: z+=z0+z0
#    echo z, z0
#
#
#  proc test_mpfr_init =
#    var
#      x0 = newMpfr(0.0)
#      x = newMpfr(1.0)
#      xx, xx0, xx1: mpfr
#
#    x0 = x # both init: ok
#    xx = xx0 # xx0 not init: ok, but do nothing
#    xx = x # xx not init: ok
#
#    echo "x=", x, ", x0=", x0, ", xx=", xx
#
#    xx = xx0
#    echo xx
#
#    for i in 0..100: xx = x0
#    xx = x0
#
#    echo xx, xx0, xx1
#
#    echo "pi=", pi(), ", e=", e(), ", catalan=", catalan(), ", log2=", log2()
#
#    echo "end"
#
#  import strutils
#  proc test_custom =
#  
#    echo "need ", mpfr_custom_get_size(mpfr_precision), " bytes, for a ",
#        mpfr_precision, " bit precision"
#    var x, y, z: mpfr
#  
#    echo "before init, x is init:", x.is_init
#  
#    cinit(x)
#    cinit(y)
#  
#    echo "after cust init x is init:", x.is_init
#    x := pi()*200.0 # set not =copy
#    y := 678.89
#  
#    x+=y
#    z = x # z is not custom so it can be assigned
#  
#    echo "z=", z, ", z==x:", z == x
#    echo "x=", x, ", y=", y, ", kind=", mpfr_custom_get_kind(x), ", pointer=",
#        cast[uint](mpfr_custom_get_significand(x)).toHex
#  
#    cfree(x)
#    cfree(y)
#  
#  echo "-------------------- mpfr test"
#  test_custom()
#  test_mpfr()
#  test_mpfr_init()
#  test_cmpfr()
#  test_cmpfr_init()
#  
#  echo "-------------------- ok"
#
