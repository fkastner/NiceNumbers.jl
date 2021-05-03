# Example: SVD
*Building an SVD exercise*

In this example we want to see how we can use `NiceNumber`s to construct an exercise for a
singular value decomposition.

## The Math
For a given matrix ``A\in\mathbb{R}^{m\times n}``, ``m\geq n``, we try to find a decomposition of the form
```math
A = U(\Sigma, 0)^\top V^\top
```
where ``U`` and ``V`` are orthogonal (or unitary) square matrices and ``\Sigma`` is a diagonal matrix
with the singular values of ``A`` on the diagonal.

## Using NiceNumbers to build the exercise
To construct a workable exercise we start from the decomposition and construct ``A``.
First we need to load the relevant packages:
```jldoctest SVD
julia> using NiceNumbers, LinearAlgebra
```

Decide on an orthogonal basis in ``\mathbb{R}^m`` (here ``m=3``)
```jldoctest SVD
julia> u1 = NiceNumber[3,12,4]
3-element Vector{NiceNumber}:
  3
 12
  4

julia> u2 = NiceNumber[-4,0,3]
3-element Vector{NiceNumber}:
 -4
  0
  3

julia> u3 = cross(u1,u2)
3-element Vector{NiceNumber}:
  36
 -25
  48
```
and take note of their norms
```jldoctest SVD
julia> n1 = norm(u1)
Nice number:
   13

julia> n2 = norm(u2)
Nice number:
   5

julia> n3 = norm(u3)
Nice number:
   65

julia> n3 == n1*n2
true
```
to construct ``U``:
```jldoctest SVD
julia> U = 1/n3 * [u1*n2 u2*n1 u3]
3×3 Matrix{NiceNumber}:
  3//13  -4//5  36//65
 12//13      0  -5//13
  4//13   3//5  48//65
```
The same procedure can in principle be used to construct a second unitary matrix in
``\mathbb{R}^{n\times n}`` (here ``n=2``):
```jldoctest SVD
julia> V = 1//5* NiceNumber[-3 4;4 3]
2×2 Matrix{NiceNumber}:
 -3//5  4//5
  4//5  3//5
```

Now we fix the singular values and construct some auxiliary matrices:
```jldoctest SVD
julia> Σ = diagm(NiceNumber[13,5])
2×2 Matrix{NiceNumber}:
 13  0
  0  5

julia> S = [Σ;0 0]
3×2 Matrix{NiceNumber}:
 13  0
  0  5
  0  0

julia> R = pinv(S)
2×3 Matrix{NiceNumber}:
 1//13     0  0
     0  1//5  0
```
And we're ready to construct our matrix ``A`` and it's pseudoinverse ``A^\dagger``:
```jldoctest SVD
julia> A = U*S*V'
3×2 Matrix{NiceNumber}:
     -5      0
 -36//5  48//5
      0      5

julia> A⁺ = V*R*U'
2×3 Matrix{NiceNumber}:
 -2929//21125  -36//845  1728//21125
 -1728//21125   48//845  1921//21125

julia> float(A⁺) ≈ pinv(float(A))
true
```
