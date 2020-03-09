module NiceNumbers

import Primes: factor, prodfactors
import Base: +, -, *, inv, /, sqrt, //
import Base: <, <=
import Base: one, zero, isinteger, isfinite
import Base: promote_rule
import LinearAlgebra: norm, norm2

export NiceNumber, nice, @nice
export isrational

struct NiceNumber <: Real
    a::Rational{Int}
    coeff::Rational{Int}
    radicand::Int
    function NiceNumber(a, coeff, radicand)
        if radicand == 0
            coeff = zero(coeff)
        elseif coeff == 0
            radicand = zero(radicand)
        else
            coeff, radicand = reduce_root(coeff, radicand)
            if radicand == 1
                a += coeff
                coeff = zero(coeff)
                radicand = zero(radicand)
            end
        end
        new(a, coeff, radicand)
    end
end
NiceNumber(a, coeff, radicand::Rational) =
    NiceNumber(a, coeff // denominator(radicand), numerator(radicand) * denominator(radicand))
NiceNumber(x::T) where {T<:Union{Integer,Rational}} = NiceNumber(x, 0, 0)
NiceNumber(x::AbstractFloat) = NiceNumber(Rational{Int}(x), 0, 0)
NiceNumber(n::NiceNumber) = n

"""
    reduce_root(coeff, radicand)

Simplifies the expression ``coeff\\cdot\\sqrt radicand`` by factoring all remaining squares
in `radicand` into `coeff`.
"""
function reduce_root(coeff::Union{Integer,Rational}, radicand::Integer)
    F = factor(radicand)
    for (k, v) in F
        if v ≥ 2
            coeff *= k^(v ÷ 2)
            F[k] = v % 2
        end
    end
    radicand = prodfactors(F)
    return coeff, radicand
end

promote_rule(::Type{NiceNumber}, ::Type{T}) where {T<:Union{Integer,Rational}} = NiceNumber
promote_rule(::Type{NiceNumber}, ::Type{T}) where {T<:AbstractFloat} =
    promote_type(Rational{Int}, T)
one(::NiceNumber) = NiceNumber(1, 0, 0)
zero(::NiceNumber) = NiceNumber(0, 0, 0)

AbstractFloat(n::NiceNumber) = float(n.a) + float(n.coeff) * √n.radicand
(::Type{T})(n::NiceNumber) where {T<:AbstractFloat} =
    convert(T, n.a) + convert(T, n.coeff) * convert(T, √n.radicand)

"""
    isrational(n::NiceNumber)

Whether `n` is purely rational, i.e. has no square root portion.
"""
isrational(n::NiceNumber) = n.coeff == 0
isinteger(n::NiceNumber) = isrational(n) && isinteger(n.a)
isfinite(n::NiceNumber) = isfinite(n.a) && isfinite(n.coeff)

function Base.show(io::IO, n::NiceNumber)
    if isrational(n)
        print(io, n.a)
    else
        print(io, n.a, " + ", n.coeff, " ⋅ √", n.radicand)
    end
end
Base.show(io::IO, ::MIME"text/plain", n::NiceNumber) = print(io, "Nice number:\n   ", n)

+(n::NiceNumber) = n
-(n::NiceNumber) = NiceNumber(-n.a, -n.coeff, n.radicand)
function +(n::NiceNumber, m::NiceNumber)
    if !(n.radicand == m.radicand || isrational(n) || isrational(m))
        error("That's not nice anymore!")
    end
    if m.radicand == 0
        return NiceNumber(n.a + m.a, n.coeff, n.radicand)
    else
        return NiceNumber(n.a + m.a, n.coeff + m.coeff, m.radicand)
    end
end
-(n::NiceNumber, m::NiceNumber) = n + (-m)

function *(n::NiceNumber, m::NiceNumber)
    return NiceNumber(m.a * n.a, m.a * n.coeff, n.radicand) +
    NiceNumber(0, m.coeff * n.a, m.radicand) +
    NiceNumber(0, n.coeff * m.coeff, n.radicand * m.radicand)
end

inv(n::NiceNumber) = NiceNumber(n.a, -n.coeff, n.radicand) * inv(n.a^2 - n.coeff^2 * n.radicand)
/(n::NiceNumber, m::NiceNumber) = n * inv(m)

sqrt(n::NiceNumber) = isrational(n) ? NiceNumber(0, 1, n.a) : error("That's not nice anymore!")

<(n::NiceNumber, m::NiceNumber) = float(n) < float(m)
<=(n::NiceNumber, m::NiceNumber) = n === m || n < m

//(n::S, m::T) where {S<:Union{NiceNumber,Integer,Rational},T<:Union{NiceNumber,Integer,Rational}} =
    n / m

norm(n::NiceNumber) = n > 0 ? n : -n
norm2(v::AbstractArray{NiceNumber,1}) = sqrt(v'v)

## macro stuff
"""
    nice(x)

If `x` is an expression it replaces all occuring numbers by `NiceNumber`s.
If `x` is a number it turns it into a `NiceNumber`.
"""
function nice(x) end
# nice(x) = x
# nice(n::Number) = NiceNumber(n)
# nice(ex::Expr) = Expr(ex.head, map(nice, ex.args))
function nice(x)
    if isa(x, Expr)
        new_args = map(nice, x.args)
        return Expr(x.head, new_args...)
    elseif isa(x, Number)
        return NiceNumber(x)
    else
        return x
    end
end
"""
    @nice

Return equivalent expression with all numbers converted to `NiceNumber`s.
"""
macro nice(code)
    return nice(code)
end

# julia> @nice norm([4,12,3] * √2)
# Nice number:
#    0//1 + 13//1 ⋅ √2
#
# julia> norm([4,12,3] * √2)
# 18.38477631085024

##
#eps(::Type{NiceNumber}) = NiceNumber(0)

end # module