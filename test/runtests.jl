using NiceNumbers
using NiceNumbers: NotNiceError
using Test, LinearAlgebra

@static if VERSION < v"1.7"
    nopivot = Val(false)
    pivot   = Val(true)
else
    nopivot = NoPivot()
    pivot   = RowMaximum()
end

@testset "NiceNumbers" begin
    @testset "Constructors" begin
        @test NiceNumber(8) === NiceNumber(8, 0, 0)
        @test NiceNumber(2, 3, 4) === NiceNumber(8)
        @test NiceNumber(2, 3, 0) === NiceNumber(2)
        @test NiceNumber(2, 0, 5) === NiceNumber(2)
        @test NiceNumber(3 // 5) === NiceNumber(3 // 5, 0, 0)
        @test NiceNumber(3 // 5, 3 // 5, 27 // 125) === NiceNumber(3 // 5, 9 // 125, 15)
        @test NiceNumber(0, 1, 1 // 5) === NiceNumber(0, 1 // 5, 5)
        @test NiceNumber(0.1) === NiceNumber(1 // 10)
    end

    n = NiceNumber(2, 3, 5)
    m = NiceNumber(5, -3, 5)
    k = NiceNumber(8, 4, 3)
    c = NiceNumber(0, 1, -5)
    z = NiceNumber(2, -3, -5)

    @testset "Basic Arithmetic" begin
        @test n + m === NiceNumber(7)
        @test_throws NotNiceError n + k
        @test n - m === NiceNumber(-3, 6, 5)
        @test_throws NotNiceError n - k
        @test n * m === NiceNumber(-35, 9, 5)
        @test_throws NotNiceError n * k
        @test n / m === NiceNumber(-11 // 4, -21 // 20, 5)
        @test_throws NotNiceError n / k
        @test c * c === NiceNumber(-5)
    end

    @testset "Scalar Arithmetic" begin
        @test +n === n
        @test -n === NiceNumber(-2, -3, 5)
        @test 4 + n === n + 4 === NiceNumber(6, 3, 5)
        @test 4 - n === -(n - 4) === NiceNumber(2, -3, 5)
        @test 3 * n === n * 3 === NiceNumber(6, 9, 5)
        @test n / 3 === inv(3 / n) === NiceNumber(2 // 3, 1, 5)

        @test sqrt(NiceNumber(9)) === NiceNumber(3)
        @test sqrt(NiceNumber(3 // 5)) === NiceNumber(0, 1 // 5, 15)
        @test NiceNumbers.nthroot(NiceNumber(81), 8) === NiceNumber(0, 1, 3)
        @test NiceNumber(4)^(3 // 2) === NiceNumber(8)
        @test 4^NiceNumber(3 // 2) === NiceNumber(8)
    end

    @testset "Rational Arithmetic" begin
        @test n // 3 === n / 3
        @test 3 // n === 3 / n
        @test n // n === n / n === NiceNumber(1)
    end

    @testset "Comparisons" begin
        @test NiceNumber(7) < NiceNumber(42)
        @test NiceNumber(7) < NiceNumber(7, 1, 2)
        @test NiceNumber(7) <= NiceNumber(7, 1, 2)
        @test NiceNumber(7) <= NiceNumber(7)
        @test NiceNumber(5, 1, 2) < 7
        @test NiceNumber(5, 1, 2) > 5
        @test NiceNumber(13, 3, 7) == 13 + 3 * √7
        @test 13 + 3 * √7 == NiceNumber(13, 3, 7)
        @test !(NiceNumber(7) < 7) # issue #7
    end

    @testset "Conversion" begin
        @test NiceNumber(n) == n
        @test float(NiceNumber(13, 3, 7)) == 13 + 3 * √7
        @test Float64(NiceNumber(13, 3, 7)) == 13 + 3 * √7
    end

    @testset "Promotion" begin
        @test n + 18 // 5 === NiceNumber(28 // 5, 3, 5)
        @test n + 3.6 === NiceNumber(28 // 5, 3, 5)
        @test NiceNumber(3,3,-1) + 7im === NiceNumber(3,10,-1) # issue #5
        @test NiceNumber(3,3,-1) * 7im === NiceNumber(-21,21,-1) # issue #5
    end

    @testset "Complex stuff" begin
        @test abs(n) === n
        @test abs(m) === -m
        @test abs(c) === NiceNumber(0,1,5)
        @test conj(z) === NiceNumber(2,3,-5)
        @test abs(z) === NiceNumber(7)
    end

    u = NiceNumber[4, 12, 3] * sqrt(NiceNumber(2))
    @testset "Linear Algebra" begin
        @test norm(n) === n
        @test norm(m) === -m
        @test norm(u) === NiceNumber(0, 13, 2)
    end

    @testset "Misc" begin
        @test isrational(NiceNumber(139 // 7, 0, 17))
        @test isinteger(NiceNumber(12))
        @test isfinite(NiceNumber(12))
        @test !isfinite(NiceNumber(1 // 0, 7, 7))
        @test !isfinite(NiceNumber(7, 1 // 0, 7))
        @test one(n) === one(NiceNumber) === NiceNumber(1)
        @test zero(n) === zero(NiceNumber) === NiceNumber(0)
    end

    @testset "Macro" begin
        @test @nice 4^1.5 === NiceNumber(8)
        @test @nice sqrt(9//4)+7*sqrt(3)*im === NiceNumber(3//2,7,-3)
    end

    @testset "Show Methods" begin
        io = IOBuffer()
        @test sprint(io -> show(io, n)) == "2+3⋅√5"
        @test sprint(io -> show(io, NiceNumber(0))) == "0"
        @test sprint(io -> show(io, NiceNumber(7))) == "7"
        @test sprint(io -> show(io, NiceNumber(7 // 2))) == "7//2"
        @test sprint(io -> show(io, NiceNumber(7, 1, 5))) == "7+√5"
        @test sprint(io -> show(io, NiceNumber(7, -1, 5))) == "7-√5"
        @test sprint(io -> show(io, NiceNumber(7, 5, 5))) == "7+5⋅√5"
        @test sprint(io -> show(io, NiceNumber(7, -5, 5))) == "7-5⋅√5"
        @test sprint(io -> show(io, NiceNumber(7, 1 // 2, 5))) == "7+1//2⋅√5"
        @test sprint(io -> show(io, NiceNumber(7 // 2, 1, 5))) == "7//2+√5"
        @test sprint(io -> show(io, NiceNumber(7 // 2, 5, 5))) == "7//2+5⋅√5"
        @test sprint(io -> show(io, NiceNumber(7 // 2, 1 // 2, 5))) == "7//2+1//2⋅√5"
        @test sprint(io -> show(io, NiceNumber(0, 1, 5))) == "√5"
        @test sprint(io -> show(io, NiceNumber(0, 5, 5))) == "5⋅√5"
        @test sprint(io -> show(io, NiceNumber(0, -5, 5))) == "-5⋅√5"
        @test sprint(io -> show(io, NiceNumber(0, 1 // 2, 5))) == "1//2⋅√5"
    end
    
    @testset "Factorizations" begin
        @testset "Cholesky" begin
            @nice L = [2 0 0 0;0 1 0 0;4 6*sqrt(-1) 9 0;0 4 0 2]
            @test L == cholesky(L*L').L
        end

        @testset "LU" begin
            @nice L = [1 0 0;im 1 0; 1/2 -3im 1]
            @nice U = [1 1 1;0 1 1; 0 0 1]
            LUL, LUU = lu(L*U, nopivot)
            @test LUL == L
            @test LUU == U

            @nice A = [2 2 0;2 2 1; 2 3 5]
            L, U, p = lu(A, pivot)
            @test L == @nice [1 0 0;1 1 0;1 0 1]
            @test U == @nice [2 2 0;0 1 5;0 0 1]
            @test p == [1,3,2]
        end

        @testset "QR" begin
            @nice A = [4 2;0 3//5;0 -4//5;0 0]
            Q, R = qr(A)
            @test Q * I == @nice [-1 0 0 0;0 -3/5 4/5 0;0 4/5 3/5 0;0 0 0 1]
            @test R == @nice [-4 -2;0 -1]
        end
    end
end
