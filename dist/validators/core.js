(function() {
  var constants, generateError, helpers, validators;

  generateError = function(type, params) {
    if (params == null) {
      params = {};
    }
    return {
      type: type,
      params: params
    };
  };

  constants = "../constants";

  helpers = {
    max: function(value, maxValue) {
      if (value <= maxValue) {
        return [];
      } else {
        return [
          generateError('valueBig', {
            maxValue: maxValue
          })
        ];
      }
    },
    min: function(value, minValue) {
      if (value >= minValue) {
        return [];
      } else {
        return [
          generateError('valueSmall', {
            minValue: minValue
          })
        ];
      }
    },
    isIn: function(value, possibleValues) {
      if (possibleValues.indexOf(value) > -1) {
        return [];
      } else {
        return [
          generateError('valueInvalid', {
            possibleValues: possibleValues
          })
        ];
      }
    }
  };

  validators = {
    string: function(value, opts) {
      var errors;
      errors = [];
      if (opts == null) {
        opts = {};
      }
      if (typeof value === "string") {
        if ((opts.maxLength != null)) {
          if (value.length > opts.maxLength) {
            errors.push(generateError('valueLength', {
              max: opts.maxLength,
              current: value.length
            }));
          }
        }
        if ((opts.minLength != null)) {
          if (value.length < opts.minLength) {
            errors.push(generateError('valueLength', {
              min: opts.minLength,
              current: value.length
            }));
          }
        }
        if ((opts.regex != null)) {
          if (!opts.regex.test(value)) {
            errors.push(generateError('valueInvalid'));
          }
        }
        if ((opts.isIn != null)) {
          errors = errors.concat(helpers.isIn(value, opts.isIn));
        }
      } else {
        errors.push(generateError('valueType'));
      }
      return errors;
    },
    number: function(value, opts) {
      var errors;
      errors = [];
      if (opts == null) {
        opts = {};
      }
      if (typeof value === "number") {
        if ((opts.max != null)) {
          errors = errors.concat(helpers.max(value, opts.max));
        }
        if ((opts.min != null)) {
          errors = errors.concat(helpers.min(value, opts.min));
        }
        if ((opts.isIn != null)) {
          errors = errors.concat(helpers.isIn(value, opts.isIn));
        }
      } else {
        errors.push(generateError('valueInvalid'));
      }
      return errors;
    },
    float: function(value, opts) {
      if (parseFloat(value) === value) {
        return [];
      } else {
        return [generateError('valueInvalid')];
      }
    },
    int: function(value, opts) {
      if (parseInt(value) === value) {
        return [];
      } else {
        return [generateError('valueInvalid')];
      }
    },
    func: function(value, opts) {
      if (typeof value === 'function') {
        return [];
      } else {
        return [generateError('valueInvalid')];
      }
    },
    object: function(obj, opts) {
      var errors, name, propType, propTypeOpts, validatorErrors, value;
      errors = [];
      if (opts == null) {
        opts = {};
      }
      if (typeof obj !== 'object' || typeof obj === "string") {
        errors.push(generateError('valueType', {}));
      } else {
        if ((opts.propType != null)) {
          for (name in obj) {
            value = obj[name];
            if (typeof opts.propType === "string") {
              propType = opts.propType;
              propTypeOpts = {};
            } else {
              propType = opts.propType.type;
              propTypeOpts = opts.propType.opts;
            }
            validatorErrors = validators[propType](value, propTypeOpts);
            if (validatorErrors.length > 0) {
              errors.push(generateError('valueInvalid', {
                errors: validatorErrors
              }));
            }
          }
        }
      }
      return errors;
    },
    schema: function(obj, opts) {
      var definition, errors, name, requiredProperties, schema, validator, validatorErrors, value;
      errors = [];
      schema = {};
      if (opts.schema == null) {
        throw new Error("Schema validator expecting schema in options!");
      }
      schema = opts.schema;
      if (typeof obj !== 'object' || typeof obj === "string") {
        errors.push(generateError('valueType', {}));
      } else {
        requiredProperties = [];
        if (opts.strict || (opts.strict == null)) {
          for (name in schema) {
            definition = schema[name];
            if (typeof definition === "string") {
              requiredProperties.push(name);
            } else {
              if (definition.required) {
                requiredProperties.push(name);
              }
            }
          }
        }
        for (name in obj) {
          value = obj[name];
          definition = schema[name];
          if (typeof definition === "string") {
            validator = validators[definition];
          } else {
            validator = validators[definition.type];
          }
          opts = {};
          if ((definition.opts != null)) {
            opts = definition.opts;
          }
          validatorErrors = validator(value, opts);
          if (validatorErrors.length > 0) {
            errors.push(generateError('valueInvalid', {
              errors: validatorErrors
            }));
          } else {
            if (requiredProperties.indexOf(name) > -1) {
              requiredProperties.splice(requiredProperties.indexOf(name), 1);
            }
          }
        }
        if (requiredProperties.length > 0) {
          errors.push(generateError('missingValues', {
            names: requiredProperties
          }));
        }
      }
      return errors;
    },
    array: function(value, opts) {
      var el, elType, elTypeOpts, errors, i, len, validatorErrors;
      errors = [];
      if (opts == null) {
        opts = {};
      }
      if (Array.isArray(value)) {
        if ((opts.elType != null)) {
          for (i = 0, len = value.length; i < len; i++) {
            el = value[i];
            if (typeof opts.elType === "string") {
              elType = opts.elType;
              elTypeOpts = {};
            } else {
              elType = opts.elType.type;
              elTypeOpts = opts.elType.opts;
            }
            validatorErrors = validators[elType](el, elTypeOpts);
            if (validatorErrors.length > 0) {
              errors.push(generateError('valueInvalid', {
                errors: validatorErrors
              }));
            }
          }
        }
      } else {
        errors.push(generateError('valueType'));
      }
      return errors;
    },
    custom: function(value, opts) {
      var output;
      if (opts.validator == null) {
        throw new Error('Missing custom validator function!');
      }
      output = opts.validator(value);
      if (validators.array(output).length > 0) {
        throw new Error('Output of the validator function needs to be an array of errors!');
      }
      return output;
    },
    email: function(value, opts) {},
    service: function(value, opts) {
      if (validators.object(value).length > 0) {
        return [generateError('valueType')];
      }
      if (value[constants.SRVC_NAME_KEY] !== opts.name) {
        return [generateError('serviceType')];
      }
      return [];
    }
  };

  module.exports = {
    validators: validators
  };

}).call(this);
