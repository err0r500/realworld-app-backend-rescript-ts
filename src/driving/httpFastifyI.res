type t = {start: Registration.pure => unit}

@module("./httpFastify") external server: t = "server"
