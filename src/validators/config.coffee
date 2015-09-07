# -- UTILS

validators = require("./core").validators

# -- CONFIG OBJECT VALIDATOR

configValidator = (config, schema) ->

	opts = {
		schema : schema
	}

	errors = validators.schema(config, opts)

	if(errors.length > 0)
		throw {
			error : 'Validation failed'
			list : errors
		}

	else
		return true

# -- MAIN EXPORT
module.exports = configValidator