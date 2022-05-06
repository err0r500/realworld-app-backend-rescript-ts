import { registrationUC } from "./config.gen";
import { UserRepoKnex } from "./driven/userRepoKnex";
import { startServer } from "./driving/httpFastify/_main";

const userRepo = UserRepoKnex();

startServer({ registration: registrationUC(userRepo.getByName) });
