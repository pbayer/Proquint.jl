# 
# Proquint.jl by P. Bayer, MIT license
#
"""
# Proquints: Identifiers that are Readable, Spellable, and Pronounceable

This is a Julia implementation of Wilkerson's proquints 
described in his article [http://arXiv.org/html/0901.4016](http://arXiv.org/html/0901.4016).

In short 16 bits get represented in a "proquint" as alternating 
consonants and vowels.

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

The `UInt32` `0x0a484904` is in bit representation:

    0000 10 1001 00 1000  0100 10 0100 00 0100
      b   o   n   a   m  -  h   o   h   a   h
          o   n   a   m  -  h   o   h   a   h   # short version

The IP address `127.0.0.1` is a `0x7f000001` `UInt32`:

    0111 11 1100 00 0000  0000 00 0000 00 0001
      l   u   s   a   b  -  b   a   b   a   d
      l   u   s   a   b  -                  d   # short version

Proquints are unambiguous and can be generated from integers
and converted back to them:

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
"""
module Proquint

"Gives the package version"
const version = v"0.1.0" 

include("quint.jl")

export uint2quint, quint2uint

end
