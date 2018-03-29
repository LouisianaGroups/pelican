defmodule Pelican.Types.Event do
  @moduledoc """
  Defines an event that belongs to a group.

  * `id` - An integer identifying the event
  * `group_id` - An integer identifying the event’s associated group
  * `date_time` - A string describing the date and time of the event
  """

  @type t :: %Pelican.Types.Event{id: integer(), group_id: integer(), date_time: %DateTime{}}
  defstruct [:id, :group_id, :date_time]
end

