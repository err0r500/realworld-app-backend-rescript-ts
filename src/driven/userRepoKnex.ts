import {
  Maybe_t,
  Maybe_nothing,
  ResultAsync_t,
  ResultAsync_ok,
  Err_techOnly,
} from "../../libs/prelude.gen";
import { name, t as user } from "../domain/user.gen";

export const UserRepoKnex = {
  getByName: async (_n: name) => {
    console.log("hello from UserRepoKnex.getByName");
    const x: ResultAsync_t<Maybe_t<user>, Err_techOnly> = ResultAsync_ok(
      Maybe_nothing()
    );
    return x;
  },
};
