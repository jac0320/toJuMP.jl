# toJuMP.jl

Dev: [![Build Status](https://travis-ci.org/jac0320/toJuMP.jl.svg?branch=master)](https://travis-ci.org/jac0320/toJuMP.jl)
[![codecov](https://codecov.io/gh/jac0320/toJuMP.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jac0320/toJuMP.jl)


This is a small tool that converts scalar optimization model with different formats into a [JuMP model](https://github.com/JuliaOpt/JuMP.jl) script (`.jl`). The scalar model is unlike a modeling script that carries the model information with sets, looped-constraints, and complex index variables. You will find this tools useful when benchmarking your algorithm using established instance libraries. Please see some of the converted MINLP instances in [MINLPLibJuMP.jl](https://github.com/lanl-ansi/MINLPLibJuMP.jl).

# Installation
This is a developing repo as more formats and exceptions are considered. The mission is to provide
correct and flexible conversion to `JuliaOpt` users.
```
Pkg.clone("https://github.com/jac0320/toJuMP.jl.git")
```

# Usage

### `.gms` --> `.jl`
```
gms2jump("*.gms")
```


### `.mod` --> `.jl`
```
mod2jump("*.mod")
```

### `.nl` --> `.jl` (upcoming)

### Conversion options

The default output path is `Pkg.dir()/toJuMP/.jls/`. Multiple options are provided for conversions. The default output path is `Pkg.dir()/toJuMP/.jls/`.For example,

```
  gms2jump("*.gms", mode="index", ending="m=m", quadNL=true, outdir="", loopifpossible=true)
```

* `mode` : (`"raw"` or `"index"`) index method for variables. If `"raw"`, then variables will not be indexed and original script variable string (`"x15"`, `"i26"`) is defined. If `"index"`, then index will be used to construct variables such as `"x[15]"` or `"i[26]"`.

* `ending` : control of the ending line of generated scrip. By default, this is `"m=m"`, which means when you include the generated script, the JuMP model will be returned.

* `quadNL` : build quadratic model using `@NLconstraint`. By default (JuMP 0.18-), `@constraint` can handle quadratic constraints by automatically expand the expression. User can choose to keep the original expression through `@NLconstraint`, which will yields a nonlinear JuMP model type.

* `outdir` : user-defined output dir for `.jl` files. No need to give the problem name.

* `loopifpossible` : write variables attributes (bounds, warm-start values using loops if possible).

### Known Issues

* Supports for dual warm start is temporarily disabled (will consider with [JuMP](https://github.com/JuliaOpt/JuMP.jl) 0.19)

* Semi-continous variables is not supported

* Unsupported operators: `arctan`, `ceil`, `errorof`, `floor`, `mapval`, `max`, `min`, `mod`, `normal`, `round`, `sign`, `trunc`, `uniform`. These variables are disabled since they can be achieved through various modeling techniques. Currently, `toJuMP.jl` does not assume/apply these modeling techniques by default.

* Variable attributes such as `scale`, `prior`, `stage` is disabled given these are solver-dependent attributes.

### Tested Library

* [minlp](http://www.minlp.com/downloads/testlibs/gmslibs/minlp.zip)
* [minlplib2](http://www.gamsworld.org/minlp/minlplib2/html/)
* [bcp](https://link.springer.com/article/10.1007/s10898-016-0491-8)
* [global](http://www.gamsworld.org/global/globallib.htm)
* [ibm](http://egon.cheme.cmu.edu/ibm/page.htm)
* [inf](http://pubsonline.informs.org/doi/abs/10.1287/ijoc.2017.0761)
* [morg](http://www.minlp.org/)
* [mpec](http://www.gamsworld.org/mpec/mpeclib.htm)
* [mult3](https://link.springer.com/article/10.1007/s12532-014-0073-z)
* [mult4](https://link.springer.com/article/10.1007/s12532-014-0073-z)
* [poly](https://link.springer.com/article/10.1007%2Fs10898-011-9757-3?LI=true)
* [prince](http://www.gamsworld.org/performance/princetonlib/princetonlib.htm))
* [qcqp](https://link.springer.com/article/10.1007%2Fs10107-011-0462-2?LI=true)
* [qcqp2](https://link.springer.com/article/10.1007%2Fs10107-011-0462-2?LI=true)
* [qcqp3](https://link.springer.com/article/10.1007%2Fs10107-011-0462-2?LI=true)
