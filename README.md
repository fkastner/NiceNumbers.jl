# NiceNumbers.jl
*The nicest numbers in Julia*

[![Build Status](https://travis-ci.org/fkastner/NiceNumbers.jl.svg?branch=master)](https://travis-ci.org/fkastner/NiceNumbers.jl)
[![Coverage Status](https://coveralls.io/repos/github/fkastner/NiceNumbers.jl/badge.svg?branch=master)](https://coveralls.io/github/fkastner/NiceNumbers.jl?branch=master)
[![Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://fkastner.github.io/NiceNumbers.jl/dev)


This package implements a number type to represent numbers you can safely give to
your students to work with.

The goal is that when common linear algebra or numerical algorithms work using `NiceNumber`s
that then one can be sure that the algorithm can be reasonably easy worked through by hand
with the given numbers.

Nice numbers as implemented in this package consist of a rational part and a square root part with
a rational coefficient. Thus every `NiceNumber` is specified using two `Rational{Int}`s and one `Int`.

## Installation

Since this package isn't registered yet, you have to use the GitHub URL of the repository:
```julia
(v1.3) pkg> add https://github.com/fkastner/NiceNumbers.jl
```

## Usage Example

```julia
julia> using NiceNumbers

julia> n = NiceNumber(2,3,5);
Nice number:
   2 + 3 ⋅ √5

julia> n^2
Nice number:
   49 + 12 ⋅ √5

julia> m = NiceNumber(3//5)
Nice number:
   3//5

julia> n+m, n-m, n*m, n/m
(13//5 + 3 ⋅ √5, 7//5 + 3 ⋅ √5, 6//5 + 9//5 ⋅ √5, 10//3 + 5 ⋅ √5)

julia> sqrt(m)
Nice number:
   1//5 ⋅ √15

julia> sqrt(n)
ERROR: That's not nice anymore!
[...]
```

There is also a macro to simplify working with nice numbers:
```julia
julia> using LinearAlgebra

julia> n = norm([4,12,3] * √2)
18.38477631085024

julia> @nice m = norm([4,12,3] * √2)
Nice number:
   13 ⋅ √2

julia> n == m
true
```

For further examples see the examples section of the documentation,
especially the [SVD example](https://fkastner.github.io/NiceNumbers.jl/dev/example_svd/).