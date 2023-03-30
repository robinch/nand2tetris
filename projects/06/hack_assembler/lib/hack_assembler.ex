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
    Stream.transform(parsed_lines, 0, fn
      %Parser.Label{name: name}, n ->
        SymbolTable.add_label(name, n + 1)
        {[], n + 1}

      line, n ->
        {[line], n + 1}
    end)
  end

  def second_pass(parsed_lines) do
    Stream.transform(parsed_lines, 0, fn
      %Parser.AInstruction{address: addr}, address ->
        {[MachineCode.a_instruction(addr)], address}

      %Parser.CInstruction{dest: dest, comp: comp, jump: jump}, address ->
        {[MachineCode.c_instruction(dest, comp, jump)], address}
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
