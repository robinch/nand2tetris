defmodule HackAssembler.MachineCode do
  def a_instruction(address) do
    bin_address =
      address
      |> to_binary()
      |> String.slice(1, 15)

    "0" <> bin_address
  end

  def c_instruction(dest, comp, jump) do
    prefix = "111"
    a = comp |> String.contains?("M") |> bool_to_bit()
    dest = dest(dest)
    comp = comp(comp)
    jump = jump(jump)

    prefix <> a <> comp <> dest <> jump
  end


  defp dest(nil), do: "000"

  defp dest(dest) do
    bit_0 = dest |> String.contains?("M") |> bool_to_bit()
    bit_1 = dest |> String.contains?("D") |> bool_to_bit()
    bit_2 = dest |> String.contains?("A") |> bool_to_bit()

    bit_2 <> bit_1 <> bit_0
  end

  def jump(jump) do
    case jump do
      nil -> "000"
      "JGT" -> "001"
      "JEQ" -> "010"
      "JGE" -> "011"
      "JLT" -> "100"
      "JNE" -> "101"
      "JLE" -> "110"
      "JMP" -> "111"
    end
  end

  def comp(comp) do
    case comp do
      "0" -> "101010"
      "1" -> "111111"
      "-1" -> "111010"
      "D" -> "001100"
      "A" -> "110000"
      "M" -> "110000"
      "!D" -> "001101"
      "!A" -> "110001"
      "!M" -> "110001"
      "-D" -> "001111"
      "-A" -> "110011"
      "-M" -> "110011"
      "D+1" -> "011111"
      "A+1" -> "110111"
      "M+1" -> "110111"
      "D-1" -> "001110"
      "A-1" -> "110010"
      "M-1" -> "110010"
      "D+A" -> "000010"
      "D+M" -> "000010"
      "D-A" -> "010011"
      "D-M" -> "010011"
      "A-D" -> "000111"
      "M-D" -> "000111"
      "D&A" -> "000000"
      "D&M" -> "000000"
      "D|A" -> "010101"
      "D|M" -> "010101"
    end
  end

  defp bool_to_bit(true), do: "1"
  defp bool_to_bit(false), do: "0"

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
