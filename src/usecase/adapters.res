module type Logger = {
  let info: ('a, string) => 'a
  let warn: ('a, string) => 'a
  let error: ('a, string) => 'a
}

module UserRepo = {
  open Prelude

  @genType type getByName = User.name => ResultAsync.t<Maybe.t<User.t>, Err.techOnly>
}

module UuidGenerator = {
  @genType type genUUID = unit => string
}

module Crypto = {
  @genType type hash = string => string
}
