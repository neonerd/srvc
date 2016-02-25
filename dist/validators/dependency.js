(function() {
  var configValidator, dependencyValidator, validators;

  validators = require("./core").validators;

  configValidator = require("./config");

  dependencyValidator = function(dependencies, schema) {
    if (validators.object(dependencies).length > 0) {
      throw Error("Srvc validation error: Dependencies need to be passed as an object hash!");
    }
    configValidator(dependencies, schema);
    return true;
  };

  module.exports = dependencyValidator;

}).call(this);
