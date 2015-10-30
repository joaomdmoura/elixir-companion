defmodule Companion do
  @moduledoc """
  My dear Elixir Companion!
  This is the main module for your Companion.
  """
  use Application

  @doc """
  The inital Companion method
  """
  def start(_type, _args) do
    IO.puts "Starting Elixir Companion..."
    Companion.Supervisor.start_link
  end
end
