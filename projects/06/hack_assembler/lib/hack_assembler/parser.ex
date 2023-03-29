defmodule HackAssembler.Parser do
  alias HackAssembler.Parser

  def parse!("//" <> comment), do: %Parser.Comment{content: comment}
  def parse!("@" <> address), do: %Parser.AInstruction{address: address}

  def parse!(line) do
    {c_instruction, rest} =
      case String.split(line, "=") do
        [dest, rest] -> {%Parser.CInstruction{dest: dest}, rest}
        [rest] -> {%Parser.CInstruction{}, rest}
      end

    case String.split(rest, ";") do
      [comp, jump] -> %{c_instruction | comp: comp, jump: jump}
      [comp] -> %{c_instruction | comp: comp}
    end
  end
end
