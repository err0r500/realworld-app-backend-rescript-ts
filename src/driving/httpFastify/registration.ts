import { Static, Type } from "@sinclair/typebox";
import { name, email, password } from "../../domain/user.gen";
import { pure as registrationUC } from "../../usecase/registration.gen";
import { FastifyInstance } from "fastify";
import { match } from "ts-pattern";

const ReqBody = Type.Object({
  name: Type.String(),
  mail: Type.String({ format: "email" }),
  password: Type.String(),
});
type ReqBody = Static<typeof ReqBody>;

export const registration = (uc: registrationUC) => {
  return (fastify: FastifyInstance) =>
    fastify.post<{
      Body: ReqBody;
      Reply: string;
    }>("/", { schema: { body: ReqBody } }, async (req, reply) => {
      const userOrErr = await uc(
        name(req.body.name),
        email(req.body.mail),
        password(req.body.password)
      );

      req.log.info(userOrErr)

      return match(userOrErr)
        .with({ tag: "Ok" }, ({ value }) => reply.send(value.name.value))
        .with({ tag: "Error", value: "Tech" }, () => reply.code(500).send())
        .with(
          {
            tag: "Error",
            value: {
              tag: "Business",
              value: "UserConflict",
            },
          },
          () => reply.code(409).send()
        )
        .exhaustive();
    });
};
