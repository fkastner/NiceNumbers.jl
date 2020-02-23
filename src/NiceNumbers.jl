module NiceNumbers

import Primes: factor, prodfactors
import Base: +, -, *, /, inv, one, zero, isinteger
import Base.promote_rule

export NiceNumber
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
NiceNumber(x::T) where {T<:Union{Integer,Rational}} = NiceNumber(x, 0, 0)
NiceNumber(n::NiceNumber) = n

function reduce_root(coeff, radicand)
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

isrational(n::NiceNumber) = n.coeff == 0
isinteger(n::NiceNumber) = isrational(n) && isinteger(n.a)

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

end # module
