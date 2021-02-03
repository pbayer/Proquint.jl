# Proquint

Proquints: Identifiers that are readable, spellable, and pronounceable

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://pbayer.github.io/Proquint.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://pbayer.github.io/Proquint.jl/dev)
[![Build Status](https://github.com/pbayer/Proquint.jl/workflows/CI/badge.svg)](https://github.com/pbayer/Proquint.jl/actions)
[![Coverage](https://codecov.io/gh/pbayer/Proquint.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/pbayer/Proquint.jl)

This is a Julia implementation of Wilkerson's proquints 
described in his article http://arXiv.org/html/0901.4016.

In short 16 bits get represented in a "proquint" as alternating 
consonants and vowels

Four-bits as a consonant:

    0 1 2 3 4 5 6 7 8 9 A B C D E F
    b d f g h j k l m n p r s t v z

Two-bits as a vowel:

    0 1 2 3
    a i o u

Whole 16-bit word, where "con" = consonant, "vo" = vowel:

     0 1 2 3 4 5 6 7 8 9 A B C D E F
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |con    |vo |con    |vo |con    |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Proquints are separated by dashes `-`.

## Short Form (extension)

The short form does not encode leading zeros of 16-bit words and if an entire word is 0, it gets encoded as "x".

## Example

The `UInt32` `0x0a484904` is in bit representation:

    0000 10 1001 00 1000  0100 10 0100 00 0100
      b   o   n   a   m  -  h   o   h   a   h
          o   n   a   m  -  h   o   h   a   h   # short form

The IP address `127.0.0.1` is a `0x7f000001` `UInt32`:

    0111 11 1100 00 0000  0000 00 0000 00 0001
      l   u   s   a   b  -  b   a   b   a   d
      l   u   s   a   b  -                  d   # short form

Proquints are unambiguous and can be generated from integers
and converted back to them.

```julia
julia> using Proquint

julia> uint2quint(0x7f000001)
"lusab-babad"

julia> uint2quint(0x7f000001, short=true) # this gives the short version
"lusab-d"

julia> quint2uint("lusab-babad", UInt32)
0x7f000001

julia> quint2uint("lusab-d", UInt32)
0x7f000001
```

## 64-bit Words

```julia
julia> a = [123]
1-element Array{Int64,1}:
 123

julia> addr = convert(UInt, pointer_from_objref(a))
0x00000001150cf910

julia> uint2quint(addr)
"babab-babad-dihas-zohib"

julia> uint2quint(addr, short=true)
"x-d-dihas-zohib"

julia> quint2uint("babab-babad-dihas-zohib")
0x00000001150cf910

julia> quint2uint("x-d-dihas-zohib")
0x00000001150cf910

julia> uint2quint(0x00000001150c0000, short=true)
"x-d-dihas-x"

julia> quint2uint("x-d-dihas-x")
0x00000001150c0000
```

## Benchmarks

```julia
julia> using BenchmarkTools

julia> @btime uint2quint(0x7f000001)
  218.109 ns (9 allocations: 416 bytes)
"lusab-babad"

julia> @btime uint2quint(0x7f000001, short=true)
  289.967 ns (11 allocations: 640 bytes)
"lusab-d"

julia> @btime quint2uint("lusab-babad", UInt32)
  331.712 ns (3 allocations: 320 bytes)
0x7f000001

julia> @btime quint2uint("lusab-d", UInt32)
  282.788 ns (3 allocations: 320 bytes)
0x7f000001

julia> versioninfo()
Julia Version 1.5.3
Commit 788b2c77c1 (2020-11-09 13:37 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin18.7.0)
  CPU: Intel(R) Core(TM) i9-9880H CPU @ 2.30GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-9.0.1 (ORCJIT, skylake)
```
