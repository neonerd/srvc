# -- dependencies

chai = require "chai"
srvc = require "../src"

# -- test tools

expect = chai.expect;

# -- TESTS

describe 'when defining a service', () ->

	schema = 
		config : {
			apiKey : 'string'
		}
		dependencies : {

		}
		methods : {
			authenticate :

				parameters : {user:'string',password:'string'}
				dispatcher : (parameters, dependencies, config) ->

					return 'foo'

		}
		
	it 'should return a service constructor', () ->

		serviceConstructor = srvc.define 'client', schema
		expect(serviceConstructor).to.be.a('function')

	it 'should return a service constructor with the right function', () ->

		serviceConstructor = srvc.define 'client', schema
		client = serviceConstructor {apiKey : '98gbiyuas'}

		expect(client.authenticate).to.be.a('function')

		expect () ->
			client.authenticate {user:'a'}
		.to.throw()

		expect(client.authenticate({user:'a',password:'b'})).to.equal('foo')

	it 'should run a predefined setup function upon construction', () ->

		schemaWithSetup =
			config :
				foo : 'string'
			dependencies : {}
			methods : {}
			setup : (config, dependencies) ->

				if(config.foo == 'bar')
					return true

				else
					throw new Error()

		serviceConstructor = srvc.define 'setup', schemaWithSetup
		service = serviceConstructor({foo:'bar'})

		expect () ->

			s = serviceConstructor({foo:'notbar'})

		.to.throw()
