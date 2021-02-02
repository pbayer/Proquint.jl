# 
# Proquint.jl by P. Bayer, MIT license
#

i2c(i) = "bdfghjklmnprstvz"[i+1]
c2i(c) = findfirst(==(c), "bdfghjklmnprstvz") - 1
i2v(i) = "aiou"[i+1]
v2i(c) = findfirst(==(c), "aiou") - 1
function quint(i)
    q = fill('x',5)
    q[5] = i2c(i & 0xF)
    q[4] = i2v((i>>4) & 0x3)
    q[3] = i2c((i>>6) & 0xF)
    q[2] = i2v((i>>10) & 0x3)
    q[1] = i2c((i>>12) & 0xF)
    return String(q)
end

function squint(i)
    s = [(i>>(12,10,6,4,0)[j]) & (0xF,0x3,0xF,0x3,0xF)[j] for j in 1:5]
    sq = ""; push = false
    for j in eachindex(s)
        s[j] != 0 && (push = true)
        push && (sq *= isodd(j) ? i2c(s[j]) : i2v(s[j]))
    end
    return String(sq)
end

function uint(q)
    res = 0
    j = 5 - length(q)
    for i in eachindex(q)
        res += (isodd(i+j) ? c2i(q[i]) : v2i(q[i])) << (12,10,6,4,0)[i+j]
    end
    return UInt(res)
end

"""
    uint2quint(x::T, sep="-"; short=false) where T<:Integer

Convert an integer value into a corresponding proquint string identifier.

# Arguments
- `x`: an integer argument,
- `sep="-"`: a separator string,
- `short=false`: determines whether a short string should be created.

# Example
```julia
julia> uint2quint(0x7f000001)
"lusab-babad"

julia> uint2quint(0x7f000001, short=true)
"lusab-d"
```
"""
function uint2quint(x::T, sep="-"; short=false) where T<:Integer
    f = short ? squint : quint
    qs = sizeof(x) ÷ 2
    @assert qs ≥ 1 "size of x=$(repr(x)) must be at least 2 bytes!"
    s = ""
    for q in 1:qs
        s = f(x)*s
        x >>= 16
        q == qs || (s = sep*s)
    end
    return s
end

"""
    quint2uint(qs::String)

Convert a proquint string identifier `qs` into a corresponding integer value.

# Example
```julia
julia> quint2uint("lusab-babad")
0x7f000001

julia> quint2uint("lusab-d")
0x7f000001
```
"""
function quint2uint(qs::String)
    qa = split(qs, "-") |> reverse
    l = length(qa)
    T = l == 1 ? UInt16 :
        l == 2 ? UInt32 :
        l <= 4 ? UInt64 : UInt128
    res = 0
    for i in 1:length(qa)
        res += uint(qa[i]) << ((i-1)*16)
    end
    return T(res)
end
