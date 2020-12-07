# tpaschalis 2020-12-07
# Advent of Code 2020 - Day 07

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")


lines = input 
    |> String.replace([".", " bag", " bags"], "") 
    |> String.split("\n", trim: true) 
    |> Enum.map(fn l -> String.split(l, [" contain ", ", "], trim: true) end)

defmodule Day7 do
    def processLines(g, [head | tail]) do
        
        [src | dests] = head
        h = :digraph.add_vertex(g, src)
        for dest <- dests do 
            case Integer.parse(dest) do
                {qty, col} -> 
                    pcol = String.trim(col)
                    d = :digraph.add_vertex(g, pcol)
                    :digraph.add_edge(g, h, d, qty)
                :error -> true
            end
        end

        processLines(g, tail)
    end

    def processLines(g, []) do
        g
    end

    def countTotalBagsUndnerneath(g, src) do
        edges = :digraph.out_edges(g, src)
        edges |> Enum.map(
            fn edge-> 
                {_, _, dst, count} = :digraph.edge(g, edge)
                count + count * countTotalBagsUndnerneath(g, dst)
            end
        )    
        |> Enum.sum()
  end


end

g = :digraph.new()
Day7.processLines(g, lines)

vertices = :digraph.vertices(g)
{shiny_gold, _} = :digraph.vertex(g, "shiny gold")

res1 = Enum.count(
    vertices, 
    fn vertex -> 
        :digraph.get_path(g, vertex, shiny_gold)
    end
)
IO.inspect(res1)

res2 = Day7.countTotalBagsUndnerneath(g, shiny_gold)
IO.inspect(res2)