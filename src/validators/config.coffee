# -- UTILS

validators = require("./core").validators

# -- Configuration object validator

configValidator = (config, schema) ->

	opts = {
		schema : schema
	}

	errors = validators.schema(config, opts)

	if(errors.length > 0)
		throw {
			error : 'Configuration object passed to configValidator is invalid!'
			list : errors
		}

	else
		return true

# -- MAIN EXPORT
module.exports = configValidator