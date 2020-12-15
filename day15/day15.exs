# tpaschalis 2020-12-15
# Advent of Code 2020 - Day 15

defmodule Day15 do
    def takeTurn(curr, currentTurn, memory) do
        cond do
            # currentTurn == 2020 ->
            currentTurn == 30_000_000 ->
                curr
            memory[curr] == nil ->
                takeTurn(0, currentTurn+1, Map.put(memory, curr, currentTurn))
            memory[curr] != nil ->
                takeTurn(currentTurn - memory[curr], currentTurn+1, Map.put(memory, curr, currentTurn))
        end
    end
end

{:ok, input} = File.read("input.txt")
nums = input |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) |> IO.inspect()

mem = for {x, idx} <- Enum.with_index(nums), into: %{}, do: {x, idx+1} 
Day15.takeTurn(18, 7, mem) |> IO.inspect() # Small cheat, the last number appearing on the input

