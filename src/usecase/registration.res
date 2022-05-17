open Prelude
module RA = ResultAsync

type businessErrors =
  | UserConflict
  | InvalidInput(array<string>)

type input = {name: string, email: string, password: string}
type pure = input => RA.t<User.t, Err.t<businessErrors>>

@genType type usecase = Adapters.UserRepo.insert => pure

module UC = (Logger: Adapters.Logger) => {
  let do: usecase = userRepoInsert => {
    let pure: pure = ({name, email, password}) => {
      module Steps = {
        let validateUser =
          User.makeNewUser
          ->Validation.map(User.mkName(name))
          ->Validation.apply(User.mkEmail(email))
          ->Validation.apply(User.mkPassord(password))
          ->RA.fromValidation
          ->RA.mapErr(ee => Err.Business(InvalidInput(ee)))

        let insertUser = user =>
          userRepoInsert(user)
          ->RA.mapErr(insertError => {
            switch insertError {
            | Err.Business(EmailConflict) =>
              Err.business(UserConflict)->Logger.error("userRepo.insert")
            | Err.Tech => Err.Tech->Logger.error("userRepo.insert")
            }
          })
          ->RA.map(_ => user)
      }

      Steps.validateUser->RA.flatMap(Steps.insertUser)
    }

    pure
  }
}
