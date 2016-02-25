(function() {
  module.exports = {
    SRVC_NAME_KEY: '__srvc_name',
    SRVC_SCHEMA: {
      config: {
        type: 'object'
      },
      dependencies: {
        type: 'object'
      },
      methods: {
        type: 'object',
        opts: {
          propType: {
            type: 'schema',
            opts: {
              schema: {
                parameters: 'object',
                dispatcher: 'func'
              }
            }
          }
        }
      },
      setup: {
        type: 'func',
        required: false
      }
    }
  };

}).call(this);
