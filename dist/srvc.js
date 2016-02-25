(function() {
  var configValidator, constants, dependencyValidator, srvc;

  constants = require("./constants");

  configValidator = require("./validators/config");

  dependencyValidator = require("./validators/dependency");

  srvc = {
    define: function(name, schema) {
      var e, error;
      try {
        configValidator(schema, constants.SRVC_SCHEMA);
      } catch (error) {
        e = error;
        throw new Error("Service could not be defined, schema invalid!");
      }
      return function(config, dependencies) {
        var error1, error2, fn, methodDefinition, methodName, ref, service;
        if (config == null) {
          config = {};
        }
        if (dependencies == null) {
          dependencies = {};
        }
        try {
          configValidator(config, schema.config);
        } catch (error1) {
          e = error1;
          throw new Error("Configuration object invalid!");
        }
        try {
          dependencyValidator(dependencies, schema.dependencies);
        } catch (error2) {
          e = error2;
          throw new Error("Dependencies invalid!");
        }
        service = {};
        service[constants.SRVC_NAME_KEY] = name;
        if ((schema.setup != null)) {
          schema.setup(config, dependencies);
        }
        ref = schema.methods;
        fn = function(methodName, methodDefinition) {
          return service[methodName] = function(parameters) {
            var error3;
            if (parameters == null) {
              parameters = {};
            }
            try {
              configValidator(parameters, methodDefinition.parameters);
            } catch (error3) {
              e = error3;
              throw new Error("Parameters object invalid!");
            }
            return methodDefinition.dispatcher(parameters, dependencies, config);
          };
        };
        for (methodName in ref) {
          methodDefinition = ref[methodName];
          fn(methodName, methodDefinition);
        }
        return service;
      };
    }
  };

  module.exports = srvc;

}).call(this);
