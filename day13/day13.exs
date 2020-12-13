# tpaschalis 2020-12-12
# Advent of Code 2020 - Day 12

defmodule Day13 do
    def bruteForceCongruence(values, idx) do
        # IO.inspect(idx)
        n = values |> Enum.map(fn {n, m} -> rem(idx+m, n) == 0 end) |> Enum.count(fn v -> v end)
        if n == 9 do # num of constraints -> 
            idx
        else 
            bruteForceCongruence(values, idx+19)
        end
    end

    # thanks to github.com/omginbd for
    # the Chinese Remainder Theorem implementation
    # Also, nice discussion on https://elixirforum.com/t/advent-of-code-2020-day-13/36180
    def findEarliest(buses) do
        starting_point = buses
        |> Enum.map(&(elem(&1, 0)))
        |> Enum.reduce(1, &Kernel.*/2)

        x = Enum.map(
            buses,
            fn {n, a} -> 
                ni = Integer.floor_div(starting_point, n)
                xi = find_xi(ni, n, 1)
                ni * xi * a
            end
        )
        |> Enum.sum()
        |> Kernel.rem(starting_point)
        
        starting_point - x
    end

    def find_xi(ni, n, x) do
        case rem(x*ni, n) do
            1 -> x
            _ -> find_xi(ni, n, x+1)
        end
    end
end

## Setup 

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n", trim: true)
[strTimestamp, strBuses] = lines

timestamp = String.to_integer(strTimestamp)
buses = strBuses 
    |> String.split(",", trim: true)
    |> Enum.filter(fn b -> b != "x" end)
    |> Enum.map(&String.to_integer/1)

## Part 1
m = Enum.map(buses, fn b -> {b - rem(timestamp, b), b} end) |> Enum.into(%{})
selected_bus = Map.keys(m) |> Enum.min()
res1 = selected_bus * m[selected_bus]
IO.inspect(res1)

## Part 2
b = strBuses
    |> String.split(",", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {x, _} -> x != "x" end)
    |> Enum.map(fn {x, idx} -> {String.to_integer(x), idx} end)


res2 = Day13.findEarliest(b)
IO.inspect(res2)

res3 = Day13.bruteForceCongruence(b, 500000000000000)
IO.inspect(res3)