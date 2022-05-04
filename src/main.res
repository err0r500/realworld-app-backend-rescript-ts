let do: Registration.pure = _name => {
  Prelude.ResultAsync.err(Prelude.Err.Tech)
}

HttpFastifyI.server.start(do)
