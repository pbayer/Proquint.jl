using Proquint
using Test

@testset "Proquint.jl" begin
    for i in 1:100
        r = rand(UInt32)
        q = uint2quint(r)
        @test quint2uint(q) == r
    end
    for i in 1:100
        r = rand(UInt32)
        q = uint2quint(r, short=true)
        @test quint2uint(q) == r
    end
end
