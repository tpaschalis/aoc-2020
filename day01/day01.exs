# tpaschalis 2020-12-01
# Advent of Code 2020 - Day 01

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
IO.inspect(lines)
IO.inspect((IEx.Info.info(lines)))

# Approach 1
res = for x <- lines, y <- lines, x+y == 2020, do: IO.puts(x*y)
IO.inspect(res)

res = for x <- lines, y <- lines, z <- lines, x+y+z == 2020, do: IO.puts(x*y*z)
IO.inspect(res)

# Approach 2
# For a more efficient approach, we only need each combination once.
# Didn't know how to produce the combinations, so copied this library, the rest was surprisingly easy!
# https://github.com/tallakt/comb/blob/master/lib/comb.ex
defmodule Comb do
    def combinations(enum, k) do
        List.last(do_combinations(enum, k))
        |> Enum.uniq
    end

    defp do_combinations(enum, k) do
        combinations_by_length = [[[]]|List.duplicate([], k)]

        list = Enum.to_list(enum)
        List.foldr list, combinations_by_length, fn x, next ->
            sub = :lists.droplast(next)
            step = [[]|(for l <- sub, do: (for s <- l, do: [x|s]))]
            :lists.zipwith(&:lists.append/2, step, next)
        end
    end
end

pairs = Comb.combinations(lines, 2)
trips = Comb.combinations(lines, 3)

ans1 = Enum.filter(pairs, fn(x) -> Enum.sum(x) == 2020 end) |> List.flatten |> Enum.reduce(fn x, acc -> x * acc end)
ans2 = Enum.filter(trips, fn(x) -> Enum.sum(x) == 2020 end) |> List.flatten |> Enum.reduce(fn x, acc -> x * acc end)
IO.inspect(ans1)
IO.inspect(ans2)
