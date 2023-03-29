defmodule HackAssembler.Parser do
  alias HackAssembler.Parser

  def parse!("//" <> comment), do: %Parser.Comment{content: comment}
 
  def parse!(line), do: line
end
