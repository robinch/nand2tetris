defmodule HackAssembler.MachineCodeTest do
  use ExUnit.Case, async: true

  alias HackAssembler.MachineCode

  test "A instruction" do
    assert MachineCode.a_instruction("123") == "0000000001111011"
  end

  test "C instruction" do
    assert MachineCode.c_instruction("AD", "D+1", "JEQ") == "1110011111110010"
  end
end
