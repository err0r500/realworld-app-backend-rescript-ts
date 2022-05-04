open Pino

let pino = instanciate()

let log = (value: 'a, msg: string, f: (Pino.t, string) => unit): 'a => {
  let concat = (a: 'a, m: string) =>
    Js.Json.stringifyAny(a)->Belt.Option.mapWithDefault(
      m ++ ": non serializable value provided",
      v => m ++ ": " ++ v,
    )

  pino->f(concat(value, msg))->ignore
  value
}

@genType
let info = (a: 'a, s: string): 'a => log(a, s, logInfo)

@genType
let warn = (a: 'a, s: string): 'a => log(a, s, logWarn)

@genType
let error = (a: 'a, s: string): 'a => log(a, s, logError)
