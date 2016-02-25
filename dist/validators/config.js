(function() {
  var configValidator, validators;

  validators = require("./core").validators;

  configValidator = function(config, schema) {
    var errors, opts;
    opts = {
      schema: schema
    };
    errors = validators.schema(config, opts);
    if (errors.length > 0) {
      throw {
        error: 'Configuration object passed to configValidator is invalid!',
        list: errors
      };
    } else {
      return true;
    }
  };

  module.exports = configValidator;

}).call(this);
