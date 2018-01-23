# toJuMP.jl

Dev: [![Build Status](https://travis-ci.org/jac0320/toJuMP.jl.svg?branch=master)](https://travis-ci.org/jac0320/toJuMP.jl)
[![codecov](https://codecov.io/gh/jac0320/toJuMP.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jac0320/toJuMP.jl)

This is a small tool that converts different optimization format into a JuMP model script.
You will find these tools useful as you are benchmarking using some instance library.

## Installation
```
Pkg.clone("https://github.com/jac0320/toJuMP.jl.git")
```

## Usage: .gms to .jl

To convert a *.gms file into a JuMP model script:
```
gms2jump("*.gms")
```
Find you scrip in `Pkg.dir()/toJuMP/.jls/`.

Currently, level/primal value and marginal/dual value will be ingored during the conversion.
Also, semi-continous variable is not supported at the moment.

## .mod to .jl (upcoming)

## Tested Library
* [minlp](http://www.minlp.com/downloads/testlibs/gmslibs/minlp.zip)
