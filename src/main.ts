import {registrationWithDepsApplied} from "./config.gen"

import {server} from "./driving/httpFastify/_main"

server.start({registration: registrationWithDepsApplied})

