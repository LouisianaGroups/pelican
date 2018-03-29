defmodule Pelican.GSX.Client do
  @moduledoc """
  This module defines an explicit contract to which all modules
  that act as consumers of the GSX API should adhere to.
  """

  alias Pelican.Types.{Group, Event}

  @callback fetch_groups(document_id :: String.t(), sheet_num :: integer()) :: {:ok, [Group.t()]} | {:error, term()}
  @callback fetch_events(document_id :: String.t(), sheet_num :: integer()) :: {:ok, [Event.t()]} | {:error, term()}
end
