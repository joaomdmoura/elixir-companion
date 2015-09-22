defmodule Companion.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @core Core
  @bucket Bucket

  def init(:ok) do
    children = [
      worker(Companion.Core, [[name: @core]]),
      worker(Companion.Bucket, [[name: @bucket]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
