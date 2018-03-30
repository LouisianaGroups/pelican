defmodule Pelican.GSX.HTTPClient do
  @moduledoc """
  Provides functions for interfacing with the gsx2json web API.
  """

  @behaviour Pelican.GSX.Client

  @endpoint "https://gsx2json.freighter.cloud/api"

  alias Pelican.Types.{Group, Event}

  @doc """
  Gets a list of groups from the Google Sheets document
  identified by `document_id` and `sheet_num`.

  Returns `{:ok, groups}` if successful, otherwise `{:error, reason}`.

  ## Examples
      iex> fetch_groups("1a2b3c", 1)
      {:ok, [%Group{}, ...]}

      iex> fetch_groups("2b3c4d", 1)
      {:error, "Document not found"}
  """
  def fetch_groups(document_id, sheet_num) do
    case HTTPoison.get(@endpoint, [], params: [id: document_id, sheet: sheet_num, columns: false]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, create_groups(body)}

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

  @doc """
  Gets a list of events from the Google Sheets document
  identified by `document_id` and `sheet_num`.

  Returns `{:ok, events}` if successful, otherwise `{:error, reason}`.

  ## Examples
      iex> fetch_groups("1a2b3c", 1)
      {:ok, [%Event{}, ...]}

      iex> fetch_groups("2b3c4d", 1)
      {:error, "Document not found"}
  """
  def fetch_events(document_id, sheet_num) do
    case HTTPoison.get(@endpoint, [], params: [id: document_id, sheet: sheet_num, columns: false]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, create_events(body)}

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

  defp create_groups(body) do
    body
    |> Poison.decode!()
    |> Map.get("rows")
    |> Enum.map(fn row ->
      %Group{
        id: row["id"],
        name: avoid_zero(row["groupname"]),
        hex: avoid_zero(row["hex"]),
        icon: avoid_zero(row["icon"]),
        font_icon: avoid_zero(row["fonticon"]),
        website: avoid_zero(row["website"]),
        facebook: avoid_zero(row["facebook"]),
        twitter: avoid_zero(row["twitter"]),
        meetup: avoid_zero(row["meetup"]),
        is_active: avoid_zero(row["isactive"]),
        events: []
      }
    end)
  end

  defp create_events(body) do
    body
    |> Poison.decode!()
    |> Map.get("rows")
    |> Enum.map(fn row ->
      %Event{
        id: row["id"],
        group_id: row["groupid"],
        date_time: extract_date_time(row["nextmeetupdatetime"])
      }
    end)
  end

  defp avoid_zero(field) do
    if field == 0, do: nil, else: field
  end

  defp extract_date_time(field) do
    case Timex.parse(field, "{M}/{D}/{YY} {h24}:{m}") do
      {:ok, parsed} ->
        Timex.to_datetime(parsed, "America/Chicago")

      {:error, error} ->
        nil
    end
  end
end
