using NiceNumbers
using Test


@testset "NiceNumbers" begin
    @testset "Constructors" begin
        @test NiceNumber(8) == NiceNumber(8, 0, 0)
        @test NiceNumber(2, 3, 4) == NiceNumber(8)
        @test NiceNumber(2, 3, 0) == NiceNumber(2)
        @test NiceNumber(2, 0, 5) == NiceNumber(2)
    end

    n = NiceNumber(2, 3, 5)
    m = NiceNumber(5, -3, 5)
    k = NiceNumber(8, 4, 3)

    @testset "Basic Arithmetic" begin
        @test n + m == NiceNumber(7)
        @test_broken n + k
        @test n - m == NiceNumber(-3, 6, 5)
        @test_broken n - k
        @test n * m == NiceNumber(-35, 9, 5)
        @test_broken n * k
        @test n / m == NiceNumber(-11 // 4, -21 // 20, 5)
        @test_broken n / k
    end

    @testset "Scalar Arithmetic" begin
        @test 4 + n == n + 4 == NiceNumber(6, 3, 5)
        @test 4 - n == -(n - 4) == NiceNumber(2, -3, 5)
        @test 3 * n == n * 3 == NiceNumber(6, 9, 5)
        @test n / 3 == inv(3 / n) == NiceNumber(2 // 3, 1, 5)
    end

    @testset "Conversion" begin
        @test float(NiceNumber(13, 3, 7)) == 13 + 3 * √7
    end

    @testset "Misc" begin
        @test isrational(NiceNumber(139 // 7, 0, 17))
        @test isinteger(NiceNumber(12))
    end
end
