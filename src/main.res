module RegistrationUC = Registration.UC(LoggerPino)

let registrationWithDepsApplied: Registration.pure = RegistrationUC.do(1)
HttpFastifyI.server.start(registrationWithDepsApplied)
