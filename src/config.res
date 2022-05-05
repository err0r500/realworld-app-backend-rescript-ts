module RegistrationUC = Registration.UC(LoggerPino)

@genType let registrationWithDepsApplied: Registration.pure = RegistrationUC.do(1)
