# tpaschalis 2020-12-12
# Advent of Code 2020 - Day 12

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

defmodule Day12 do
    def parseDirections(l) do
        {action, value} = String.split_at(l, 1)
        {action, String.to_integer(value)}
    end

    def performManoeuvre([h | t], facing, ew, ns) do
        {action, value} = h
        case action do
            "E" -> 
                performManoeuvre(t, facing, ew+value, ns)
            "W" -> 
                performManoeuvre(t, facing, ew-value, ns)
            "N" -> 
                performManoeuvre(t, facing, ew, ns+value)
            "S" -> 
                performManoeuvre(t, facing, ew, ns-value)
            "F" -> 
                case facing do
                    "E" -> 
                        performManoeuvre(t, facing, ew+value, ns)
                    "W" -> 
                        performManoeuvre(t, facing, ew-value, ns)
                    "N" -> 
                        performManoeuvre(t, facing, ew, ns+value)
                    "S" -> 
                        performManoeuvre(t, facing, ew, ns-value)
                end
            d when d in ["L", "R"] -> 
                newDirection = determineDirection(facing, d, value)
                performManoeuvre(t, newDirection, ew, ns)
        end
    end

    def performManoeuvre([], facing, ew, ns) do
        abs(ew) + abs(ns)
    end

    def determineDirection(facing, d, value) do
        cwDirs = %{0 => "E", 1 => "S", 2 => "W", 3 => "N"}
        ccwDirs = %{0 => "E", 1 => "N", 2 =>  "W", 3 =>  "S"}
        case d do
            "R" -> 
                idx = cwDirs |> Enum.find(fn {_, val} -> val == facing end) |> elem(0)
                newidx = rem(round(idx + value/90), 4)
                cwDirs[newidx]
            "L" -> 
                idx = ccwDirs |> Enum.find(fn {_, val} -> val == facing end) |> elem(0)
                newidx = rem(round(idx + value/90), 4)
                ccwDirs[newidx]
        end
    end

end

lines = input |> String.split("\n", trim: true) |> Enum.map(fn l -> Day12.parseDirections(l) end) |> IO.inspect()

Day12.performManoeuvre(lines, "E", 0, 0) |> IO.inspect()

# Day12.determineDirection("S", "L", 90) |> IO.inspect()
# Day12.determineDirection("S", "L", 180) |> IO.inspect()
# Day12.determineDirection("S", "L", 270) |> IO.inspect()
# Day12.determineDirection("S", "L", 360) |> IO.inspect()