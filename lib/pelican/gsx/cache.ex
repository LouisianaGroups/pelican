defmodule Pelican.GSX.Cache do
  @moduledoc """
  Maintains a JSON representation of our Google Sheet data,
  updating it on a set interval.
  """

  use GenServer

  @name PelicanWorker
  @client Application.get_env(:pelican, Pelican.GSX)[:client]
  @refresh_interval 1_800_000

  ## Client API

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts ++ [name: @name])
  end

  def read, do: GenServer.call(@name, :read)

  ## Serve Callbacks

  def init(document_id) do
    schedule_refresh(0)
    {:ok, %{document_id: document_id, data: nil, updated_at: nil}}
  end

  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:refresh, state) do
    schedule_refresh(@refresh_interval)

    case @client.fetch(state.document_id) do
      {:ok, data} ->
        updated_at = Timex.now("America/Chicago")
        {:noreply, %{state | data: data, updated_at: updated_at}}
      {:error, reason} ->
        raise inspect(reason)
    end
  end

  ## Helper Functions

  defp schedule_refresh(time) do
    Process.send_after(self(), :refresh, time)
  end
end
