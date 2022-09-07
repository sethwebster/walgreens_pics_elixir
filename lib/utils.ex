defmodule WalgreensPicsElixir.Utils do
  def die(_) do
    IO.puts("Dying")
    exit(:normal)
  end
end
