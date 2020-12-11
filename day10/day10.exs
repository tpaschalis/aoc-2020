# tpaschalis 2020-12-10
# Advent of Code 2020 - Day 10

# {:ok, input} = File.read("input.smol")
# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.sort()

defmodule Day10 do
    def getDiffs([h | t], prev, ones, threes) do
        case h - prev do
            1 -> getDiffs(t, h, ones+1, threes)
            3 -> getDiffs(t, h, ones, threes+1)
        end
    end

    def getDiffs([], _, ones, threes), do: ones * (threes+1) # Our device is always +3 jolts

    def getSequence([h | t], prev, res) do
        getSequence(t, h, res ++ [h - prev])
    end

    def getSequence([], _, res), do: res

    ## Generalized any-acci
    ## https://rosettacode.org/wiki/Fibonacci_n-step_number_sequences#Elixir
    def anynacci(start_sequence, count) do
        n = length(start_sequence)
        anynacci(Enum.reverse(start_sequence), count-n, n)
    end

    def anynacci(seq, 0, _), do: Enum.reverse(seq)
    def anynacci(seq, count, n) do
        next = Enum.sum(Enum.take(seq, n))
        anynacci([next|seq], count-1, n)
    end

end

## Part 1
Day10.getDiffs(lines, 0, 0, 0) |> IO.inspect()

## Part 2
adapters = [0] ++ lines ++ [List.last(lines) + 3]
differences = Day10.getSequence(adapters, 0, [])

threes_with_indexes = Enum.filter(
    Enum.with_index(differences), 
    fn {adapter, _} -> adapter == 3 end
)
threes = Enum.map(threes_with_indexes,fn {_, idx} -> idx end)

tribonacci = Day10.anynacci([1, 1, 2], 5)

ddd = Enum.map(
    Day10.getSequence(threes, 0, []),
    fn seq -> Enum.at(tribonacci, seq-1) end
)

Enum.reduce(ddd, fn x, acc -> x * acc end) |> IO.inspect()
