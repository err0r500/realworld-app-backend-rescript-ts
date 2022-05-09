open Prelude
module RA = ResultAsync

type businessErrors =
  | UserConflict
  | InvalidInput(list<string>)

type input = {name: string, email: string, password: string}
type pure = input => RA.t<User.t, Err.t<businessErrors>>

@genType type usecase = Adapters.UserRepo.getByName => pure

module UC = (Logger: Adapters.Logger) => {
  // we've to write 2 functions here because otherwise we can't partially apply it from the ts side
  let do: usecase = urGetByName => {
    let pure: pure = ({name, email: _email, password: _password}) =>
      // todo : make input fields validation
      // the idea is nothing prevents calling the domain constructor with the wrong input field (on the ts side)
      urGetByName(Name(name))
      ->RA.mapErr(_ => Err.Tech->Logger.error("userRepo.GetByName"))
      ->RA.flatMap(maybeU => maybeU->RA.fromOption(_ => Err.Business(UserConflict)))
    pure
  }
}
