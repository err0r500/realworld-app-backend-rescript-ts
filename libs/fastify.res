module Request = {
  type t = {body: Js.nullable<Js.Json.t>}
}

module Response = {
  type t

  @send external sendString: (t, string) => unit = "send"
}

module Server = {
  type t

  @module("fastify") external server: unit => t = "fastify"

  type port = int
  type error = Js.Nullable.t<exn>
  type address = string
  @send external listen: (t, port, (error, address) => unit) => unit = "listen"
}

module Route = {
  type handler = (Request.t, Response.t) => unit
  type path = string
  @send external get: (Server.t, path, handler) => Server.t = "get"
  @send external post: (Server.t, path, handler) => Server.t = "post"

  //module WithSchema = {
  //  type req = {body: Js.Json.t}
  //  type body = {body: JsonSchema.t}
  //  type schema = {schema: body}
  //  type handlerWithSchema = (req, Response.t) => unit

  //  @send
  //  external _post: (Server.t, path, schema, handlerWithSchema) => Server.t = "post"

  //  let post = (
  //    server: Server.t,
  //    path: path,
  //    schema: Struct.t<'a>,
  //    handler: handlerWithSchema,
  //  ): Server.t => _post(server, path, {schema: {body: JsonSchema.make(schema)}}, handler)
  //}
}
