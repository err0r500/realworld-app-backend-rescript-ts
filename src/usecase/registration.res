open Prelude
module RA = ResultAsync

type businessErrors = UserConflict

@genType
type pure = (User.name, User.email, User.password) => RA.t<User.t, Err.t<businessErrors>>

type usecase = int => pure // just to illustrate dependency injection

module UC = (Logger: Adapters.Logger) => {
  let do: usecase = (i: int, name, _email, _password) => {
    i->Logger.info("injected")->ignore
    name->Logger.info("name")->ignore
    RA.err(Err.Tech)
  }
}
