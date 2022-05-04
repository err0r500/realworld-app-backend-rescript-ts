import fastify from "fastify";
import { Static, Type } from "@sinclair/typebox";
import { mkName, name } from "../domain/user.gen";
import { pure } from "../usecase/registration.gen";

export const server = ({
  start: (uc: pure) => {
    const server = fastify({ logger: true });

    const User = Type.Object({
      name: Type.String(),
      mail: Type.Optional(Type.String({ format: "email" })),
    });
    type UserType = Static<typeof User>;

    server.post<{
      Body: UserType;
      Reply: void;
    }>("/", {
      schema: { body: User },
      handler: async (req, reply) => {
        const x: name = mkName(req.body.name);
        const userOrErr = await uc(x);
        console.log(userOrErr);
        reply.send();
      },
    });

    server.listen(3000, function (err, address) {
      if (err) {
        server.log.error(err);
        process.exit(1);
      }
      // Server is now listening on ${address}
    });
  },
});
