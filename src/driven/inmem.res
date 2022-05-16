open Prelude
module RA = ResultAsync

module Logger = () => {
  let state: ref<array<string>> = ref([])

  let make = () => {
    state := []
  }

  let getLogs = (): array<string> => state.contents

  let shared = (a: 'a, s: string): 'a => {
    Js.Array.push(s ++ " : ", state.contents)->ignore
    a
  }

  let info = (a: 'a, s: string): 'a => shared(a, "info: " ++ s)
  let warn = (a: 'a, s: string): 'a => shared(a, "warn: " ++ s)
  let error = (a: 'a, s: string): 'a => shared(a, "error: " ++ s)
}

module UserRepo = {
  let state: ref<array<User.t>> = ref([])
  let fails: ref<bool> = ref(false)

  let _getByPredicate = (predicate: User.t => bool) => {
    fails.contents ? RA.err(Prelude.Err.Tech) : RA.ok(Js.Array2.find(state.contents, predicate))
  }

  let getByEmail = (email: User.email) => _getByPredicate((u: User.t) => u.email == email)
  let getByName = (name: User.name) => _getByPredicate((u: User.t) => u.name == name)

  let insert = (user: User.t) => {
    fails.contents
      ? RA.err(Prelude.Err.Tech)
      : getByEmail(user.email)->RA.flatMap(mayUser => {
          switch mayUser {
          | Some(_) => RA.err(Err.business(Adapters.UserRepo.EmailConflict))
          | None => {
              state := Js.Array.concat([user], state.contents)
              RA.ok()
            }
          }
        })
  }

  let doesFail = () => {
    fails := true
  }

  type t = {
    getByEmail: Adapters.UserRepo.getByEmail,
    getByName: User.name => RA.t<option<User.t>, Prelude.Err.techOnly>,
    insert: Adapters.UserRepo.insert,
    doesFail: unit => unit,
  }

  let make = () => {
    fails := false
    state := []

    {
      getByEmail: getByEmail,
      getByName: getByName,
      insert: insert,
      doesFail: doesFail,
    }
  }
}
