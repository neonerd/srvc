# -- ERRORS

generateError = (type, params) ->

	params = {} unless params?

	return {
		type : type
		params : params
	}

# -- HELPERS

helpers =

	max : (value, maxValue) ->

		if(value <= maxValue)
			return []
		else
			return [generateError('valueBig', {maxValue : maxValue})]

	min : (value, minValue) ->

		if(value >= minValue)
			return []
		else
			return [generateError('valueSmall', {minValue : minValue})]

	isIn : (value, possibleValues) ->

		if(possibleValues.indexOf(value) > -1)
			return []
		else
			return [ generateError('valueInvalid', {possibleValues : possibleValues}) ]

# -- VALIDATOR TYPES

validators =

	# PRIMITIVES
	string : (value, opts) ->

		errors = []
		opts = {} unless opts?

		if(typeof value == "string")

			if(opts.maxLength?)
				if(value.length > opts.maxLength)
					errors.push generateError('valueLength', {max : opts.maxLength, current : value.length})

			if(opts.minLength?)
				if(value.length < opts.minLength)
					errors.push generateError('valueLength', {min : opts.minLength, current : value.length})

			if(opts.regex?)
				if(!opts.regex.test(value))
					errors.push generateError('valueInvalid')

			if(opts.isIn?) then errors = errors.concat(helpers.isIn(value, opts.isIn))

		else
			errors.push generateError('valueType')

		return errors

	number : (value, opts) ->
		if(typeof value == "number")
			return []
		else
			return [ generateError('valueInvalid') ]

	float : (value, opts) ->
		if(parseFloat(value)==value)
			return []
		else
			return [ generateError('valueInvalid') ]

	int : (value, opts) ->
		if(parseInt(value)==value)
			return []
		else
			return [ generateError('valueInvalid') ]

	object : (obj, opts) ->

		errors = []

		if(typeof obj != 'object' || typeof obj == "string")
			errors.push generateError('valueType', {})

		return errors

	# OBJECTS WITH SCHEMA
	schema : (obj, opts) ->
		errors = []
		schema = {}

		if(!opts.schema?)
			throw new Error("Schema validator expecting schema in options!")

		schema = opts.schema

		if(typeof obj != 'object' || typeof obj == "string")
			errors.push generateError('valueType', {})
		
		else
			
			# determine which properties are required, if strict
			requiredProperties = []

			if(opts.strict || !opts.strict?)
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

				validatorErrors = validator(value, opts)
				if(validatorErrors.length > 0)
					errors.push generateError('valueInvalid', {errors : validatorErrors})

				else
					if(requiredProperties.indexOf(name) > -1)
						requiredProperties.splice requiredProperties.indexOf(name), 1

			if(requiredProperties.length > 0)
				errors.push generateError('missingValues', {names : requiredProperties})

		return errors

	# ARRAYS
	array : (value, opts) ->

		errors = []
		opts = {} unless opts?

		if(Array.isArray(value))

			if(opts.elType?)
				# validate each array element
				for el in value

					if(typeof opts.elType == "string")
						elType = opts.elType
						elTypeOpts = {}
					else
						elType = opts.elType.type
						elTypeOpts = opts.elType.opts

					validatorErrors = validators[elType](el, elTypeOpts)
					if(validatorErrors.length > 0)
						errors.push generateError('valueInvalid', {errors : validatorErrors})

		else
			errors.push generateError('valueType')

		return errors

	# CUSTOM VALIDATOR
	custom : (value, opts) ->

		if(!opts.validator?)
			throw new Error('Missing custom validator function!')

		output = opts.validator(value)

		if(validators.array(output).length > 0)
			throw new Error('Output of the validator function needs to be an array of errors!')

		return output

	# SPECIAL
	email : (value, opts) ->


 

# -- EXPORT

module.exports = 

	validators : validators