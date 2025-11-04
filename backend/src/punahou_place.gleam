import dot_env/env
import gleam/erlang/process
import gleam/json
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  let secret_key_base = "SDFNAGFKJASF"
  let assert Ok(frontend) = env.get_string("FRONTEND_URL")
  let assert Ok(_) =
    wisp_mist.handler(
      fn(_req) {
        json.object([#("hello", "world" |> json.string)])
        |> json.to_string
        |> wisp.json_response(200)
        |> wisp.set_header("Access-Control-Allow-Origin", frontend)
        |> wisp.set_header("Access-Control-Allow-Methods", "GET")
      },
      secret_key_base,
    )
    |> mist.new
    |> mist.port(8000)
    |> mist.bind("0.0.0.0")
    |> mist.start
  process.sleep_forever()
}
