using DataStructures

# Structure Types
# ---------------
abstract type AbstractCharStructure end
struct Component <: AbstractCharStructure
    component::Char
end
struct LeftRightStructure <: AbstractCharStructure
    left::AbstractCharStructure
    right::AbstractCharStructure
end
struct TopBottomStructure <: AbstractCharStructure
    top::AbstractCharStructure
    bottom::AbstractCharStructure
end
struct VerticalThirdsStructure <: AbstractCharStructure
    left::AbstractCharStructure
    middle::AbstractCharStructure
    right::AbstractCharStructure
end
struct HorizontalThirdsStructure <: AbstractCharStructure
    top::AbstractCharStructure
    middle::AbstractCharStructure
    bottom::AbstractCharStructure
end
abstract type NestedStructure <: AbstractCharStructure end
struct CenterNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct BottomNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct TopNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct RightNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct BottomRightNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct BottomLeftNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct TopRightNestedStructure <: NestedStructure
    inside::AbstractCharStructure
    outside::AbstractCharStructure
end
struct OverlapStructure <: AbstractCharStructure
    front::AbstractCharStructure
    back::AbstractCharStructure
end

struct CharStructure{T<:AbstractCharStructure}
    structure::T
end

# Structure Parsing
# -----------------
function parse(tokens::Stack{Char})::AbstractCharStructure
    next = pop!(tokens)
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

function parse(str::AbstractString)
    tokens = Stack{Char}()
    for char in reverse(str)
        push!(tokens, char)
    end
    CharStructure(parse(tokens))
end
