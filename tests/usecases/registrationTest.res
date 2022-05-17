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

    module UserRepo = Inmem.UserRepo()
    let {insert, getByName, doesFail} = module(UserRepo)

    {
      "userRepo": {"insert": insert, "getByName": getByName, "doesFail": doesFail},
      "pure": UC.do(insert),
      "getLogs": getLogs,
    }
  }

  let forgeInput = (user: User.t): Registration.input => {
    name: user.name->User.unName,
    password: user.password->User.unPassword,
    email: user.email->User.unEmail,
  }

  let check = (t: string, r: result<User.t, Prelude.Err.t<Registration.businessErrors>>) =>
    switch r {
    | Ok(_) => {
        Js.Console.log2(t, "ok")
        r
      }
    | Error(Err.Tech) => {
        Js.Console.log2(t, "err tech")
        r
      }

    | Error(Err.Business(UserConflict)) => {
        Js.Console.log2(t, "err business user conflict")
        r
      }
    | Error(Err.Business(InvalidInput(_))) => {
        Js.Console.log2(t, "err business invalid input")
        r
      }
    }

  t->test("happy patth", t => {
    // G
    let ctx = make()

    // W
    let res = matthieu->forgeInput->ctx["pure"]

    // T
    res->then(r => {
      t->equal(check("happy", r), Ok(matthieu), "returns the user")
      t->equal(ctx["getLogs"]()->Js.Array.length, 0, "no logs")
      done()
    })
  })

  t->test("technical error", t => {
    // G
    let ctx = make()
    ctx["userRepo"]["doesFail"]()->ignore
    t->equal(ctx["getLogs"]()->Js.Array.length, 0, "check")

    // W
    let res = matthieu->forgeInput->ctx["pure"]

    // T
    res->then(r => {
      t->equal(check("tech", r), Error(Err.Tech), "returns an Err.Tech")
      t->equal(ctx["getLogs"]()->Js.Array.length, 1, "logged err")
      done()
    })
  })

  t->test("conflict", t => {
    // G
    let ctx = make()
    let preConditions =
      ctx["userRepo"]["insert"](matthieu)->RA.mapErr(_ => t->fail("failed to setup pre-conditions"))

    t->equal(ctx["getLogs"]()->Js.Array.length, 0, "check")

    // W
    let res = preConditions->then(_ => matthieu->forgeInput->ctx["pure"])

    // T
    res->then(r => {
      t->equal(
        check("business", r),
        Error(Err.Business(Registration.UserConflict)),
        "returns a UserConflict error",
      )
      t->equal(ctx["getLogs"]()->Js.Array.length, 1, "logged err")
      done()
    })
  })
  done()
})
