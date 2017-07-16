export default function (server) {

  server.route({
    path: '/api/malice/example',
    method: 'GET',
    handler(req, reply) {
      reply({ time: (new Date()).toISOString() });
    }
  });

}
