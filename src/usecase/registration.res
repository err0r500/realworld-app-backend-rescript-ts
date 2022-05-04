open Prelude
module RA = ResultAsync

type businessErrors = UserConflict

//type pure = (User.name, User.email, User.password) => RA.t<User.t, Prelude.Err.t<businessErrors>>
@genType
type pure = User.name => RA.t<User.t, Prelude.Err.t<businessErrors>>
//
//type usecase = (User.name, User.email, User.password) => RA.t<User.t, Prelude.Err.t<businessErrors>>
//
//@genType
//module UC = (Logger: Adapters.Logger) => {
//  @genType
//  let do: usecase = (name, _email, _password) => {
//    name->Logger.info("hello")->ignore
//    RA.err(Prelude.Err.Tech)
//  }
//}
//
//type usecaseOther = (
//  Adapters.Logger'.t,
//  User.name,
//  User.email,
//  User.password,
//) => RA.t<User.t, Prelude.Err.t<businessErrors>>
//
//@genType
//module UCother = {
//  @genType
//  let do: usecaseOther = (logger, _name, _email, _password) => {
//    logger.info("can only log strings")->ignore
//
//    RA.err(Prelude.Err.Tech)
//  }
//}

module type Logger1 = {
  let info: ('a, string) => 'a
  let warn: ('a, string) => 'a
}

module BusinessLogic1 = (Logger: Logger1) => {
  @genType
  let do = (name: int): unit => {
    name->Logger.info("hello")->ignore
    "aString"->Logger.info("hello!")->ignore
    ()
  }
}

module Logger2 = {
  type info<'a> = ('a, string) => 'a
  type warn<'a> = ('a, string) => 'a
}

module BusinessLogic2 = {
  @genType
  let do = (name: int, logInfo: Logger2.info<'a>): unit => {
    name->logInfo("hello")->ignore
    //"aString"->logInfo("hello")->ignore // this doesn't work because 'a has been infered as int
    ()
  }
}
