defmodule WalgreensPicsElixir.Persistence do
  def persist_asset_data(data) do
    File.write!("_inprogress.bin", :erlang.term_to_binary(data))
    data
  end

  def load_asset_data do
    :erlang.binary_to_term(File.read!("_inprogress.bin"))
  end
end
