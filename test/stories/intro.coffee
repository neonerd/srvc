# -- dependencies

chai = require "chai"
srvc = require "../../src"

# -- test tools

expect = chai.expect;

###

This is a short introduction scenario into srvc.

1. We'll set up an authentication service that isssues, validates and invalidates authentication tokens.
2. We'll set up a user login service that validates email / password and uses authentication service to issue a new token.

###

describe 'user story - introduction', () ->

	it 'should work', () ->

		authenticationService = srvc.define 'authentication', {

			dependencies : {
				redis : {type : 'object'}
			}
			config : {

			}

			methods :

				createToken : 

					parameters : {}
					dispatcher : (params, dependencies, config) ->

				validateToken :

					parameters : {}
					dispatcher : (params, dependencies, config) ->

				invalidateToken : 

					parameters : {}
					dispatcher : (params, dependencies, config) ->

		}

		userLoginService = srvc.define 'user/login', {

			dependencies : {

				authentication : {type : 'service', name : 'authentication'}

			}
			config : {

				salt : 'string'
				
			}

		}
