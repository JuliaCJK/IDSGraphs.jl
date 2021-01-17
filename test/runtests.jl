using IDSGraphs
using LightGraphs

using Test

function test_graph()
    g = IDSGraph()
    add_edge!(g, 'a', 'b')
    add_edge!(g, 'a', 'e')
    add_edge!(g, 'b', 'c')
    add_edge!(g, 'b', 'd')
    add_edge!(g, 'e', 'f')
    add_edge!(g, 'f', 'd')
    add_edge!(g, 'c', 'i')
    add_edge!(g, 'c', 'j')
    add_edge!(g, 'd', 'g')
    add_edge!(g, 'd', 'h')

    return g
end

@testset "unit tests" begin
    @testset "linear graph creation" begin
        g = IDSGraph()
        @test nv(g) == 0
        @test ne(g) == 0

        for (n, c) in enumerate('a':'z')
            add_vertex!(g, c)
            @test nv(g) == n
            @test ne(g) == 0
        end

        add_edge!(g, 'a', 'z')
        @test ne(g) == 1
        @test has_edge(g, 'a', 'z')
    end

    @testset "verify test graph" begin
        g = test_graph()
        @test nv(g) == 10
        @test ne(g) == 10

        for c in 'a':'j'
            @test has_vertex(g, c)
        end

        @test length(symdiff(unique(vertices(g)), 'a':'j')) == 0

        # test inneighbors
        @test length(inneighbors(g, 'a')) == 0
        @test length(inneighbors(g, 'b')) == 1
        @test length(inneighbors(g, 'c')) == 1
        @test length(inneighbors(g, 'e')) == 1
        @test length(inneighbors(g, 'f')) == 1
        @test length(inneighbors(g, 'g')) == 1
        @test length(inneighbors(g, 'h')) == 1
        @test length(inneighbors(g, 'i')) == 1
        @test length(inneighbors(g, 'j')) == 1
        @test length(inneighbors(g, 'd')) == 2

        # test outneighbors
        @test length(outneighbors(g, 'a')) == 2
        @test length(outneighbors(g, 'b')) == 2
        @test length(outneighbors(g, 'c')) == 2
        @test length(outneighbors(g, 'e')) == 1
        @test length(outneighbors(g, 'f')) == 1
        @test length(outneighbors(g, 'g')) == 0
        @test length(outneighbors(g, 'h')) == 0
        @test length(outneighbors(g, 'i')) == 0
        @test length(outneighbors(g, 'j')) == 0
        @test length(outneighbors(g, 'd')) == 2
    end

    @testset "graph properties/invariants" begin
        g = test_graph()

        # zero (identity) graph
        zero_graph = zero(g)
        @test nv(zero_graph) == 0
        @test ne(zero_graph) == 0
        @test length(collect(vertices(zero_graph))) == 0
        @test length(collect(edges(zero_graph))) == 0

        # types
        @test eltype(typeof(g)) == Char
        @test edgetype(g) == IDSGraphs.CharEdge

        # directed graph type
        @test is_directed(typeof(g))
    end

    @testset "conditional subgraphs" begin
        subg = IDSGraphs.subgraph(v -> v in 'b':'g', test_graph())

        @test nv(subg) == 6
        @test ne(subg) == 5

        @test length(symdiff(unique(vertices(subg)), 'b':'g')) == 0

        @test has_edge(subg, 'b', 'c')
        @test has_edge(subg, 'b', 'd')
        @test has_edge(subg, 'e', 'f')
        @test has_edge(subg, 'f', 'd')
        @test has_edge(subg, 'd', 'g')
    end
end