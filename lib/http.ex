defmodule WalgreensPicsElixir.HTTP do
  def post(url, body) do
    headers = [
      {":authority", "photo.walgreens.com"},
      {":method", "POST"},
      {":path", "/library/request_api"},
      {"scheme", "https"},
      {"accept", "application/json, text/javascript, */*; q=0.01"},
      {"accept-language", "en-US,en;q=0.9"},
      {"access_token",
       "OAuth wg_v1a;kmI6pY39IjaOiJiZ/qJTSTwvWv7EpaWfNXzO9lUKUALnISEkmlf6vNgWwtAUl6JjIX3esLeUhUHS2l4OKLwQ4us4orqW6PJ9Kx0LY4xsISCysLhbcraVcpmptTzbnBU0odMB1yYQcFF59rZ0P7nBzvN/CtlZyVubXIH+WAAW5EI=JnBbwhle/oefpMssqponHvY60km/RKTfGpANlImQBE5m2hDEtQHX8Yw71SyV01m0059SW1yCwaY4vizFibOFOFRReZjPqFqqX7gL1UuZ48wgty+MMjqk4wpU4Jz6nZADKSyHld4msKKEMFhYYFg2/2lVRRW7B415gaj04vBUVYQ=fVqSRPUig0XezSbzltmqo98GGtx4kXT0Y4kFQpGwnnu+zmvGNrBc5anx8q/snovpfLtCKX9msFCFrFW729xklISz5DD4hIEm9w9ThXRBZyounifAdNMgJdpIE4vsxz+0phWUUtx9kvGeCh/4vZvGtk/zFj/ItlxNsIE2/oxWkdU="},
      {"authorization",
       "OAuth wg_v1a;kmI6pY39IjaOiJiZ/qJTSTwvWv7EpaWfNXzO9lUKUALnISEkmlf6vNgWwtAUl6JjIX3esLeUhUHS2l4OKLwQ4us4orqW6PJ9Kx0LY4xsISCysLhbcraVcpmptTzbnBU0odMB1yYQcFF59rZ0P7nBzvN/CtlZyVubXIH+WAAW5EI=JnBbwhle/oefpMssqponHvY60km/RKTfGpANlImQBE5m2hDEtQHX8Yw71SyV01m0059SW1yCwaY4vizFibOFOFRReZjPqFqqX7gL1UuZ48wgty+MMjqk4wpU4Jz6nZADKSyHld4msKKEMFhYYFg2/2lVRRW7B415gaj04vBUVYQ=fVqSRPUig0XezSbzltmqo98GGtx4kXT0Y4kFQpGwnnu+zmvGNrBc5anx8q/snovpfLtCKX9msFCFrFW729xklISz5DD4hIEm9w9ThXRBZyounifAdNMgJdpIE4vsxz+0phWUUtx9kvGeCh/4vZvGtk/zFj/ItlxNsIE2/oxWkdU="},
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
end
