defmodule Askmybook.Model do
  @batch_size 8
  @sequence_length 32

  def predict(text) do
    Nx.Serving.batched_run(AskmybookModel, text)
  end

  def serving(_compiler_options) do
    {:ok, %{model: model, params: params}} =
      Bumblebee.load_model({:hf, "sentence-transformers/paraphrase-MiniLM-L6-v2"})

    {:ok, tokenizer} =
      Bumblebee.load_tokenizer({:hf, "sentence-transformers/paraphrase-MiniLM-L6-v2"})

    {_init_fn, predict_fn} = Axon.build(model, compiler: EXLA)

    Nx.Serving.new(fn ->
      fn %{size: size} = inputs ->
        inputs = Nx.Batch.pad(inputs, @batch_size - size)
        predict_fn.(params, inputs)[:pooled_state]
      end
    end)
    |> Nx.Serving.client_preprocessing(fn texts ->
      inputs =
        Bumblebee.apply_tokenizer(tokenizer, texts,
          length: @sequence_length,
          return_token_type_ids: false
        )

      {Nx.Batch.concatenate([inputs]), :ok}
    end)
  end
end
