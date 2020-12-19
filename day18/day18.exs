# tpaschalis 2020-12-18
# Advent of Code 2020 - Day 18

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

defmodule Day18 do
    def evaluateExpression(expr) do
        cond do
        mp(expr) == "" -> computePt2(expr) # computePt1(expr)
        
        mp(expr) != "" ->
            calc = evaluateExpression(mp(expr))
            parens = "(" <>  mp(expr) <> ")"
            evaluateExpression(String.replace(expr, parens, Integer.to_string(calc.value)))
        end
    end

    def computePt1(expr) do
        expr 
        |> String.split(" ")
        |> Enum.reduce(
            %{operand: "+", value: 0}, 
            fn e, acc ->
                case Integer.parse(e) do
                    {num, _} -> 
                        case acc.operand do
                            "*" -> %{operand: acc.operand, value: acc.value * num}
                            "+" -> %{operand: acc.operand, value: acc.value + num}
                        end
                    :error -> %{operand: e, value: acc.value}
                end
            end)
    end

    def computePt2(expr) do
        res = Enum.reduce(
            expr 
            |> String.replace(" ", "")
            |> String.split("*"),
            1,
            fn x, acc ->
                r =  x |> String.split("+") |> Enum.map(&String.to_integer/1) |> Enum.sum() 
                acc * r
            end)
        %{value: res}
    end

    # https://stackoverflow.com/a/42265288
    defp mp(<<"(", rest::binary>>) do
        remaining = byte_size(mp(rest, 0))
        binary_part(rest, 0, byte_size(rest) - remaining)
    end
    defp mp(<<_::utf8, rest::binary>>), do: mp(rest)
    defp mp(<<")", _::binary>> = rest, 0), do: rest
    defp mp(<<")", rest::binary>>, n), do: mp(rest, n - 1)
    defp mp(<<"(", rest::binary>>, n), do: mp(rest, n + 1)
    defp mp(<<_::utf8, rest::binary>>, n), do: mp(rest, n)
    defp mp(expr), do: expr
end

res = input 
|> String.split("\n", trim: true) 
|> Enum.map(fn line -> res = Day18.evaluateExpression(line); res.value end)
|> Enum.sum() |> IO.inspect()
