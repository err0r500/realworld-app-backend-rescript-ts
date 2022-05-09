import {
  Maybe_nothing,
  ResultAsync_ok,
  ResultAsync_err,
  Err_tech,
} from "../../libs/prelude.gen";
import { name } from "../domain/user.gen";
import { UserRepo_getByName } from "../usecase/adapters.gen";

export const UserRepoKnex = () => {
  const getByName: UserRepo_getByName = async (_n: name) =>
    1 < 2 ? ResultAsync_ok(Maybe_nothing()) : ResultAsync_err(Err_tech());

  return {
    getByName,
  };
};
