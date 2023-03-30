defmodule HackAssembler do
  alias HackAssembler.{MachineCode, Parser, SymbolTable}

  def assemble(file_path) do
    {:ok, _} = SymbolTable.start_link()

    file_path
    |> File.stream!()
    |> remove_spaces_and_empty_lines()
    |> Stream.map(&Parser.parse!/1)
    |> Stream.reject(&is_struct(&1, Parser.Comment))
    |> first_pass()
    |> second_pass()
    |> Stream.map(&(&1 <> "\n"))
    |> Enum.into(File.stream!(destination_path(file_path)))

    :ok
  end

  def first_pass(parsed_lines) do
    {lines, _} =
      Enum.reduce(parsed_lines, {_lines = [], _start_address = 0}, fn
        %Parser.Label{name: name}, {lines, n} ->
          SymbolTable.add_label(name, Integer.to_string(n))
          {lines, n}

        line, {lines, n} ->
          {[line | lines], n + 1}
      end)

    Enum.reverse(lines)
  end

  def second_pass(parsed_lines) do
    Stream.map(parsed_lines, fn
      %Parser.AInstruction{address: address, symbolic: false} ->
        MachineCode.a_instruction(address)

      %Parser.AInstruction{address: symbolic_address, symbolic: true} ->
        if not SymbolTable.contains?(symbolic_address) do
          SymbolTable.add_var(symbolic_address)
        end

        address = SymbolTable.get_address(symbolic_address)

        MachineCode.a_instruction(address)

      %Parser.CInstruction{dest: dest, comp: comp, jump: jump} ->
        MachineCode.c_instruction(dest, comp, jump)
    end)
  end

  defp destination_path(source_file_path) do
    file_name = Path.basename(source_file_path, ".asm")
    path = Path.dirname(source_file_path)
    "#{path}/#{file_name}.hack"
  end

  defp remove_spaces_and_empty_lines(lines) do
    lines
    |> Stream.map(fn line ->
      line =
        line
        |> String.replace("\n", "")
        |> String.trim()

      line
    end)
    |> Stream.reject(&(&1 == ""))
  end
end
