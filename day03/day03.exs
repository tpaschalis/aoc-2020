# tpaschalis 2020-12-03
# Advent of Code 2020 - Day 03

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n", trim: true)

# Part 1
res1 = Enum.count(
    Enum.with_index(lines), 
    fn {line, idx} -> 
        col = rem(idx * 3, 31)
        String.at(line, col) == "#"
    end
)
IO.inspect(res1)

# Part 2
# We need to check more slopes, so let's generalize Part 1
defmodule Day3 do
    def countTrees(biome, down, right) do
        lines = Enum.take_every(biome, down)
        modulo = String.length(List.first(lines))
        res = Enum.count(
            Enum.with_index(lines), 
            fn {line, idx} -> 
                col = rem(idx * right, modulo)
                String.at(line, col) == "#"
            end
        )
        res
    end
end

cases = [ 
    %{:right => 1, :down => 1},
    %{:right => 3, :down => 1},     # The slope we checked on Part 1
    %{:right => 5, :down => 1},
    %{:right => 7, :down => 1},
    %{:right => 1, :down => 2}
]

res2 = Enum.map(cases, fn c -> Day3.countTrees(lines, c[:down], c[:right]) end) |> Enum.reduce(fn x, acc -> x*acc end)
IO.inspect(res2)
