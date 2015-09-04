srvc = 

	define : (name, schema) ->

		return (config, dependencies) ->

			service = {
				name : name
			}
			return service

module.exports = srvc