defmodule HackAssemblerTest do
  use ExUnit.Case
  doctest HackAssembler

  test "Add" do
    assert :ok = HackAssembler.assemble("test/support/Add.asm")
    expected = File.stream!("test/support/Add_expected.hack")
    result = File.stream!("test/support/Add.hack")

    for {exp, res} <- Enum.zip(expected, result) do
      assert exp == res
    end
  end
end
