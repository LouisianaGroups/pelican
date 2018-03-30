defmodule PelicanWeb.Schema do
  use Absinthe.Schema

  import_types(PelicanWeb.Schema.Types)

  alias PelicanWeb.Resolvers

  query do
    @desc "Get a list of all groups"
    field :groups, list_of(:group) do
      resolve(&Resolvers.list_groups/3)
    end

    @desc "Get a list of all groups, sorted by event date"
    field :groups_by_event_date, list_of(:group) do
      resolve(&Resolvers.list_groups_by_event_date/3)
    end

    @desc "Get a single group"
    field :group, :group do
      arg(:id, non_null(:id))
      resolve(&Resolvers.get_group/3)
    end

    @desc "Get a list of all events"
    field :events, list_of(:event) do
      resolve(&Resolvers.list_events/3)
    end

    @desc "Get a single event"
    field :event, :event do
      arg(:id, non_null(:id))
      resolve(&Resolvers.get_event/3)
    end
  end
end
