# tpaschalis 2020-12-04
# Advent of Code 2020 - Day 04

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

lines = input |> String.split("\n\n", trim: true) |> Enum.map(fn x -> String.replace(x, "\n", " ", trim: true) end)

defmodule Day4 do
    def parseLine(line) do
        res = line |> String.split([" ", ":"], trim: true) |> Enum.chunk_every(2) |> Map.new(fn [k, v] -> {k, v} end)
        res
    end

    def isValidPt1?(passport) do
        required_fields = ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"]
        Enum.all?(required_fields, &Map.has_key?(passport, &1))
    end

    def isValidPt2?(passport) do
        required_fields = ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"]
        Enum.all?(required_fields, &Map.has_key?(passport, &1)) && 
            isValidDate?(passport["byr"], 1920, 2002) &&
            isValidDate?(passport["iyr"], 2010, 2020) && 
            isValidDate?(passport["eyr"], 2020, 2030) &&
            isHeight?(passport["hgt"]) && 
            isHairColor?(passport["hcl"]) && 
            isEyeColor?(passport["ecl"]) &&
            isValidPID?(passport["pid"])
    end
    
    def isHeight?(f) do
        {h, u} = Integer.parse(f)
        cond do
        u == "cm" && h >= 150 && h <= 193 -> 
            true
        u == "in" && h >= 59 && h <= 76 ->
            true
        true -> 
            false
        end
    end

    def isEyeColor?(ecl) do
        case ecl do
            c when c in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] ->
                true
            _ ->
                false
        end
    end

    def isValidDate?(d, min, max) do
        {h, ""} = Integer.parse(d)
        cond do
        h >= min && h <= max -> 
            true
        h >= min && h <= max ->
            true
        true -> 
            false
        end
    end

    def isValidPID?(pid) do
        Regex.match?(~r/\A[[:digit:]]{9}\z/, pid)
    end

    def isHairColor?(hcl) do
        Regex.match?(~r/\A#[a-f0-9]{6}\z/, hcl)
    end
end

res1 = Enum.count(lines, fn l -> p = Day4.parseLine(l); Day4.isValidPt1?(p) end)
IO.inspect(res1)

res2 = Enum.count(lines, fn l -> p = Day4.parseLine(l); Day4.isValidPt2?(p) end)
IO.inspect(res2)

# Guessed 190, 189 too high
# Guessed 179, too low (removed equal sign from greater/lesser than)
# Was 188, Passport ID should be *exactly* nine digits long.s