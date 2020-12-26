
# Structure Types
# ---------------
"""Supertype for character structures."""
abstract type AbstractCharStructure end

"""Leaf node of a structure tree; this contains a single component."""
struct Component <: AbstractCharStructure
    component::Char
end
struct LeftRightStructure{L<:AbstractCharStructure, R<:AbstractCharStructure} <: AbstractCharStructure
    left::L
    right::R
end
struct TopBottomStructure{T<:AbstractCharStructure, B<:AbstractCharStructure} <: AbstractCharStructure
    top::T
    bottom::B
end
struct VerticalThirdsStructure{L<:AbstractCharStructure, M<:AbstractCharStructure, R<:AbstractCharStructure} <:
AbstractCharStructure
    left::L
    middle::M
    right::R
end
struct HorizontalThirdsStructure{T<:AbstractCharStructure, M<:AbstractCharStructure, B<:AbstractCharStructure} <:
AbstractCharStructure
    top::T
    middle::M
    bottom::B
end
abstract type NestedStructure{I<:AbstractCharStructure, O<:AbstractCharStructure} <: AbstractCharStructure end
struct CenterNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct BottomNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct TopNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct RightNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct BottomRightNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct BottomLeftNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct TopRightNestedStructure{I, O} <: NestedStructure{I, O}
    inside::I
    outside::O
end
struct OverlapStructure{F<:AbstractCharStructure, B<:AbstractCharStructure} <: AbstractCharStructure
    front::F
    back::B
end


# Structure Parsing
# -----------------
function parse(tokens)::AbstractCharStructure
    next = take!(tokens)
    if next == '⿰'
        LeftRightStructure(parse(tokens), parse(tokens))
    elseif next == '⿱'
        TopBottomStructure(parse(tokens), parse(tokens))
    elseif next == '⿲'
        VerticalThirdsStructure(parse(tokens), parse(tokens), parse(tokens))
    elseif next == '⿳'
        HorizontalThirdsStructure(parse(tokens), parse(tokens), parse(tokens))
    elseif next == '⿴'
        CenterNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿵'
        BottomNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿶'
        TopNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿷'
        RightNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿸'
        BottomRightNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿹'
        BottomLeftNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿺'
        TopRightNestedStructure(parse(tokens), parse(tokens))
    elseif next == '⿻'
        OverlapStructure(parse(tokens), parse(tokens))
    else
        Component(next)
    end
end

"""
    IDSFiles.parse(::AbstractString)

Parse a single IDS string that describes a character/component's decomposition. (This function
does not do any input validation to verify that the string can actually represent a
decomposition; in this case, the method will fail.)

This is a relatively low-level method; you typically do not need to call this directly.

# Examples
We can take the IDS string itself and parse it as a nested structure.
```jldoctest
julia> parse("⿱此二")
CharStructure{TopBottomStructure}(TopBottomStructure(Component('此'), Component('二')))
```

"""
function parse(str::AbstractString)
    tokens = Channel{Char}(length(str))
    for char in Iterators.reverse(str)
        put!(tokens, char)
    end

    return parse(tokens)
end
