open Prelude
module RA = ResultAsync

type businessErrors =
  | UserConflict
  | InvalidInput(list<string>)

type input = {name: string, email: string, password: string}
type pure = input => RA.t<User.t, Err.t<businessErrors>>

@genType type usecase = Adapters.UserRepo.insert => pure

module UC = (Logger: Adapters.Logger) => {
  let do: usecase = urInsert => {
    let pure: pure = ({name, email, password}) => {
      let userToInsert: User.t = {
        name: Name(name),
        email: Email(email),
        password: Password(password),
        bio: Bio(None),
        imageLink: ImageLink(None),
      }

      userToInsert
      ->urInsert
      ->RA.mapErr(e => {
        switch e {
        | Err.Tech => Err.Tech->Logger.error("userRepo.insert")
        | Err.Business(EmailConflict) => Err.business(UserConflict)->Logger.error("userRepo.insert")
        }
      })
      ->RA.map(_ => userToInsert)
    }

    pure
  }
}
