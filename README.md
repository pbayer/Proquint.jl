# Proquint

Proquints: Identifiers that are Readable, Spellable, and Pronounceable

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

## Example

The IP address `127.0.0.1` is a `0x7f000001` `UInt32`. It can be
converted to a proquint and vice versa:

```julia
julia> using Proquint

julia> uint2quint(0x7f000001)
"lusab-babad"

julia> uint2quint(0x7f000001, short=true) # this gives the short version
"lusab-d"

julia> quint2uint("lusab-babad")
0x7f000001

julia> quint2uint("lusab-d")
0x7f000001
```
