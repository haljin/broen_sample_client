defmodule BroenSampleClient.Endpoint do

    def setup(amqp_params, consumers) do
        rpc_queue = "test_queue"

        AmqpDirector.server_child_spec(
          :sample_client_rpc,
          &handle/3,
          amqp_params,
          consumers,
          consume_queue: rpc_queue,
          queue_definitions: [
            AmqpDirector.queue_declare(rpc_queue, auto_delete: true),
            AmqpDirector.queue_bind(rpc_queue, "http_exchange", "test-service.something")
          ]
        )
      end

      @spec handle(payload :: binary, content_type :: String.t(), type :: String.t()) :: AmqpDirector.handler_return_type()
      def handle(payload, "application/json", _) do
        {:ok, decoded} = Poison.decode(payload, unpack_str: :as_binary)

        response =
              %{
                status_code: 200,
                payload: "Hello",
                media_type: "text/plain"
              }

        {:ok, packed} = Poison.encode(response)
        {:reply, packed, "application/json"}
      end

end
