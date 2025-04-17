include("../src/quiz_web.jl")
using JSON3
using Test
using .Quiz_web

@testset "Quiz Web" begin
    @testset "Question" begin
        q = Question(
            1,
            "Mathematik",
            "Grundrechenarten",
            "Addition",
            "1+1",
            "2",
            ["1", "3", "4"],
            1,
            nothing,
            true
        )
        @test q.id == 1
        @test q.domain == "Mathematik"
        @test q.category == "Grundrechenarten"
        @test q.subcategory == "Addition"
        @test q.subject == "1+1"
        @test q.question == "2"
        @test q.right_answers == ["1", "3", "4"]
        @test q.difficulty == 1
        @test q.funfact == nothing
        @test q.is_verified == true
    end
#=
    @testset "read_question_vector_from_json" begin
        q = read_question_vector_from_json("test/questions.json")
        @test length(q) == 2
        @test q[1].id == 1
        @test q[1].domain == "Mathematik"
        @test q[1].category == "Grundrechenarten"
        @test q[1].subcategory == "Addition"
        @test q[1].subject == "1+1"
        @test q[1].question == "2"
        @test q[1].right_answers == ["1", "3", "4"]
        @test q[1].difficulty == 1
        @test q[1].funfact == nothing
        @test q[1].is_verified == true
        @test q[2].id == 2
        @test q[2].domain == "Mathematik"
        @test q[2].category == "Grundrechenarten"
        @test q[2].subcategory == "Addition"
        @test q[2].subject == "2+2"
        @test q[2].question == "4"
        @test q[2].right_answers == ["3", "4", "5"]
        @test q[2].difficulty == 2
        @test q[2].funfact == nothing
        @test q[2].is_verified == true
    end

=#
end