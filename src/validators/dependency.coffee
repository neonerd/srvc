# -- UTILS

validators = require("./core").validators
configValidator = require "./config"

# -- DEPENDENCY OBJECT VALIDATOR

dependencyValidator = (dependencies, schema) ->

	if(validators.object(dependencies).length > 0)
		throw Error("Srvc validation error: Dependencies need to be passed as an object hash!")

	configValidator(dependencies, schema)
	return true

# -- EXPORT

module.exports = dependencyValidator