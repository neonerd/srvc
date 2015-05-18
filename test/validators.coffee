# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

configValidator = require "../src/validators/config"

# -- tests

describe 'config validator', () ->

	schema =

		host : 'string'
		port : {type : 'number', required : false}

	it 'should validate required and optional parameters correctly', () ->

		expect () ->
			configValidator {port : 3000}, schema
		.to.throw()

		expect(configValidator({host:'lol'}, schema)).to.equal(true)

	it 'should validate string correctly', () ->

		expect () ->
			configValidator {host : 1}, schema
		.to.throw()

		expect(configValidator({host:'lol'}, schema)).to.equal(true)

	it 'should validate number correctly', () ->

		expect () ->
			configValidator {host : 'lol', port : 'lol'}, schema
		.to.throw()

		expect(configValidator({host:'lol', port : 1}, schema)).to.equal(true)

	it 'should validate subschema correctly', () ->

		subSchema = 

			host : 'string'
			user : {type : 'schema', required : true, opts: {
					name : 'string'
					password : 'string'
				}}

		expect(configValidator({host:'lol',user:{ name : 'lol', password : 'lol' }}, subSchema)).to.equal(true)