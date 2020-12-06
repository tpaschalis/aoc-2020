# tpaschalis 2020-12-06
# Advent of Code 2020 - Day 06

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

groupedAnswers1 = input |> String.split("\n\n", trim: true) |> Enum.map(fn l -> String.replace(l, "\n", "", trim: true) end)
groupedAnswers2 = input |> String.split("\n\n", trim: true)

defmodule Day6 do
    def countYesses1(l) do
        # l |> String.graphemes() |> Enum.frequencies() |> Map.keys() |> length()
        l |> String.graphemes() |> MapSet.new() |> MapSet.size()

    end

    def intersect(r, [head | tail]) do
        intersect(MapSet.intersection(r, head |> String.graphemes |> MapSet.new()), tail)
    end
    def intersect(r, []) do
        r
    end
end

res1 = Enum.map(groupedAnswers1, fn l -> Day6.countYesses1(l) end) |> Enum.sum()
IO.inspect(res1)

r = "abcdefghijklmnopqrstuvwxyz" |> String.graphemes |> MapSet.new()
res2 = Enum.map(groupedAnswers2, fn l -> Day6.intersect(r, l |> String.split("\n", trim: true)) |> MapSet.size() end) |> Enum.sum()
IO.inspect(res2)

## Part Two
## Guess 3351 -- too low
## Guess 3600 randomly -- too high
## Actual was 3354 -- I was missing `trim: true` on res2 line