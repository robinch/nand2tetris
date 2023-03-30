defmodule HackAssembler.ParserTest do
  use ExUnit.Case

  alias HackAssembler.Parser

  test "parse comment" do
    assert Parser.parse!("// This is a comment") == %Parser.Comment{content: " This is a comment"}
  end

  describe "parse a-instruction" do
    test "non-symbolic" do
      assert Parser.parse!("@123") == %Parser.AInstruction{address: "123", symbolic: false}
    end

    test "symbolic" do
      assert Parser.parse!("@var") == %Parser.AInstruction{address: "var", symbolic: true}
    end
  end

  describe "parse C-Instruction" do
    test "dest=comp;jump" do
      assert Parser.parse!("ADM=D+1;JEQ") == %Parser.CInstruction{
               dest: "ADM",
               comp: "D+1",
               jump: "JEQ"
             }
    end

    test "comp;jump" do
      assert Parser.parse!("0;JMP") == %Parser.CInstruction{comp: "0", jump: "JMP"}
    end

    test "dest=comp" do
      assert Parser.parse!("AD=D") == %Parser.CInstruction{dest: "AD", comp: "D"}
    end
  end
end
