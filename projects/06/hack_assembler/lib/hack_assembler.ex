defmodule HackAssembler do
  alias HackAssembler.{MachineCode, Parser}

  def assemble(file_path) do
    File.stream!(file_path)
    |> remove_spaces_and_empty_lines()
    |> Stream.map(fn line ->
      case Parser.parse!(line) do
        %Parser.Comment{} ->
          :no_instruction

        %Parser.AInstruction{address: address} ->
          MachineCode.a_instruction(address)

        %Parser.CInstruction{dest: dest, comp: comp, jump: jump} ->
          MachineCode.c_instruction(dest, comp, jump)
      end
    end)
    |> Stream.reject(&(&1 == :no_instruction))
    |> Stream.map(&(&1 <> "\n"))
    |> Enum.into(File.stream!(destination_path(file_path)))

    :ok
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
