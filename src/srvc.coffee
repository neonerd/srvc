# -- 

constants = require "./constants"

configValidator = require "./validators/config"
dependencyValidator = require "./validators/dependency"

# -- Main srvc module

srvc = 

	define : (name, schema) ->

		try 
			configValidator(schema, constants.SRVC_SCHEMA)
		catch e
			throw new Error("Service could not be defined, schema invalid!")

		return (config, dependencies) ->

			config = {} unless config?
			dependencies = {} unless dependencies?

			# validate configuration and dependencies
			try
				configValidator(config, schema.config)
			catch e
				throw new Error("Configuration object invalid!")

			try
				dependencyValidator(dependencies, schema.dependencies)
			catch e
				throw new Error("Dependencies invalid!")

			# create basic object
			service = {}
			service[constants.SRVC_NAME_KEY] = name

			# run setup function if any
			if(schema.setup?)
				schema.setup(config, dependencies)

			# go through methods, create wrapping functions
			for methodName, methodDefinition of schema.methods

				do (methodName, methodDefinition) ->

					service[methodName] = (parameters) ->

						try
							configValidator(parameters, methodDefinition.parameters)
						catch e
							throw new Error("Parameters object invalid!")

						return methodDefinition.dispatcher(parameters, dependencies, config)
			
			# return the service
			return service

# -- Export

module.exports = srvc