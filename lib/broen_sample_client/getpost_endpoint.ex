defmodule BroenSampleClient.GetPostEndpoint do
  def setup(amqp_params, consumers) do
    rpc_queue = "test_queue_getpost"

    AmqpDirector.server_child_spec(
      :sample_client_rpc_2,
      &handle/3,
      amqp_params,
      consumers,
      consume_queue: rpc_queue,
      queue_definitions: [
        AmqpDirector.queue_declare(rpc_queue, auto_delete: true),
        AmqpDirector.queue_bind(rpc_queue, "http_exchange", "test-service.methods.*")
      ]
    )
  end

  @spec handle(payload :: binary, content_type :: String.t(), type :: String.t()) ::
          AmqpDirector.handler_return_type()
  def handle(payload, "application/json", _) do
    {:ok, decoded} = Poison.decode(payload, unpack_str: :as_binary)

    case decoded["method"] do
      "GET" ->
        suffix =
          decoded["routing_key"]
          |> String.split(".")
          |> List.last()

        {:ok, payload} =
          %{
            text: "Hello",
            data: suffix
          }
          |> Poison.encode()

        response = %{
          status_code: 200,
          payload: payload,
          media_type: "application/json"
        }

        {:ok, packed} = Poison.encode(response)
        {:reply, packed, "application/json"}

      "POST" ->
        {:ok, data} = decoded["client_data"] |> Poison.decode()
        IO.inspect(data, label: "Got client data")

        response = %{
          status_code: 201,
          payload: %{} |> Poison.encode() |> elem(1),
          media_type: "application/json"
        }

        {:ok, packed} = Poison.encode(response)
        {:reply, packed, "application/json"}
    end
  end
end
