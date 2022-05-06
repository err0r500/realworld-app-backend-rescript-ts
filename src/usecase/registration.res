open Prelude
module RA = ResultAsync

type businessErrors = UserConflict

type pure = (User.name, User.email, User.password) => RA.t<User.t, Err.t<businessErrors>>

@genType type usecase = Adapters.UserRepo.getByName => pure

module UC = (Logger: Adapters.Logger) => {
  let do: usecase = urGetByName => {
    let pure: pure = (name, _email, _password) =>
      urGetByName(name)
      ->RA.mapErr(_ => Err.Tech)
      ->RA.flatMap(maybeU => maybeU->RA.fromOption(_ => Err.Business(UserConflict)))
    pure
  }
}
