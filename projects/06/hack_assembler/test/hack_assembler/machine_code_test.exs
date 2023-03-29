defmodule HackAssembler.MachineCodeTest do
  use ExUnit.Case

  alias HackAssembler.MachineCode

  test "A instruction" do
    assert MachineCode.a_instruction("123") == "0000000001111011"
  end
end
