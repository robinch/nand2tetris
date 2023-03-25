defmodule HackAssemblerTest do
  use ExUnit.Case
  doctest HackAssembler

  test "Add" do
     assert :ok = HackAssembler.assemble("test/support/Add.asm")
  end
end
