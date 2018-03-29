defmodule Pelican.Worker do
  @moduledoc """
  Maintains a list of groups and their events.
  """

  use GenServer

  @name PelicanWorker
  @client Application.get_env(:pelican, Pelican.GSX)[:client]
  @refresh_interval 1_800_000

  ## Client API

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts ++ [name: @name])
  end

  def list_groups, do: GenServer.call(@name, :list_groups)

  def get_group(id), do: GenServer.call(@name, {:get_group, id})

  def list_events, do: GenServer.call(@name, :list_events)

  def get_event(id), do: GenServer.call(@name, {:get_event, id})

  ## Serve Callbacks

  def init(document_id) do
    :ets.new(:groups, [:public, :named_table])
    :ets.new(:events, [:public, :named_table])

    schedule_refresh(0)

    {:ok, %{document_id: document_id, updated_at: nil}}
  end

  def handle_call(:list_groups, _from, state) do
    {:reply, :ets.tab2list(:groups), state}
  end

  def handle_call({:get_group, id}, _from, state) do
    group =
      case :ets.lookup(:groups, id) do
        [{_id, group}] ->
          group

        [] ->
          nil
      end

    {:reply, group, state}
  end

  def handle_call(:list_events, _from, state) do
    {:reply, :ets.tab2list(:events), state}
  end

  def handle_call({:get_event, id}, _from, state) do
    event =
      case :ets.lookup(:events, id) do
        [{_id, event}] ->
          event

        [] ->
          nil
      end

    {:reply, event, state}
  end

  def handle_info(:refresh, state) do
    schedule_refresh(@refresh_interval)


    groups =
      case @client.fetch_groups(state.document_id, 1) do
        {:ok, groups} ->
          Enum.each(groups, fn x -> :ets.insert(:groups, {x.id, x}) end)

        {:error, reason} ->
          raise inspect(reason)
      end

    events =
      case @client.fetch_events(state.document_id, 2) do
        {:ok, events} ->
          Enum.each(events, fn event ->
            case :ets.lookup(:groups, event.group_id) do
              [{_id, group}] ->
                :ets.insert(:groups, {group.id, %{group | events: group.events ++ [event]}})

              [] ->
                nil
            end
          end)

        {:error, reason} ->
          raise inspect(reason)
      end


    {:noreply, %{state | updated_at: Timex.now("America/Chicago")}}
  end

  ## Helper Functions

  defp schedule_refresh(time) do
    Process.send_after(self(), :refresh, time)
  end
end
