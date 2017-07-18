import { resolve } from 'path';
import exampleRoute from './server/routes/example';

export default function (kibana) {
  return new kibana.Plugin({
    require: ['elasticsearch'],
    name: 'malice',
    uiExports: {

      app: {
        title: 'Malice',
        description: 'Malice Kibana Plugin',
        main: 'plugins/malice/app',
        icon: 'plugins/malice/icon.svg'
      },


      translations: [
        resolve(__dirname, './translations/es.json')
      ],


      hacks: [
        'plugins/malice/hack'
      ]

    },

    config(Joi) {
      return Joi.object({
        enabled: Joi.boolean().default(true),
      }).default();
    },


    init(server, options) {
      server.log(['status', 'info', 'malice'], 'Malice Initializing');
      // Add server routes and initalize the plugin here
      exampleRoute(server);
    }


  });
};
