//open Fastify
//
//type author = {id: float, hello: option<string>}
//
//let authorStruct: S.t<author> = S.record2(
//  ~fields=(("Id", S.float()), ("hello", S.deprecated(S.string()))),
//  ~constructor=((id, _)) => {id: id, hello: None}->Ok,
//  (),
//)
//
//Server.server()
//->Route.get("/", (_, res) => {
//  res->Response.sendString("Hello from GET !")
//})
//->Route.post("/hello", (req, res) => {
//  switch Js.Nullable.toOption(req.body) {
//  | None => ()
//  | Some(body) =>
//    switch body->S.Json.decodeWith(authorStruct) {
//    | Error(a) => Js.Console.log(a)
//    | Ok(a) => Js.Console.log(a.id)
//    }
//  }
//  res->Response.sendString("Hello from POST!")
//})
//->Server.listen(3000, (_, _) => ())

