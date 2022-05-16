open Zora
open Prelude
module RA = ResultAsync

let matthieu: User.t = {
  name: User.Name("matthieu"),
  email: User.Email("matthieu@email.com"),
  password: User.Password("matthieuPassword"),
  bio: User.Bio(None),
  imageLink: User.ImageLink(None),
}

zora("registration", t => {
  let make = () => {
    module Logger = Inmem.Logger()
    let {getLogs} = module(Logger)
    module UC = Registration.UC(Logger)

    let userRepo = Inmem.UserRepo.make()

    {
      "userRepo": userRepo,
      "pure": UC.do(userRepo.insert),
      "getLogs": getLogs,
    }
  }

  let forgeInput = (user: User.t): Registration.input => {
    name: user.name->User.unName,
    password: user.password->User.unPassword,
    email: user.email->User.unEmail,
  }

  t->test("happy patth", t => {
    // G
    let ctx = make()

    // W
    let res = matthieu->forgeInput->ctx["pure"]

    // T
    res->then(r => {
      t->equal(r, Ok(matthieu), "returns the user")
      t->equal(ctx["getLogs"]()->Js.Array.length, 0, "no logs")
      done()
    })
  })

  t->test("technical error", t => {
    // G
    let ctx = make()
    ctx["userRepo"].doesFail()->ignore
    t->equal(ctx["getLogs"]()->Js.Array.length, 0, "check")

    // W
    let res = matthieu->forgeInput->ctx["pure"]

    // T
    res->then(r => {
      t->equal(r, Error(Err.Tech), "returns an Err.Tech")
      t->equal(ctx["getLogs"]()->Js.Array.length, 1, "logged err")
      done()
    })
  })

  t->test("conflict", t => {
    // G
    let ctx = make()
    let preConditions =
      ctx["userRepo"].insert(matthieu)->RA.mapErr(_ => t->fail("failed to setup pre-conditions"))

    t->equal(ctx["getLogs"]()->Js.Array.length, 0, "check")

    // W
    let res = preConditions->then(_ => matthieu->forgeInput->ctx["pure"])

    // T
    res->then(r => {
      t->equal(r, Error(Err.Business(Registration.UserConflict)), "returns a UserConflict error")
      t->equal(ctx["getLogs"]()->Js.Array.length, 1, "logged err")
      done()
    })
  })
  done()
})
