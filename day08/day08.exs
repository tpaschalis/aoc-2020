# tpaschalis 2020-12-08
# Advent of Code 2020 - Day 08

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

# Improvements
# `operations` could be a map, instead of a list containing maps, which is silly
operations = input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(
        fn {l, idx} ->
            [op | arg] = String.split(l, " ", trim: true)
            {num, _} = Integer.parse(hd(arg))
            %{"ord" => idx, "op" => op,  "arg" => num}
        end
    )

defmodule Day8 do
    def executePt1(ops, curr, acc, visited) do
        case Enum.find(visited, fn x -> x == curr["ord"] end) do
            nil -> 
                case curr["op"] do
                    "nop" -> 
                        next = Enum.at(ops, curr["ord"] + 1)
                        executePt1(ops, next, acc, visited ++ [curr["ord"]] )
                    "jmp" ->
                        next = Enum.at(ops, curr["ord"] + curr["arg"])
                        executePt1(ops, next, acc, visited ++ [curr["ord"]] )
                    "acc" -> 
                        next = Enum.at(ops, curr["ord"] + 1)
                        executePt1(ops,next, acc + curr["arg"], visited ++ [curr["ord"]] )
                    _ -> 
                        IO.inspect("Pt2 : #{acc}")
                end
            _ -> 
                acc
        end
    end
    
    def replaceOp(input) do
        case input["op"] do
            "nop" -> 
                %{"ord" => input["ord"], "op" => "jmp",  "arg" => input["arg"]}
            "jmp" -> 
                %{"ord" => input["ord"], "op" => "nop",  "arg" => input["arg"]}
            nil -> 
                true
        end
    end
end

res1 = Day8.executePt1(operations, Enum.at(operations, 0), 0, [])
IO.inspect("Pt1 : #{res1}")

jmp_nop_ops = Enum.filter(operations, fn l -> l["op"] == "jmp" || l["op"] == "nop" end)

all_possible_inputs = Enum.map(jmp_nop_ops, 
    fn l -> 
        newOp = Day8.replaceOp(l)
        List.replace_at(operations, l["ord"], newOp)
    end
)
for i <- all_possible_inputs, do: Day8.executePt1(i, Enum.at(i, 0), 0, [])


