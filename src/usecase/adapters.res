module type Logger = {
  let info: ('a, string) => 'a
  let warn: ('a, string) => 'a
  let error: ('a, string) => 'a
}

module UserRepo = {
  open Prelude

  @genType type getByEmail = User.email => ResultAsync.t<Maybe.t<User.t>, Err.techOnly>

  type insertErr = EmailConflict
  @genType type insert = User.t => ResultAsync.t<unit, Err.t<insertErr>>
}

module UuidGenerator = {
  @genType type genUUID = unit => string
}

module Crypto = {
  @genType type hash = string => string
}
