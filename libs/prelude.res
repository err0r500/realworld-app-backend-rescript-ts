let identity = a => a

module Never = {
  type rec type_equal<'a, 'b> = T: type_equal<'a, 'a>
  type t = type_equal<unit, int>
}

module Result = {
  @genType
  module BR = Belt.Result

  let flatMapFirst = (r: BR.t<'a, 'e>, onOk: 'a => BR.t<'b, 'e>): BR.t<'a, 'e> =>
    switch r {
    | Ok(a) => {
        onOk(a)->ignore
        Ok(a)
      }
    | e => e
    }

  let mapErr = (r: BR.t<'a, 'e>, onErr: 'e => 'f): BR.t<'a, 'f> =>
    switch r {
    | Error(b) => Error(onErr(b))
    | Ok(a) => Ok(a)
    }

  let fromPredicate = (a: 'a, predicate: 'a => bool, onFalse: 'a => 'e): BR.t<'a, 'e> =>
    predicate(a) ? Ok(a) : Error(onFalse(a))

  let bimap = (r: BR.t<'a, 'b>, onOk: 'a => 'c, onErr: 'b => 'd): BR.t<'c, 'd> =>
    switch r {
    | Ok(a) => Ok(onOk(a))
    | x => mapErr(x, onErr)
    }

  let fromOption = (o: option<'a>, onNone: 'e): BR.t<'a, 'e> =>
    switch o {
    | None => BR.Error(onNone)
    | Some(a) => BR.Ok(a)
    }

  let tuple = (x: BR.t<'a, 'e>, y: BR.t<'b, 'e>): BR.t<('a, 'b), 'e> =>
    switch (x, y) {
    | (Ok(a), Ok(b)) => Ok((a, b))
    | (Error(e), _) => Error(e)
    | (_, Error(e)) => Error(e)
    }
}

module Validation = {
  type t<'a> =
    | Success('a)
    | Failure(array<string>)

  let map = (toApply: 'a => 'b, val: t<'a>) =>
    switch val {
    | Success(x) => Success(toApply(x))
    | Failure(errs) => Failure(errs)
    }

  let apply = (fResult: t<'a => 'b>, xResult: t<'a>): t<'b> =>
    switch (fResult, xResult) {
    | (Success(f), Success(x)) => Success(f(x))
    | (Failure(ee1), Failure(ee2)) => Failure(Js.Array2.concat(ee1, ee2))
    | (Failure(ee), Success(_)) => Failure(ee)
    | (Success(_), Failure(ee)) => Failure(ee)
    }
}

module ResultAsync = {
  @genType type t<'a, 'e> = Js.Promise.t<Belt.Result.t<'a, 'e>>

  @genType let ok = (a: 'a): t<'a, 'e> => Promise.resolve(Ok(a))
  @genType let err = (e: 'e): t<'a, 'e> => Promise.resolve(Error(e))

  let fromValidation = (val: Validation.t<'a>): t<'a, array<string>> =>
    switch val {
    | Success(a) => ok(a)
    | Failure(ee) => err(ee)
    }

  let tryCatch = (f: Promise.t<'a>, onRejected: exn => 'e): t<'a, 'e> =>
    f->Promise.then(ok)->Promise.catch(e => onRejected(e)->err)

  let map = (first: t<'a, 'e>, f: 'a => 'b): t<'b, 'e> =>
    first->Promise.then(fst =>
      switch fst {
      | Ok(a) => ok(f(a))
      | Error(e) => err(e)
      }
    )

  let then = (result: t<'a, 'e>, f: Promise.t<'b>): Promise.t<'b> => result->Promise.then(_ => f)

  let fold = (result: t<'a, 'e>, f: Belt.Result.t<'a, 'e> => 'b): Promise.t<'b> =>
    result->Promise.thenResolve(fst => f(fst))

  let flatMap = (first: t<'a, 'e>, second: 'a => t<'b, 'e>): t<'b, 'e> =>
    first->Promise.then(fst =>
      switch fst {
      | Ok(a) => second(a)
      | Error(e) => err(e)
      }
    )

  let flatMapFirst = (first: t<'a, 'e>, onOk: 'a => t<'b, 'e>): t<'a, 'e> =>
    first->flatMap(a => {
      onOk(a)->ignore
      ok(a)
    })

  let fromOption = (o: option<'a>, onNone: unit => 'e): t<'a, 'e> =>
    switch o {
    | Some(a) => ok(a)
    | None => err(onNone())
    }

  let mapErr = (r: t<'a, 'e>, onErr: 'e => 'f): t<'a, 'f> =>
    r->Promise.then(fst =>
      switch fst {
      | Error(b) => err(onErr(b))
      | Ok(a) => ok(a)
      }
    )

  let tuple = (fst: t<'a, 'e>, snd: t<'b, 'e>): t<('a, 'b), 'e> =>
    fst->flatMap(a => snd->flatMap(b => ok((a, b))))
}

module Maybe = {
  @genType type t<'a> = option<'a>

  @genType let just = (a: 'a): t<'a> => Some(a)
  @genType let nothing = (): t<'a> => None
}

module Assert = {
  let equals = (a: 'a, b: 'a): bool => a == b

  let constUnit = (_a: 'a): unit => ()

  module String = {
    let isUUID = (s: string): bool =>
      Js.Re.test_(
        Js.Re.fromString("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i"),
        s,
      )
    let isNonEmptyString = (s: string): bool => Js.String2.length(s) > 0
  }
}
module String = {
  type nonEmptyString = NonEmptyString(string)
  let nonEmptyString = s => Assert.String.isNonEmptyString(s) ? Some(NonEmptyString(s)) : None
}

module Err = {
  @genType type t<'a> = Business('a) | Tech
  @genType let business = (a: 'a) => Business(a)
  @genType let tech = () => Tech
  @genType type techOnly = t<Never.t>
}
