# tpaschalis 2020-12-01
# Advent of Code 2020 - Day 01

## Notes
# https://stackoverflow.com/questions/49535735/whats-the-shortest-way-to-count-substring-occurrence-in-string-elixir
# String interpolation ("for inputs min:#{min}, max:#{max}, letter:#{letter} password:#{password} -- count:#{count}")


defmodule Day2 do
    def isPasswordValid?(min, max, letter, password) do
        count = password|> String.graphemes |> Enum.count(& &1 == letter)
        count >= min && count <= max
    end

    def isPasswordValidPt2?(p1, p2, letter, password) do
        s1 = String.at(password, p1-1)
        s2 = String.at(password, p2-1)
        case {s1 == letter, s2 == letter} do
            {true, true} ->  false
            {false, false} -> false
            {true, false} -> true
            {false, true} -> true
        end
    end


    def parseLine(line) do
        line |> String.split(["-", " ", ": "])
    end

    def pair(lst) do 
        keys = [:min, :max, :letter, :password]
        Enum.zip(keys, lst) |> Enum.into(%{})
    end
end

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")
lines = input 
    |> String.split("\n", trim: true) 

# Part 1
res1 = Enum.count(
    lines, 
    fn l -> 
        p = Day2.parseLine(l) |> Day2.pair()
        Day2.isPasswordValid?(
            String.to_integer(p[:min]), 
            String.to_integer(p[:max]), 
            p[:letter], 
            p[:password]
        )
    end
)
IO.inspect(res1)

# Part 2
res2 = Enum.count(
    lines, 
    fn l -> 
        p = Day2.parseLine(l) |> Day2.pair()
        Day2.isPasswordValidPt2?(
            String.to_integer(p[:min]), 
            String.to_integer(p[:max]), 
            p[:letter], 
            p[:password]
        )
    end
)
IO.inspect(res2)
