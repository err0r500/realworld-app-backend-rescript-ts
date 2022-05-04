import fastify from "fastify";
import { Static, Type } from "@sinclair/typebox";
import { name, email, password } from "../domain/user.gen";
import { pure } from "../usecase/registration.gen";

export const server = {
  start: (uc: pure) => {
    const fastifyServer = fastify({ logger: true });

    const User = Type.Object({
      name: Type.String(),
      mail: Type.String({ format: "email" }),
      password: Type.String(),
    });
    type UserType = Static<typeof User>;

    fastifyServer.post<{
      Body: UserType;
      Reply: void;
    }>("/", {
      schema: { body: User },
      handler: async (req, reply) => {
        const userOrErr = await uc(
          name(req.body.name),
          email(req.body.mail),
          password(req.body.password)
        );
        console.log(userOrErr);
        reply.send();
      },
    });

    fastifyServer.listen(3000, function (err, _address) {
      if (err) {
        fastifyServer.log.error(err);
        process.exit(1);
      }
      // Server is now listening on ${address}
    });
  },
};
