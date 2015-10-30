defmodule Companion.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @manager Companion.EventManager
  @registry Companion.Registry
  @core Companion.Core
  @bucket_sup Companion.Bucket.Supervisor

  def init(:ok) do
    children = [
      worker(GenEvent, [[name: @manager]]),
      supervisor(Companion.Bucket.Supervisor, [[name: @bucket_sup]]),
      worker(Companion.Registry, [@manager, @bucket_sup, [name: @registry]])
      # worker(Companion.Core, [[name: @core]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
