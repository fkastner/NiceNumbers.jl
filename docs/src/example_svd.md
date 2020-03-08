# Example: SVD
*Building an SVD exercise*

In this example we want to see how we can use `NiceNumber`s to construct an exercise for a
singular value decomposition.

## The Math
For a given matrix ``A\in\mathbb{R}^{m\times n}``, ``m\geq n``, we try to find a decomposition of the form
```math
A = U(\Sigma 0)^\top V^\top
```
where `U` and `V` are orthogonal (or unitary) square matrices.

## Using NiceNumbers to build the exercise
Load the relevant packages:
```jldoctest SVD
julia> using NiceNumbers, LinearAlgebra
```

Decide on an orthogonal basis in ``\mathbb{R}^m`` (here ``m=3``)
```jldoctest SVD
julia> u1 = NiceNumber.([3,12,4])
3-element Array{NiceNumber,1}:
  3//1
 12//1
  4//1
julia> u2 = NiceNumber.([-4,0,3])
3-element Array{NiceNumber,1}:
 -4//1
  0//1
  3//1
julia> u3 = cross(u1,u2)
3-element Array{NiceNumber,1}:
  36//1
 -25//1
  48//1
```
and take note of their norms
```jldoctest SVD
julia> n1 = Int(norm(u1))
13
julia> n2 = Int(norm(u2))
5
julia> n3 = Int(norm(u3))
65
julia> n3 == n1*n2
true

```

```jldoctest SVD
julia> U = 1//n3 * [u1*n2 u2*n1 u3]
3×3 Array{NiceNumber,2}:
  3//13  -4//5  36//65
 12//13   0//1  -5//13
  4//13   3//5  48//65
julia> V = 1//5* NiceNumber.([-3 4;4 3])
2×2 Array{NiceNumber,2}:
 -3//5  4//5
  4//5  3//5

julia> Σ = diagm(NiceNumber.([13,5]))
2×2 Array{NiceNumber,2}:
 13//1  0//1
  0//1  5//1
julia> S = [Σ;0 0]
3×2 Array{NiceNumber,2}:
 13//1  0//1
  0//1  5//1
  0//1  0//1
julia> R = pinv(S)
2×3 Array{NiceNumber,2}:
 1//13  0//1  0//1
  0//1  1//5  0//1

julia> A = U*S*V'
3×2 Array{NiceNumber,2}:
  -5//1   0//1
 -36//5  48//5
   0//1   5//1
julia> A⁺ = V*R*U'
2×3 Array{NiceNumber,2}:
 -2929//21125  -36//845  1728//21125
 -1728//21125   48//845  1921//21125
```
