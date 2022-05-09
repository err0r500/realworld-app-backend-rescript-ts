module World = {
  type t
}

// NB : 'r must be unit or Js.Promise.t<unit>
@module("@cucumber/cucumber")
external given: (string, @this (World.t => 'r)) => unit = "Given"

@module("@cucumber/cucumber")
external given1: (string, @this (World.t, 'a) => 'r) => unit = "Given"

@module("@cucumber/cucumber")
external given2: (string, @this (World.t, 'a, 'b) => 'r) => unit = "Given"

@module("@cucumber/cucumber")
external given3: (string, @this (World.t, 'a, 'b, 'c) => 'r) => unit = "Given"
