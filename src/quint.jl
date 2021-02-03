# 
# Proquint.jl by P. Bayer, MIT license
#

const conson = "bdfghjklmnprstvz"
const vowels = "aiou"
const d = Dict{Char,Int}()
for i in eachindex(conson)
    d[conson[i]] = i-1
end
for i in eachindex(vowels)
    d[vowels[i]] = i-1
end
d['x'] = 0

c2i(c) = d[c]
i2v(i) = vowels[i+1]
i2c(i) = conson[i+1]

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
    s = ((i>>(12,10,6,4,0)[j]) & (0xF,0x3,0xF,0x3,0xF)[j] for j in 1:5)
    q = fill('x',5); push = false; k = 1
    for j in s
        j != 0 && (push = true)
        push && (q[k] = isodd(k) ? i2c(j) : i2v(j))
        k += 1
    end
    str = String(filter(!=('x'), q))
    return isempty(str) ? "x" : str
end

function uint(q::T) where T<:AbstractString
    res = 0
    j = 5 - length(q)
    for i in eachindex(q)
        res += c2i(q[i]) << (12,10,6,4,0)[i+j]
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
    quint2uint(qs::String, U::Type{T}=UInt) where T<:Unsigned

Convert a proquint string identifier `qs` into a corresponding integer value.

# Arguments
- `U`: unsigned integer type e.g. `UInt16`, `UInt32`, `UInt64` or `UInt128` 

# Example
```julia
julia> quint2uint("lusab-babad", UInt32)
0x7f000001

julia> quint2uint("lusab-d", UInt32)
0x7f000001
```
"""
function quint2uint(qs::String, U::Type{T}=UInt) where T<:Unsigned
    qa = split(qs, "-") |> reverse
    l = length(qa)
    res = 0
    for i in 1:l
        res += uint(qa[i]) << ((i-1)*16)
    end
    return U(res)
end
