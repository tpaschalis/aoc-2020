# tpaschalis 2020-12-22
# Advent of Code 2020 - Day 22

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

[p1, p2 | _] = input |> String.split("\n\n", trim: true)
player1  = p1 |> String.split("\n", trim: true) |> tl() |> Enum.map(&String.to_integer/1)
player2  = p2 |> String.split("\n", trim: true) |> tl() |> Enum.map(&String.to_integer/1)

defmodule Day22 do
    
    def play([h1 | t1], [h2 | t2]) do
        cond do
            h1 > h2 -> play(t1 ++ [h1] ++ [h2], t2)
            h1 < h2 -> play(t1, t2 ++ [h2] ++ [h1])
        end
    end
    def play(p1, []) do {"p1", score(p1)} end
    def play([], p2) do {"p2", score(p2)} end

    def recursiveCombat([h1 | t1], [h2 | t2], previousRounds) do
        deck1 = [h1 | t1]
        deck2 = [h2 | t2]
        cond do
            # Same configuration in previous round, P1 wins!
            Enum.member?(previousRounds, {deck1, deck2}) -> recursiveCombat(deck1, [], previousRounds)
            # Drawing, let's play a sub-game of Recursive Combat!
            length(t1) >= h1 and length(t2) >= h2 -> 
                subdeck1 = Enum.slice(t1, 0..h1-1)
                subdeck2 = Enum.slice(t2, 0..h2-1)
                {winner, _} = recursiveCombat(subdeck1, subdeck2, [])
                cond do
                    winner == "p1" -> recursiveCombat(t1 ++ [h1] ++ [h2], t2, previousRounds ++ [{deck1, deck2}])
                    winner == "p2" -> recursiveCombat(t1, t2 ++ [h2] ++ [h1], previousRounds ++ [{deck1, deck2}])
                end
            # We don't have enough cards to draw, evaluate with familiar Combat rules
            true ->
                cond do
                    h1 > h2 -> recursiveCombat(t1 ++ [h1] ++ [h2], t2, previousRounds ++ [{deck1, deck2}])
                    h1 < h2 -> recursiveCombat(t1, t2 ++ [h2] ++ [h1], previousRounds ++ [{deck1, deck2}])
                end
        end
    end
    def recursiveCombat(p1, [], _) do {"p1", score(p1)} end
    def recursiveCombat([], p2, _) do {"p2", score(p2)} end

    def score(deck) do
        deck |> Enum.reverse |> Enum.with_index |> Enum.reduce(0, fn({card, idx}, acc) -> acc + (card * (idx+1)) end)
    end
end

Day22.play(player1, player2) |> IO.inspect()
Day22.recursiveCombat(player1, player2, []) |> IO.inspect()