defmodule Pelican.Worker do
  @moduledoc """
  Maintains a list of groups and their events.
  """

  use GenServer

  @name PelicanWorker
  @client Application.get_env(:pelican, Pelican.GSX)[:client]
  @refresh_interval 300_000

  ## Client API

  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts ++ [name: @name])
  end

  def list_groups, do: GenServer.call(@name, :list_groups)

  def list_groups_by_event_date, do: GenServer.call(@name, :list_groups_by_event_date)

  def get_group(id), do: GenServer.call(@name, {:get_group, id})

  def list_events, do: GenServer.call(@name, :list_events)

  def get_event(id), do: GenServer.call(@name, {:get_event, id})

  def get_status, do: GenServer.call(@name, :get_status)

  ## Serve Callbacks

  def init(document_id) do
    :ets.new(:groups, [:public, :named_table])
    schedule_refresh(0)
    {:ok, %{document_id: document_id, updated_at: nil, status: :ok}}
  end

  def handle_call(:list_groups, _from, state) do
    groups =
      :ets.tab2list(:groups)
      |> Enum.map(fn x -> elem(x, 1) end)

    {:reply, groups, state}
  end

  def handle_call(:list_groups_by_event_date, _from, state) do
    groups =
      :ets.tab2list(:groups)
      |> Enum.map(fn x -> elem(x, 1) end)

    {have_events, no_events} = Enum.split_with(groups, fn x -> x.events != [] end)

    have_events =
      have_events
      |> Enum.map(fn x -> %{x | events: Enum.sort(x.events)} end)
      |> Enum.sort_by(fn x -> List.first(x.events) end)

    no_events = Enum.sort_by(no_events, fn x -> x.name end)

    {:reply, have_events ++ no_events, state}
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
    events =
      :ets.tab2list(:events)
      |> Enum.map(fn x -> elem(x, 1) end)

    {:reply, events, state}
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

  def handle_call(:get_status, _from, state) do
    {:reply, state[:status], state}
  end

  def handle_info(:refresh, state) do
    schedule_refresh(@refresh_interval)

    groups =
      case @client.fetch_groups(state[:document_id], 1) do
        {:ok, groups} ->
          Enum.each(groups, fn x -> :ets.insert(:groups, {x.id, x}) end)

        {:error, reason} ->
          {:error, reason}
      end

    events =
      case @client.fetch_events(state[:document_id], 2) do
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
          {:error, reason}
      end

    status =
      case groups do
        {:error, reason} ->
          {:error, reason}

        _ ->
          case events do
            {:error, reason} ->
              {:error, reason}

            _ ->
              :ok
          end
      end

    {:noreply, %{state | updated_at: Timex.now("America/Chicago"), status: status}}
  end

  ## Helper Functions

  defp schedule_refresh(time) do
    Process.send_after(self(), :refresh, time)
  end
end
