# tpaschalis 2020-12-16
# Advent of Code 2020 - Day 16

# {:ok, input} = File.read("input.sample.1")
# {:ok, input} = File.read("input.sample.2")
{:ok, input} = File.read("input.txt")

blocks = input |> String.split("\n\n", trim: true)


## Block 0
b = Enum.at(blocks, 0) |> String.split("\n", trim: true)
ruleSet = Enum.map(
    b, 
    fn r -> 
        f = r |> String.split([": ", "-", " or "])
        name = hd(f)
        nums = tl(f) |> Enum.map(&String.to_integer/1)
        range = (Enum.at(nums, 0)..Enum.at(nums, 1) |> Enum.to_list) ++ (Enum.at(nums, 2)..Enum.at(nums, 3) |> Enum.to_list)
        {name, range}
    end
) |> Enum.into(%{})

## Block 1
[_, b|_] = Enum.at(blocks, 1) |> String.split("\n", trim: true)
our_ticket = b |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)

## Block 2
b = Enum.at(blocks, 2) |> String.split("\n", trim: true)
nearby_tickets = Enum.map(tl(b), fn t -> t |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) end)

defmodule Day16 do
    def scanErrorRate(ticket, ruleset) do
        Enum.filter(
            ticket,
            fn num -> 
                0 == Enum.count(ruleset, fn {_, v} -> Enum.member?(v, num) end)
            end
        ) |> Enum.sum()
    end

    def discardInvalidTickets(tickets, ruleset) do
        Enum.filter(
            tickets,
            fn t ->
                scanErrorRate(t, ruleset) == 0
            end
        )       
    end

    def transpose(rows) do
        rows
        |> List.zip
        |> Enum.map(&Tuple.to_list/1)
    end 
end


## Part 1
res1 = Enum.map(nearby_tickets, fn ticket -> Day16.scanErrorRate(ticket, ruleSet) end) |> Enum.sum()
IO.inspect(res1)

## Part 2
## I suspect that only one column is matching for each departure line/
## So I'll transpose the valid tickets, find the valid lines and fetch the correct fields.
valid_tickets = Day16.discardInvalidTickets(nearby_tickets, ruleSet)
tickets_transposed = Day16.transpose(valid_tickets)

Enum.map(
    Map.keys(ruleSet),
    fn field -> 
        possible_columns = Enum.filter(
            Enum.with_index(tickets_transposed),
            fn {c, idx} -> 
                0 == Day16.scanErrorRate(c, %{field => ruleSet[field]})
            end
            ) |> Enum.map(fn {_, pos} -> pos end)
        {field, possible_columns}
    end
)|> IO.inspect(charlists: :as_lists)

# I got the rest of Pt2 through with pen-and-paper as I didn't have 
# more time.. May revisit in the future