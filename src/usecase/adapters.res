module type Logger = {
  let info: ('a, string) => 'a
  let warn: ('a, string) => 'a
}

module Logger' = {
  type t
  // this won't compile because of unbound type parameter 'a
  //type info' = ('a, string) => 'a
  type info = (t, string) => unit
  type warn = (t, string) => unit
}
