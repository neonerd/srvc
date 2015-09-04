# -- UTILS

validators = require("./core").validators

# -- DEPENDENCY OBJECT VALIDATOR

dependencyValidator = (dependencies, schema, strict=true) ->

	if(!validators.array(dependencies))
		throw Error("Srvc validation error: Dependencies need to be passed as an array!")

	

# -- EXPORT

module.exports = dependencyValidator