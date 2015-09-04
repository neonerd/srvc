# -- ERRORS

generateError = (type, params) ->

	return {
		type : type
		params : params
	}

# -- VALIDATOR TYPES

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
		if(parseFloat(value)==value)
			return true
		else
			return false

	int : (value, opts) ->
		if(parseInt(value)==value)
			return true
		else
			return false

	schema : (value, opts) ->
		return opts.configValidator(value, opts)

	object : (obj, opts) ->

		errors = []
		schema = {}

		schema = opts.schema unless !opts.schema?

		if(typeof obj != 'object')
			errors.push generateError('valueType', {})
		
		else
			
			# determine which properties are required
			requiredProperties = []
			for name, definition of schema

				if(typeof definition == "string")
					requiredProperties.push name

				else
					if(definition.required)
						requiredProperties.push name

			# go through config and apply validators
			for name, value of obj

				definition = schema[name]

				if(typeof definition == "string")
					validator = validators[definition]

				else
					validator = validators[definition.type]

				opts = {}
				if(definition.opts?)
					opts = definition.opts

				if(!validator(value, opts))
					errors.push generateError('valueInvalid', {})

				else
					if(requiredProperties.indexOf(name) > -1)
						requiredProperties.splice requiredProperties.indexOf(name), 1

			if(requiredProperties.length > 0)
				errors.push generateError('missingValues', {names : requiredProperties})

		return errors

	array : (value, opts) ->

		pass = true

		if(Array.isArray(value))

			if(!opts.elType?)
				pass = true

			else
				# validate each array element
				for el in value

					if(typeof opts.elType == "string")
						elType = opts.elType
						elTypeOpts = {}
					else
						elType = opts.elType.type
						elTypeOpts = elType.opts

					if(!validators[elType](el, elTypeOpts))
						pass = false

		else
			pass = false

		return pass

# -- EXPORT

module.exports = 

	validators : validators