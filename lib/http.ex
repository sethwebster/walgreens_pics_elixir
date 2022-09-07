defmodule WalgreensPicsElixir.HTTP do
  def post(url, body, token) do
    headers = [
      {":authority", "photo.walgreens.com"},
      {":method", "POST"},
      {":path", "/library/request_api"},
      {"scheme", "https"},
      {"accept", "application/json, text/javascript, */*; q=0.01"},
      {"accept-language", "en-US,en;q=0.9"},
      {"access_token", token},
      {"authorization", token},
      {"cache-control", "no-cache"},
      {"content-type", "application/json"},
      {"gsid", "aus-5b926e8b-d629-4c6e-9acf-27ebe47aa1ba-61535"},
      {"noodle", "6a2bf840-35d4-295f-7f00-e83a79ee829f"},
      {"pragma", "no-cache"},
      {"sec-ch-ua",
       "\"Chromium\";v=\"104\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"104\""},
      {"sec-ch-ua-mobile", "?0"},
      {"sec-ch-ua-platform", "\"macOS\""},
      {"sec-fetch-dest", "empty"},
      {"sec-fetch-mode", "cors"},
      {"sec-fetch-site", "same-origin"},
      {"sec-gpc", "1"},
      {"x-requested-with", "XMLHttpRequest"},
      {"referrer", "https://photo.walgreens.com/library/photos/pgvw/siav/aid/40292254150060"},
      {"referrerPolicy", "strict-origin-when-cross-origin"},
      {"body",
       "{\"version\":\"v2\",\"type\":\"GET\",\"req_service\":\"pict\",\"url\":\"collection/40292254150060/assets?limit=100&skip=0&sortOrder=ascending&sortCriteria=dateTaken\"}"},
      {"method", "POST"},
      {"mode", "cors"},
      {"credentials", "include"}
    ]

    case HTTPoison.post(url, body, headers) do
      {:ok, response} ->
        {:ok, response.body |> Poison.decode!(keys: :atoms)}

      {:error, %{reason: reason}} ->
        IO.puts("Unable to post #{url}: #{reason}")
        {:error, %{reason: reason, url: url}}
    end
  end

  # def fetch(url) do
  #   case HTTPoison.get(url) do
  #     {:ok, response} ->
  #       {:ok, Poison.decode!(response.body)}

  #     {:error, %{reason: reason}} ->
  #       {:error, reason}
  #   end
  # end
end
