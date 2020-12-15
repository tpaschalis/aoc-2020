# tpaschalis 2020-12-14
# Advent of Code 2020 - Day 14

## This is probably some of the most mangled code I've written all year long. Seriously.
## But hey, it's Christmas, and I'm in no mood to refactor right now, I may get to it later.

# {:ok, input} = File.read("input.sample.1")
# {:ok, input} = File.read("input.sample.2")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n", trim: true)

defmodule Day14 do
    def parseMask(l) do
        hd(String.split(l, "mask = ", trim: true))
    end

    def parseMem(l) do
        String.split(l, ["mem[", "] = "], trim: true) |> Enum.map(&String.to_integer/1)
    end

    def toBinary(n) do
        String.pad_leading(Integer.to_string(n, 2), 36, "0")
    end

    def applyMask(m, b) do
        lb = String.graphemes(b)
        for {n, idx} <- m 
            |> String.graphemes()
            |> Enum.with_index()
            do
                cond do
                    n == "X" -> 
                        Enum.at(lb, idx)
                    n == "0" -> 
                        "0"
                    n == "1" -> 
                        "1"
                end
            end
            |> Enum.join("")
    end

    def processInput([h | t], mask, memory) do
        cond do
            String.contains?(h, "mask") -> 
                m = parseMask(h)
                processInput(t, m, memory)
            String.contains?(h, "mem") -> 
                [h1 | t1] = parseMem(h)
                res = applyMask(mask, toBinary(hd(t1)))
                processInput(t, mask, Map.put(memory, h1, res))
        end
    end

    def processInput([], _, memory) do
        Enum.reduce(memory, 0,
            fn ({_, v}, acc) -> 
                n = String.to_integer(v, 2)
                acc + n
            end)
    end

    def generatePermutations(n) do
        Enum.filter(
            n |> String.graphemes() |> Enum.with_index(),
            fn {x, _} ->
                x == "X"
            end
        )
        |> Enum.map(
            fn {_, idx} -> 
                Integer.to_string(Bitwise.bsl(1, 35-idx), 10)
            end
        )
    end

    ## Directly off Rosetta Code
    def comb(0, _), do: [[]]
    def comb(_, []), do: []
    def comb(m, [h|t]) do
        (for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
    end

    def getNested([h | t], l) do
        getNested(t, l ++ h)
    end

    def getNested([], l) do
        Enum.map(
            l, 
            fn x -> 
                Enum.map(
                    x, 
                    fn e ->
                        String.to_integer(e)
                    end
                ) |> Enum.sum()
            end
        )
    end

    def applyMaskPt2(m, b) do
        lb = String.graphemes(b)
        for {n, idx} <- m 
            |> String.graphemes()
            |> Enum.with_index()
            do
                cond do
                    n == "X" -> 
                        "X"
                    n == "0" -> 
                        Enum.at(lb, idx)
                    n == "1" -> 
                        "1"
                end
            end
            |> Enum.join("")
    end
    
    def processInputPt2([h | t], mask, memory) do
        cond do
            String.contains?(h, "mask") -> 
                m = parseMask(h)
                processInputPt2(t, m, memory)
            String.contains?(h, "mem") -> 
                [h1 | t1] = parseMem(h)
                baseMask = applyMaskPt2(mask, toBinary(h1))
                p = generatePermutations(baseMask)
                combinations = Enum.map(
                    1..length(p),
                    fn x -> 
                        comb(x, p)
                    end
                )
                n = getNested(combinations, [["0"]])
                minValue = String.to_integer(String.replace(baseMask, "X", "0"), 2)
                updatedAddresses = for x <- n, into: %{}, do: {minValue + x, hd(t1)}
                processInputPt2(t, mask, Map.merge(memory, updatedAddresses))
        end
    end

    def processInputPt2([], _, memory) do
        Enum.reduce(memory, 0,
            fn ({_, v}, acc) -> 
                acc + v
            end
        )
    end
end

Day14.processInput(lines, "", %{}) |> IO.inspect()
Day14.processInputPt2(lines, "", %{}) |> IO.inspect()
