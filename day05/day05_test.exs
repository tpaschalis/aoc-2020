ExUnit.start()
## use elixirc day05.exs to compile the BEAM file 

defmodule Day5Test do
    use ExUnit.Case
    doctest Day5

    test "locateDim" do
        assert "1000110111" == Day5.locateDim("BFFFBBFRRR")
        assert "0001110111" == Day5.locateDim("FFFBBBFRRR")
        assert "1100110100" == Day5.locateDim("BBFFBBFRLL")
    end

    test "splitPassport" do
        assert %{"col" => "111", "row" => "1000110"} == Day5.splitPassport("BFFFBBFRRR")
        assert %{"col" => "111", "row" => "0001110"} == Day5.splitPassport("FFFBBBFRRR")
        assert %{"col" => "100", "row" => "1100110"} == Day5.splitPassport("BBFFBBFRLL")
    end

    test "seatId" do
        assert 567 == Day5.seatId(%{"col" => "111", "row" => "1000110"})
        assert 119 == Day5.seatId(%{"col" => "111", "row" => "0001110"})
        assert 820 == Day5.seatId(%{"col" => "100", "row" => "1100110"})
    end

end