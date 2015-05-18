# -- VALIDATOR TYEPS

validators =

	string : (value, opts) ->
		if(typeof value == "string")
			return true
		else
			return false

	number : (value, opts) ->
		if(typeof value == "number")
			return true
		else
			return false

	float : (value, opts) ->
		return true

	int : (value, opts) ->
		return true

	schema : (value, opts) ->
		return configValidator(value, opts)

	object : (value, opts) ->
		if(typeof value == 'object')
			return true
		else
			return false


# -- MAIN FUNCTION

configValidator = (config, schema, strict=true) ->

	# determine which properties are required
	requiredProperties = []
	for name, definition of schema

		if(typeof definition == "string")
			requiredProperties.push name

		else
			if(definition.required)
				requiredProperties.push name

	# go through config and apply validators
	for name, value of config

		definition = schema[name]

		if(typeof definition == "string")
			validator = validators[definition]

		else
			validator = validators[definition.type]

		opts = {}
		if(definition.opts?)
			opts = definition.opts

		if(!validator(value, opts))
			throw Error("Srvc validation error: #{ name } is not valid!")

		else
			if(requiredProperties.indexOf(name) > -1)
				requiredProperties.splice requiredProperties.indexOf(name), 1

	if(requiredProperties.length > 0)
		throw Error("Srvc validation error: Missing required properties - #{ requiredProperties }")

	return true

# -- MAIN EXPORT
module.exports = configValidator