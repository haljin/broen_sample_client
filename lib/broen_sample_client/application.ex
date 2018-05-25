defmodule BroenSampleClient.Application do
  use Application
  require Logger

  alias BroenSampleClient.{Endpoint, GetPostEndpoint}

  def start(_type, _args) do
    amqp_host = Application.fetch_env!(:broen_sample_client, :amqp_host)
    username = Application.fetch_env!(:broen_sample_client, :amqp_user)
    password = Application.fetch_env!(:broen_sample_client, :amqp_password)

    endpoint =
      Endpoint.setup(
        [host: amqp_host, username: username, password: password],
        5
      )

    endpoint_2 =
      GetPostEndpoint.setup(
        [host: amqp_host, username: username, password: password],
        5
      )

    children = [
      endpoint,
      endpoint_2
    ]

    opts = [strategy: :one_for_one, name: BroenSampleClient.Supervisor]

    {:ok, pid} = Supervisor.start_link(children, opts)
    Logger.info("BroenSampleClient started")
    {:ok, pid}
  end
end
