open Cucumber

given2("user {string} is authenticated {int}", @this (world, name: string, age: int) => {
  let myPromise2 = Js.Promise.make((~resolve, ~reject) => {
    Js.Global.setTimeout(() => {
      resolve(. 2)
    }, 1000)->ignore
    ()
  })

  myPromise2->Js.Promise.then_(value => {
    Js.log2(name, age)
    Js.Promise.resolve()
  }, _)
})
