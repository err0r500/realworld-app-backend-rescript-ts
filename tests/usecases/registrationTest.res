open Zora
open Prelude
module RA = ResultAsync

module UC = Registration.UC(Inmem.Logger)

let make = () => {
  let userRepo = Inmem.UserRepo.make()

  {
    "userRepo": userRepo,
    "pure": UC.do(userRepo.insert),
  }
}

let forgeInput = (user: User.t): Registration.input => {
  name: user.name->User.unName,
  password: user.password->User.unPassword,
  email: user.email->User.unEmail,
}

let matthieu: User.t = {
  name: User.Name("matthieu"),
  email: User.Email("matthieu@email.com"),
  password: User.Password("matthieuPassword"),
  bio: User.Bio(None),
  imageLink: User.ImageLink(None),
}

zora("visitor registration", t => {
  t->test("happy path", t => {
    // G
    let ctx = make()

    // W
    let res = matthieu->forgeInput->ctx["pure"]

    // T
    res->then(r => {
      t->equal(Ok(matthieu), r, "returns the user")
      done()
    })
  })

  t->test("technical error", t => {
    // G
    let ctx = make()
    ctx["userRepo"].doesFail()->ignore

    // W
    let res = matthieu->forgeInput->ctx["pure"]

    // T
    res->then(r => {
      t->equal(Error(Err.Tech), r, "returns an Err.Tech")
      done()
    })
  })

  t->test("conflict", t => {
    // G
    let ctx = make()
    let preConditions =
      ctx["userRepo"].insert(matthieu)->RA.mapErr(_ => t->fail("failed to setup pre-conditions"))

    // W
    let res = preConditions->then(_ => matthieu->forgeInput->ctx["pure"])

    // T
    res->then(r => {
      t->equal(Error(Err.Business(Registration.UserConflict)), r, "returns a UserConflict error")
      done()
    })
  })

  done()
})
