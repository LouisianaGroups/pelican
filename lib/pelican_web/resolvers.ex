defmodule PelicanWeb.Resolvers do
  alias Pelican.Worker

  def list_groups(_parents, _args, _resolution) do
    {:ok, Worker.list_groups()}
  end

  def list_groups_by_event_date(_parents, _args, _resolution) do
    {:ok, Worker.list_groups_by_event_date()}
  end

  def get_group(_parents, %{id: id}, _resolution) do
    {:ok, Worker.get_group(String.to_integer(id))}
  end

  def list_events(_parents, _args, _resolution) do
    {:ok, Worker.list_events()}
  end

  def get_event(_parents, %{id: id}, _resolution) do
    {:ok, Worker.get_event(String.to_integer(id))}
  end
end
