defmodule PelicanWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :group do
    field(:id, :id)
    field(:name, :string)
    field(:location, :string)
    field(:hex, :string)
    field(:icon, :string)
    field(:font_icon, :string)
    field(:website, :string)
    field(:facebook, :string)
    field(:twitter, :string)
    field(:meetup, :string)
    field(:is_active, :string)
    field(:events, list_of(:event))
  end

  object :event do
    field(:id, :id)
    field(:group_id, :integer)
    field(:date_time, :string)
  end
end
