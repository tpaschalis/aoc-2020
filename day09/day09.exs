# tpaschalis 2020-12-09
# Advent of Code 2020 - Day 09

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

defmodule Day9 do
    def isXMAS(lst, idx) do
        preamble_size = 25
        sublist = Enum.slice(lst, idx-preamble_size..idx)
        sums = combinations(sublist)
        curr = Enum.at(lst, idx)

        case sums[curr] do
            true -> 
                isXMAS(lst, idx+1)
            nil -> 
                curr
        end
    end
    
    def isWeakness(lst, idx1, idx2) do 
        goal = 25918798 # From part 1
        case Enum.slice(lst, idx1..idx2) |> Enum.sum() do
            r when r > goal -> 
                isWeakness(lst, idx1+1, idx2)
            r when r < goal -> 
                isWeakness(lst, idx1, idx2+1)
            r when r == goal -> 
                Enum.slice(lst, idx1..idx2)
        end
    end

    def combinations(list) do
        for {x, xidx} <- Enum.with_index(list), {y, yidx} <- Enum.with_index(list), xidx != yidx, into: %{}, do: {x+y, true}
    end
end

res1 = Day9.isXMAS(lines, 25)
IO.inspect(res1)

range = Day9.isWeakness(lines, 0, 1)
res2 = Enum.max(range) + Enum.min(range)
IO.inspect(res2)
