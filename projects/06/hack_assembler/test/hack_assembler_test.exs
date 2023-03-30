defmodule HackAssemblerTest do
  use ExUnit.Case, async: true

  doctest HackAssembler

  describe "without symbos" do
    test "Add" do
      test_assembler("Add")
    end

    test "MaxL" do
      test_assembler("MaxL")
    end

    test "RectL" do
      test_assembler("RectL")
    end

    test "PongL" do
      test_assembler("PongL")
    end
  end

  # describe "with symbos" do
  #   test "Max" do
  #     test_assembler("Max")
  #   end
  # end

  defp test_assembler(base_file_name) do
    assert :ok = HackAssembler.assemble("test/support/#{base_file_name}.asm")

    expected = File.stream!("test/support/#{base_file_name}_expected.hack")
    result = File.stream!("test/support/#{base_file_name}.hack")

    for {exp, res} <- Enum.zip(expected, result) do
      assert exp == res
    end
  end
end
