defmodule HackAssembler do
  def assemble(file_path) do
    File.stream!(file_path)
    |> Stream.map(fn line ->
      IO.puts(line)
      line
    end)
    |> Enum.into(
      File.stream!(destination_path(file_path))
    )

    :ok
  end

  defp destination_path(source_file_path) do
    file_name = Path.basename(source_file_path, ".asm")
    path = Path.dirname(source_file_path)
    "#{path}/#{file_name}.hack"
  end
end
