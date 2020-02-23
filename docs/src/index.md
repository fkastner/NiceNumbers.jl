# NiceNumbers.jl
*The nicest numbers in Julia*

This package implements a number type to represent numbers you can safely give to
your students to work with.

## Installation

Since this package isn't registered yet, you have to use the GitHub URL of the repository:
```
(v1.3) pkg> add https://github.com/fkastner/NiceNumbers.jl
```

## Usage Example

```
julia> using NiceNumbers

julia> n = NiceNumber(1,2,3);
Nice number:
   1//1 + 2//1 ⋅ √3
```
