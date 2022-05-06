import { registrationUC } from "./config.gen";
import { UserRepoKnex } from "./driven/userRepoKnex";
import { startServer } from "./driving/httpFastify/_main";

startServer({ registration: registrationUC(UserRepoKnex.getByName) });
