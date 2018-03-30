defmodule Pelican.Types.Group do
  @moduledoc """
  Defines a group.

  * `id` - An string identifying the group
  * `name` - A string describing the group’s name
  * `hex` - A string that defines the color associated with the group
  * `icon` - The name of the Font Awesome icon(s) used to represent the group
  * `font_icon` - An HTML string used to render the group’s icon
  * `website` - The URL of the group’s website
  * `facebook` - The URL of the group’s Facebook page
  * `twitter` - The URL of the group’s Twitter account
  * `meetup` - The URL of the group’s Meetup page
  * `is_active` - A "Y/N" string describing whether this group should shown to users
  * `events` - A list of events associated with the group
  """

  alias Pelican.Types.Event

  @type t :: %Pelican.Types.Group{
    id: String.t(),
    name: String.t(),
    hex: String.t(),
    icon: String.t(),
    font_icon: String.t(),
    website: String.t(),
    facebook: String.t(),
    twitter: String.t(),
    meetup: String.t(),
    is_active: String.t(),
    events: list(Event.t())
  }
  defstruct [:id, :name, :hex, :icon, :font_icon, :website,
             :facebook, :twitter, :meetup, :is_active, :events]
end
