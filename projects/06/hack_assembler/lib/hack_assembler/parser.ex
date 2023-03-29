defmodule HackAssembler.Parser do
  alias HackAssembler.Parser

  def parse!("//" <> comment), do: %Parser.Comment{content: comment}
  def parse!("@" <> address), do: %Parser.AInstruction{address: address}
  def parse!(line), do: line
end
