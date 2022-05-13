// NB :
// 'world is the type you want
// 'r must be unit or Js.Promise.t<unit>
@module("@cucumber/cucumber")
external given: (string, @this ('world => 'r)) => unit = "Given"

@module("@cucumber/cucumber")
external given1: (string, @this ('world, 'a) => 'r) => unit = "Given"

@module("@cucumber/cucumber")
external given2: (string, @this ('world, 'a, 'b) => 'r) => unit = "Given"

@module("@cucumber/cucumber")
external when_: (string, @this ('world => 'r)) => unit = "When"

@module("@cucumber/cucumber")
external when1: (string, @this ('world, 'a) => 'r) => unit = "When"

@module("@cucumber/cucumber")
external when2: (string, @this ('world, 'a, 'b) => 'r) => unit = "When"

@module("@cucumber/cucumber")
external then: (string, @this ('world => 'r)) => unit = "Then"

@module("@cucumber/cucumber")
external then1: (string, @this ('world, 'a) => 'r) => unit = "Then"

@module("@cucumber/cucumber")
external then2: (string, @this ('world, 'a, 'b) => 'r) => unit = "Then"

@module("@cucumber/cucumber")
external before: (@this ('world => 'r)) => unit = "Before"
