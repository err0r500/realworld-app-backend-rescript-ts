import fastify from "fastify";
import { registration } from "./registration";
import { pure as registrationUC } from "../../usecase/registration.gen";

export const startServer = (usecases: { registration: registrationUC }) => {
    const fastifyServer = fastify({ logger: true });

    fastifyServer.register(registration(usecases.registration));

    fastifyServer.listen(3000, function (err, _address) {
      if (err) {
        fastifyServer.log.error(err);
        process.exit(1);
      }
    });
};
