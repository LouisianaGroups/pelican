defmodule Pelican.GSX.HTTPClient do
  @moduledoc """
  Provides functions for interfacing with the gsx2json web API.
  """

  @behaviour Spotify.Client

  @endpoint "http://gsx2json.freighter.cloud/api"

  @doc """
  `GET`s the most recent data available for the Google Sheet
  document identified by `document_id`.

  Returns `{:ok, tracks}` if successful, otherwise `{:error, reason}`.

  ## Examples
      iex> fetch()
      {:ok, "{data: 123}"}

      iex> fetch()
      {:error, "Endpoint was unresponsive"}
  """
  def fetch(document_id) do
    case HTTPoison.get(@endpoint, [], params: [id: document_id]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        body =
          body
          |> Poison.decode!()
          |> Map.put("status_code", code)
        {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
