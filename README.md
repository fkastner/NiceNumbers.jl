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
```jldoctest readme
(v1.3) pkg> add https://github.com/fkastner/NiceNumbers.jl
```

## Usage Example

```jldoctest readme
julia> using NiceNumbers

julia> n = NiceNumber(1,2,3);
Nice number:
   1//1 + 2//1 ⋅ √3
```
