open Cucumber
open Prelude
module RA = ResultAsync

module World = {
  type t = {mutable userRepo: Inmem.UserRepo.t}

  // we don't expect technical errors to happen in business specs
  // so we fail each time it happens
  let throwOnTechErr = ra =>
    ra->RA.mapErr(err =>
      switch err {
      | Err.Tech => Js.Exn.raiseError("tech error")
      | ee => ee
      }
    )

  before(@this (w: t) => {
    w.userRepo = {
      let repo = Inmem.UserRepo.make()
      {
        getByEmail: e => repo.getByEmail(e)->throwOnTechErr,
        getByName: e => repo.getByName(e)->throwOnTechErr,
        insert: e => repo.insert(e)->throwOnTechErr,
        doesFail: repo.doesFail,
      }
    }
  })
}

let dummy: User.t = {
  name: User.Name(""),
  email: User.Email(""),
  password: User.Password(""),
  bio: User.Bio(None),
  imageLink: User.ImageLink(None),
}

let matthieu: User.t = {
  name: User.Name("matthieu"),
  email: User.Email("matthieu@email.com"),
  password: User.Password("matthieuPassword"),
  bio: User.Bio(None),
  imageLink: User.ImageLink(None),
}

let elodie: User.t = {
  name: User.Name("elodie"),
  email: User.Email("elodie@email.com"),
  password: User.Password("elodiePassword"),
  bio: User.Bio(None),
  imageLink: User.ImageLink(None),
}

module UserRepo = {
  module Helpers = {
    let assertFoundByEmail = (w: World.t, email: User.email): unit =>
      w.userRepo.getByEmail(email)
      ->RA.map(x =>
        switch x {
        | Some(_) => ()
        | _ => Js.Exn.raiseError("not found : " ++ email->User.unEmail)
        }
      )
      ->ignore
  }

  given("Matthieu's email isn't already in use", @this (w: World.t) =>
    w.userRepo.getByEmail(matthieu.email)->RA.map(mayUser =>
      switch mayUser {
      | Some(_) => Js.Exn.raiseError("email already in use")
      | _ => ()
      }
    )
  )

  given("Elodie has an account", @this (w: World.t) => {
    elodie->w.userRepo.insert->RA.map(_ => w->Helpers.assertFoundByEmail(elodie.email))
  })
}

module Registration = {
  module Uc = Registration.UC(Inmem.Logger())

  // fixme : not great, would be better if just declared but not initialized
  let res: ref<RA.t<User.t, Err.t<Registration.businessErrors>>> = ref(RA.ok(dummy))

  before(@this _ => {
    res := RA.ok(dummy)
  })

  let forgeInput = (email: User.email): Registration.input => {
    name: matthieu.name->User.unName,
    password: matthieu.password->User.unPassword,
    email: email->User.unEmail,
  }

  when1("Matthieu attempts to create a new account using {string} email", @this
  (w: World.t, email: string) => {
    let execUC = Uc.do(w.userRepo.insert)
    switch email {
    | "his" => res := matthieu.email->forgeInput->execUC
    | "Elodie's" => res := elodie.email->forgeInput->execUC
    | _ => Js.Exn.raiseError("unknown email")
    }
  })

  then1("Matthieu's account is {string} created", @this (w: World.t, succeed: string) => {
    switch succeed {
    | "succesfully" => {
        res.contents->RA.mapErr(_ => Js.Exn.raiseError("expected a registration success"))->ignore
        w->UserRepo.Helpers.assertFoundByEmail(matthieu.email)->ignore
      }
    | "not" => {
        res.contents->RA.map(_ => Js.Exn.raiseError("expected a registration error"))->ignore

        w.userRepo.getByName(matthieu.name)
        ->RA.map(mayUser =>
          switch mayUser {
          | Some(_) => Js.Exn.raiseError("expected not to find the account")
          | _ => ()
          }
        )
        ->ignore
      }
    | _ => Js.Exn.raiseError("unknown case")
    }
  })

  then("Matthieu is notified about the conflict", @this _ =>
    res.contents
    ->RA.map(_ => Js.Exn.raiseError("expected an error"))
    ->RA.mapErr(err =>
      switch err {
      | Err.Business(UserConflict) => ()
      | _ => Js.Exn.raiseError("an error, but expected a UserConflict")
      }
    )
    ->ignore
  )
}
