module NiceNumbers

import Primes: factor, prodfactors
import Base: showerror
import Base: +, -, *, inv, /, sqrt, ^
import Base: //
import Base: isless, <, <=, ==, hash
import Base: one, zero, isinteger, isfinite
import Base: promote_rule
import Base: isreal, real, imag, conj, abs, abs2
import LinearAlgebra: norm, norm2
import Base: copysign

export NiceNumber, nice, @nice
export isrational

struct NiceNumber <: Number
    a::Rational{Int}
    coeff::Rational{Int}
    radicand::Int
    function NiceNumber(a::S, coeff::T, radicand::Int) where {S<:Union{Integer,Rational}, T<:Union{Integer,Rational}}
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
NiceNumber(x::T) where {T<:Union{Integer,Rational}} = NiceNumber(x, 0, 0)
NiceNumber(a, coeff, radicand::Rational) =
    NiceNumber(a, coeff // denominator(radicand), numerator(radicand) * denominator(radicand))
NiceNumber(a, coeff, radicand) = NiceNumber(a)+NiceNumber(coeff)*sqrt(NiceNumber(radicand))
NiceNumber(x::AbstractFloat) = NiceNumber(rationalize(Int, x), 0, 0)
NiceNumber(z::Complex{T}) where T<:Real = NiceNumber(z.re) + NiceNumber(0,z.im,-1)
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

struct NotNiceError <: Exception
    expr::String
end
showerror(io::IO, e::NotNiceError) = print(io, e.expr, " is not nice anymore!")

"""
    isrational(n::NiceNumber)

Whether `n` is purely rational, i.e. has no square root portion.
"""
isrational(n::NiceNumber) = iszero(n.coeff)
isinteger(n::NiceNumber) = isrational(n) && isinteger(n.a)
isfinite(n::NiceNumber) = isfinite(n.a) && isfinite(n.coeff)
isreal(n::NiceNumber) = n.radicand >= 0
real(n::NiceNumber) = isreal(n) ? n : NiceNumber(n.a)
imag(n::NiceNumber) = isreal(n) ? zero(n) : NiceNumber(0,n.coeff,-n.radicand)
checkreal(n::NiceNumber) = isreal(n) || throw(DomainError(n, "Need a real number for this."))

function Base.show(io::IO, n::NiceNumber)
    pretty(r::Rational) = isinteger(r) ? numerator(r) : r

    if isrational(n)
        print(io, pretty(n.a))
    else
        print(
            io,
            iszero(n.a) ? "" : pretty(n.a),
            n.coeff>0 ? iszero(n.a) ? "" : "+" : "-",
            isone(abs(n.coeff)) ? "" : pretty(abs(n.coeff)),
            isone(abs(n.coeff)) ? "" : "⋅",
            "√",
            n.radicand,
        )
    end
end
Base.show(io::IO, ::MIME"text/plain", n::NiceNumber) = print(io, "Nice number:\n   ", n)

## Promotion & Conversion
# always promote to NiceNumber; if that can't be done, it can't be nice
promote_rule(::Type{NiceNumber}, ::Type{T}) where {T<:Number} = NiceNumber
one(::NiceNumber) = NiceNumber(1, 0, 0)
zero(::NiceNumber) = NiceNumber(0, 0, 0)

AbstractFloat(n::NiceNumber) = checkreal(n) && float(n.a) + float(n.coeff) * √n.radicand
(::Type{T})(n::NiceNumber) where {T<:AbstractFloat} =
    checkreal(n) && convert(T, n.a) + convert(T, n.coeff) * convert(T, √n.radicand)

## Arithmetic
# +(n::NiceNumber) = n # already in Base for <:Number
-(n::NiceNumber) = NiceNumber(-n.a, -n.coeff, n.radicand)
function +(n::NiceNumber, m::NiceNumber)
    if !(n.radicand == m.radicand || isrational(n) || isrational(m))
        throw(NotNiceError("$n + $m"))
    end
    if isrational(m)
        return NiceNumber(n.a + m.a, n.coeff, n.radicand)
    else
        # either n is rational (n.coeff==0) or the radicands match
        return NiceNumber(n.a + m.a, n.coeff + m.coeff, m.radicand)
    end
end
-(n::NiceNumber, m::NiceNumber) = n + (-m)

function *(n::NiceNumber, m::NiceNumber)
    # if both have a complex part we need a minus in the last term
    if n.radicand < 0 && m.radicand < 0
        return NiceNumber(m.a * n.a, m.a * n.coeff, n.radicand) +
               NiceNumber(0, m.coeff * n.a, m.radicand) +
               NiceNumber(0, -n.coeff * m.coeff, n.radicand * m.radicand)
    else
        return NiceNumber(m.a * n.a, m.a * n.coeff, n.radicand) +
               NiceNumber(0, m.coeff * n.a, m.radicand) +
               NiceNumber(0, n.coeff * m.coeff, n.radicand * m.radicand)
    end
end

inv(n::NiceNumber) = NiceNumber(n.a, -n.coeff, n.radicand) * inv(n.a^2 - n.coeff^2 * n.radicand)
/(n::NiceNumber, m::NiceNumber) = n * inv(m)

sqrt(n::NiceNumber) = isrational(n) ? NiceNumber(0, 1, n.a) : throw(NotNiceError("sqrt($n)"))
"""
    nthroot(m::NiceNumber, n)

Returns the nth root of `m`. Works by repeatedly determining the square root and thus only for
powers of two.
"""
function nthroot(m::NiceNumber, n)
    !ispow2(n) && throw(NotNiceError("nthroot($m,$n)"))
    while n > 1
        m = sqrt(m)
        n = n >> 1
    end
    return m
end
^(x::Number, n::NiceNumber) = isrational(n) ? NiceNumber(x)^n.a : throw(NotNiceError("$x^$n"))
^(n::NiceNumber, r::Rational) = nthroot(n^numerator(r), denominator(r))

# TODO: think about comparisons more (or less)
isless(n::NiceNumber, m::NiceNumber) = float(n) < float(m)
isless(n::Real, m::NiceNumber) = n < float(m)
isless(n::NiceNumber, m::Real) = float(n) < m
# <(n::NiceNumber, m::NiceNumber) = float(n) < float(m) # falls back to isless
# <=(n::NiceNumber, m::NiceNumber) = n === m || n < m # fallback already in Base
==(n::NiceNumber, m::AbstractFloat) = float(n) == m
==(m::AbstractFloat, n::NiceNumber) = n == m
hash(n::NiceNumber, h::UInt) = hash(n.a, hash(n.coeff, hash(n.radicand, hash(:NiceNumber, h))))

//(n::S, m::T) where {S<:Union{NiceNumber,Integer,Rational},T<:Union{NiceNumber,Integer,Rational}} =
    n / m

conj(n::NiceNumber) = isreal(n) ? n : NiceNumber(n.a, -n.coeff, n.radicand)
abs(n::NiceNumber) = isreal(n) ? float(n)>0 ? n : -n : sqrt(n*conj(n))
abs2(n::NiceNumber) = n*conj(n)
norm(n::NiceNumber) = abs(n)
norm2(v::AbstractArray{NiceNumber,1}) = sqrt(v'v)
copysign(n::NiceNumber, m::NiceNumber) = sign(n) == sign(m) ? n : -n

## macro stuff
"""
    nice(x)

If `x` is an expression it replaces all occuring numbers by `NiceNumber`s.

If `x` is a number it turns it into a `NiceNumber`.

If `x` is the symbol `:im` it turns it into `NiceNumber(im)`.

Otherwise it does nothing.
"""
function nice end
nice(x) = x
nice(n::Number) = NiceNumber(n)
nice(s::Symbol) = s===:im ? NiceNumber(im) : s
nice(ex::Expr) = Expr(ex.head, map(nice, ex.args)...)

"""
    @nice

Return equivalent expression with all numbers converted to `NiceNumber`s.
"""
macro nice(code)
    return esc(nice(code))
end

include("NiceLinAlg.jl")

end # module
