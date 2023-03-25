defmodule HackAssembler do
  def assemble(file_path) do
    destination_path(file_path)
  end

  defp destination_path(source_file_path) do
    file_name = Path.basename(source_file_path, ".asm")
    path = Path.dirname(source_file_path)
    "#{path}/#{file_name}.hack"
    
  end
end
