defmodule WalgreensPicsElixir do
  @moduledoc """
  Documentation for `WalgreensPicsElixir`.
  """
  import WalgreensPicsElixir.Console
  # import WalgreensPicsElixir.Utils
  import WalgreensPicsElixir.Persistence
  alias WalgreensPicsElixir.HTTP

  defp find_caption(user_tags) do
    item =
      user_tags
      |> Enum.find(fn tag -> tag["key"] == "caption" end)

    item
  end

  defp get_caption(user_tags) do
    user_tags
    |> find_caption()
    |> Map.get("value")
  end

  def download_all_files(files) do
    File.mkdir_p!("./downloads")

    base_path = "./downloads"

    files
    |> Enum.map(fn {date, albums} ->
      download_tasks =
        albums
        |> Enum.map(fn
          {:error, album_id, album_name, _url} ->
            IO.puts(red("Error downloading album #{album_name} (#{album_id})"))
            # IO.puts(red("URL: #{url}"))
            nil

          {name, files, album_id} ->
            local_base_path = "#{base_path}/#{date}/#{name}"

            File.mkdir_p!(local_base_path)

            files
            |> Enum.map(fn url ->
              Task.async(fn ->
                base_name = Path.basename(url)
                file_name = "#{local_base_path}/#{base_name}"

                result =
                  if !File.exists?(file_name) do
                    IO.puts("Downloading #{name} #{base_name}...")

                    case HTTPoison.get(url, recv_timout: 120_000, timeout: 120_000) do
                      {:ok, response} ->
                        File.write!(file_name, response.body)
                        {:ok, name, url, file_name, date, album_id}

                      {:error, %{reason: reason}} ->
                        IO.puts(
                          "Unable to download #{date} #{name} #{base_name} #{url}: #{reason}"
                        )

                        {:error, name, url, reason, date, album_id}
                    end
                  else
                    IO.puts(
                      green("Skipping") <> " (" <> yellow("exists") <> ") #{name} #{base_name}..."
                    )

                    {:ok, name, url, file_name, date, album_id}
                  end

                result
              end)
            end)
        end)
        |> List.flatten()

      download_tasks
      |> Enum.chunk_every(20)
      |> Enum.map(fn tasks ->
        tasks |> Task.await_many(120_000)
      end)
      |> List.flatten()
    end)
  end

  def get_albums(raw_data) do
    IO.puts("Getting albums...")

    albums =
      raw_data["entityMap"]
      |> Map.keys()
      |> Enum.map(fn k ->
        collection_list = raw_data["entityMap"][k]["collectionList"]

        album_and_name =
          collection_list
          |> Enum.map(fn album ->
            name = get_caption(album["userTags"])
            {name, album["id"], album["assetIdList"]}
          end)

        {k, album_and_name}
      end)

    IO.puts("Found #{Enum.count(albums)} albums")
    albums
  end

  # def fetch(url) do
  #   case HTTPoison.get(url) do
  #     {:ok, response} ->
  #       {:ok, Poison.decode!(response.body)}

  #     {:error, %{reason: reason}} ->
  #       {:error, reason}
  #   end
  # end
  defp get_assets_for_album(album_id, album_name) do
    IO.puts("Fetching assets for #{album_name} (#{album_id})")

    with {:ok, asset_data} <-
           HTTP.post(
             "https://photo.walgreens.com/library/request_api",
             %{
               req_service: "pict",
               type: "GET",
               version: "v2",
               url:
                 "collection/#{album_id}/assets?limit=10000&skip=0&sortOrder=ascending&sortCriteria=dateTaken"
             }
             |> Poison.encode!()
           ) do
      urls =
        asset_data.entities
        |> Enum.map(fn asset ->
          asset.files
          |> Enum.filter(fn file -> file.fileType == "HIRES" end)
          |> Enum.map(fn file ->
            file.url
          end)
        end)
        |> List.flatten()

      IO.puts("Found #{length(urls)} assets for #{album_name} (#{album_id})")
      {album_name, urls, album_id}
    else
      {:error, %{reason: reason, url: url}} ->
        IO.puts("Unable to fetch assets for #{album_name} (#{album_id}): #{reason} #{url}")
        {:error, album_id, album_name, url, reason}

      {:error, reason} ->
        IO.puts("Unable to fetch assets for #{album_name}: #{reason}")
        {:error, album_id, album_name, reason}
    end
  end

  defp get_assets_for_albums(collections) do
    collections
    |> Enum.map(fn {date, albums} ->
      albums
      |> Enum.map(fn {album_name, album_id, _album_assets} ->
        Task.async(fn -> {date, get_assets_for_album(album_id, album_name)} end)
      end)
      |> Task.await_many(120_000)
      |> Enum.reduce(
        %{},
        fn {date, assets}, date_map ->
          if Map.get(date_map, date) == nil do
            Map.put(date_map, date, [assets])
          else
            Map.update(date_map, date, [assets], fn assets_list ->
              [assets | assets_list]
            end)
          end
        end
      )
    end)
    |> Enum.map(fn map -> Map.to_list(map) end)
    |> List.flatten()
  end

  defp download_all(path) do
    {:ok, data} = File.read(path)
    {:ok, pics_data} = Poison.decode(data)

    data =
      if File.exists?("_inprogress.bin") do
        IO.puts("Loading in-progress data")
        load_asset_data()
      else
        pics_data
        |> get_albums
        |> get_assets_for_albums
        |> persist_asset_data
      end

    data
    |> download_all_files
    |> List.flatten()
    |> Commandline.CLI.report()
  end

  def run(file, reset \\ false) do
    if reset do
      File.rm!("_inprogress.bin")
    end

    download_all(file)
  end
end
