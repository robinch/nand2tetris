defmodule HackAssembler.MachineCode do
  def a_instruction(address) do
    bin_address =
      address
      |> to_binary()
      |> String.slice(3, 13)

    "000" <> bin_address
  end

  defp to_binary(number) when is_binary(number) do
    val = String.to_integer(number)

    {_val, binary} =
      Enum.reduce(15..0, {val, _binary = ""}, fn
        n, {val, binary} ->
          case val >= 2 ** n do
            true -> {val - 2 ** n, binary <> "1"}
            false -> {val, binary <> "0"}
          end
      end)

    binary
  end
end
