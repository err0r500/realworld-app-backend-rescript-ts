type t

@module("pino") external instanciate: unit => t = "pino"

@send external logInfo: (t, string) => unit = "info"
@send external logWarn: (t, string) => unit = "warn"
@send external logError: (t, string) => unit = "error"
