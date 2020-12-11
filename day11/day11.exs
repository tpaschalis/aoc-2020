# tpaschalis 2020-12-11
# Advent of Code 2020 - Day 11

# {:ok, input} = File.read("input.sample")
{:ok, input} = File.read("input.txt")

defmodule Day11 do

    def from_list(list) when is_list(list) do
        do_from_list(list)
    end

    # 2-D map
    # https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/
    defp do_from_list(list, map \\ %{}, index \\ 0)
    defp do_from_list([], map, _index), do: map
    defp do_from_list([h|t], map, index) do
        map = Map.put(map, index, do_from_list(h))
        do_from_list(t, map, index + 1)
    end
    defp do_from_list(other, _, _), do: other

    def to_list(matrix) when is_map(matrix) do
        do_to_list(matrix)
    end

    defp do_to_list(matrix) when is_map(matrix) do
        for {_index, value} <- matrix,
        into: [],
        do: do_to_list(value)
    end

    defp do_to_list(other), do: other

    def occupiedNeighbors(grid, x, y) do
        Enum.count(
            [
            grid[x-1][y-1],
            grid[x-1][y],
            grid[x-1][y+1],
            grid[x][y-1],
            grid[x][y+1],
            grid[x+1][y-1],
            grid[x+1][y],
            grid[x+1][y+1]
            ],
            fn n -> 
                n == "#"
            end
        )
    end

    def lineOfSightNeighbors(grid, x, y) do
        scanRight(grid, x, y) + 
        scanLeft(grid, x, y) + 
        scanUp(grid, x, y) + 
        scanDown(grid, x, y) + 
        scanUpperLeft(grid, x, y) + 
        scanUpperRight(grid, x, y) + 
        scanLowerLeft(grid, x, y) + 
        scanLowerRight(grid, x, y)
    end

    defp scanRight(grid, x, y) do
        case grid[x+1][y] do
            "." -> 
                scanRight(grid, x+1, y)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanLeft(grid, x, y) do
        case grid[x-1][y] do
            "." -> 
                scanLeft(grid, x-1, y)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanUp(grid, x, y) do
        case grid[x][y-1] do
            "." -> 
                scanUp(grid, x, y-1)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanDown(grid, x, y) do
        case grid[x][y+1] do
            "." -> 
                scanDown(grid, x, y+1)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanUpperLeft(grid, x, y) do
        case grid[x-1][y-1] do
            "." -> 
                scanUpperLeft(grid, x-1, y-1)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanUpperRight(grid, x, y) do
        case grid[x+1][y-1] do
            "." -> 
                scanUpperRight(grid, x+1, y-1)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanLowerLeft(grid, x, y) do
        case grid[x-1][y+1] do
            "." -> 
                scanLowerLeft(grid, x-1, y+1)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    defp scanLowerRight(grid, x, y) do
        case grid[x+1][y+1] do
            "." -> 
                scanLowerRight(grid, x+1, y+1)
            "L" -> 
                0
            "#" -> 
                1
            nil -> 
                0
        end
    end

    def nextRound(grid) do
        nrows = 90
        ncol = 95
        res = Enum.map(
            0..nrows-1,
            fn x ->
                Enum.map(
                    0..ncol-1,
                    fn y -> 
                        case grid[x][y] do
                            "." -> 
                                "."
                            "L" -> 
                                # n = Day11.occupiedNeighbors(grid, x, y)       ## Part 1
                                n = Day11.lineOfSightNeighbors(grid, x, y)      ## Part 2
                                if n == 0 do
                                    "#"
                                else 
                                    "L"
                                end
                            "#" -> 
                                # n = Day11.occupiedNeighbors(grid, x, y)       ## Part 1
                                n = Day11.lineOfSightNeighbors(grid, x, y)      ## Part 2
                                if n >= 5 do
                                    "L"
                                else
                                    "#"
                                end
                        end
                    end
                )
            end
        )
        g = from_list(res)
        cond do
            g == grid -> 
                grid
            res != grid ->
                nextRound(g)
        end
    end
end

## Setup
lines = Enum.map(
    input |> String.split("\n", trim: true),
    fn row -> 
        row |> String.graphemes()
    end
)

## Both Parts
grid = Day11.from_list(lines)
stable_state = Day11.nextRound(grid)
Day11.to_list(stable_state) |> List.flatten() |> Enum.count(fn seat -> seat == "#" end) |> IO.inspect()