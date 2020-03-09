# NiceNumbers.jl
*The nicest numbers in Julia*

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

```jldoctest index
julia> using NiceNumbers

julia> n = NiceNumber(2,3,5)
Nice number:
   2//1 + 3//1 ⋅ √5

julia> n^2
Nice number:
   49//1 + 12//1 ⋅ √5

julia> m = NiceNumber(3//5)
Nice number:
   3//5

julia> n+m, n-m, n*m, n/m
(13//5 + 3//1 ⋅ √5, 7//5 + 3//1 ⋅ √5, 6//5 + 9//5 ⋅ √5, 10//3 + 5//1 ⋅ √5)

julia> sqrt(m)
Nice number:
   0//1 + 1//5 ⋅ √15

julia> sqrt(n)
ERROR: That's not nice anymore!
[...]
```

For further examples see the examples section of the documentation,
especially the [Example: SVD](@ref).
