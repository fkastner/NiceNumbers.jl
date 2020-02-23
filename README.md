# NiceNumbers.jl
*The nicest numbers in Julia*

[![Build Status](https://travis-ci.org/fkastner/NiceNumbers.jl.svg?branch=master)](https://travis-ci.org/fkastner/NiceNumbers.jl)
[![Coverage Status](https://coveralls.io/repos/github/fkastner/NiceNumbers.jl/badge.svg?branch=master)](https://coveralls.io/github/fkastner/NiceNumbers.jl?branch=master)
[![Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://fkastner.github.io/NiceNumbers.jl/dev)


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
