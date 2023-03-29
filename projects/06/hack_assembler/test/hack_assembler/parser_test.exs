defmodule HackAssembler.ParserTest do
  use ExUnit.Case

  alias HackAssembler.Parser

  test "parse comment" do
    assert Parser.parse!("// This is a comment") == %Parser.Comment{content: " This is a comment"}
  end
end
