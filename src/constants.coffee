module.exports =

	# used to identify service after construction
	SRVC_NAME_KEY : '__srvc_name'

	# used to validate schema definition
	SRVC_SCHEMA :

		config : {type : 'object'}
		dependencies : {type : 'object'}

		methods : {
			type : 'object'
			opts : {
				propType : { type : 'schema', opts : {
					schema : {
						parameters : 'object'
						dispatcher : 'func'
					}
				} }
			}
		}

		setup : {
			type : 'func'
			required : false
		}