defmodule Companion do
  @moduledoc """
  My dear Elixir Companion!
  This is the main module for your Companion.
  """

  @doc """
  The inital Companion method
  """
  def start do
    IO.puts "Starting Elixir Companion..."
    Companion.Supervisor.start_link
  end
end
