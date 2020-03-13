module NiceNumbers

import Primes: factor, prodfactors
import Base: +, -, *, inv, /, sqrt, ^
import Base: //
import Base: <, <=, ==
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
NiceNumber(x::AbstractFloat) = NiceNumber(rationalize(Int, x), 0, 0)
NiceNumber(n::NiceNumber) = n

"""
    reduce_root(coeff, radicand)

Simplifies the expression ``\\textrm{coeff}\\cdot\\sqrt{\\textrm{radicand}}`` by factoring all remaining squares
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
promote_rule(::Type{NiceNumber}, ::Type{T}) where {T<:AbstractFloat} = NiceNumber # promote_type(Rational{Int}, T)
one(::NiceNumber) = NiceNumber(1, 0, 0)
zero(::NiceNumber) = NiceNumber(0, 0, 0)

AbstractFloat(n::NiceNumber) = float(n.a) + float(n.coeff) * √n.radicand
(::Type{T})(n::NiceNumber) where {T<:AbstractFloat} =
    convert(T, n.a) + convert(T, n.coeff) * convert(T, √n.radicand)

"""
    isrational(n::NiceNumber)

Whether `n` is purely rational, i.e. has no square root portion.
"""
isrational(n::NiceNumber) = iszero(n.coeff)
isinteger(n::NiceNumber) = isrational(n) && isinteger(n.a)
isfinite(n::NiceNumber) = isfinite(n.a) && isfinite(n.coeff)

function Base.show(io::IO, n::NiceNumber)
    pretty(r::Rational) = isinteger(r) ? numerator(r) : r

    if isrational(n)
        print(io, pretty(n.a))
    else
        print(
            io,
            iszero(n.a) ? "" : pretty(n.a),
            iszero(n.a) ? "" : " + ",
            isone(n.coeff) ? "" : pretty(n.coeff),
            isone(n.coeff) ? "" : " ⋅ ",
            "√",
            n.radicand,
        )
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
function nthroot(m::NiceNumber, n)
    !ispow2(n) && error("That's not nice anymore!")
    while n > 1
        m = sqrt(m)
        n = n >> 1
    end
    return m
end
^(x::Number, n::NiceNumber) = isrational(n) ? NiceNumber(x)^n.a : x^float(n)
^(n::NiceNumber, r::Rational) = nthroot(n^numerator(r), denominator(r))

<(n::NiceNumber, m::NiceNumber) = float(n) < float(m)
<=(n::NiceNumber, m::NiceNumber) = n === m || n < m
==(n::NiceNumber, m::AbstractFloat) = float(n) == m

//(n::S, m::T) where {S<:Union{NiceNumber,Integer,Rational},T<:Union{NiceNumber,Integer,Rational}} =
    n / m

norm(n::NiceNumber) = n > 0 ? n : -n
norm2(v::AbstractArray{NiceNumber,1}) = sqrt(v'v)

## macro stuff
"""
    nice(x, mod = @__MODULE__)

If `x` is an expression it replaces all occuring numbers by `NiceNumber`s.

If `x` is a number it turns it into a `NiceNumber`.

Otherwise it does nothing.
"""
function nice end
nice(x) = x
nice(n::Number) = NiceNumber(n)
nice(ex::Expr) = Expr(ex.head, map(nice, ex.args)...)

"""
    @nice

Return equivalent expression with all numbers converted to `NiceNumber`s.
"""
macro nice(code)
    return esc(nice(code))
end

end # module
