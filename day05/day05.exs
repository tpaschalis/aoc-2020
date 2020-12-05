# tpaschalis 2020-12-05
# Advent of Code 2020 - Day 05

# stream = File.stream!("input.sample")
stream = File.stream!("input.txt")

lines = stream |> Enum.map(&String.trim/1)

defmodule Day5 do
    def getSeatId(p) do
        p
        |> String.replace(["F", "B", "L", "R"],
            fn
                z when z in ["F", "L"] -> "0"
                o when o in ["B", "R"] -> "1"
            end
        )
        |> Integer.parse(2)
        |> elem(0)
    end
end

res1 = lines |> Enum.map(fn l -> Day5.getSeatId(l) end) |> Enum.max()
IO.inspect(res1)

all_passes = lines |> Enum.map(fn l -> Day5.getSeatId(l) end)
min = all_passes |> Enum.min()
max = all_passes |> Enum.max()
res2 = Enum.to_list(min..max) -- all_passes
IO.inspect(res2)

#
### Initial Approach
#
# def splitPassport(p) do
    #     %{
    #         "row" => locateDim(p |> String.slice(0..6)),
    #         "col" => locateDim(p |> String.slice(7..10))
    #     }
    # end
    # def locateDim(d) do
    #     d |> String.replace(["F", "B", "L", "R"],
    #         fn
    #             z when z in ["F", "L"] -> "0"
    #             o when o in ["B", "R"] -> "1"
    #         end
    #     )
    # end
    # def seatId(s) do
    #     {c, _} = Integer.parse(s["col"], 2)
    #     {r, _} = Integer.parse(s["row"], 2)
    #     c + r * 8
# end