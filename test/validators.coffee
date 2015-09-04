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

	it 'should validate float correctly', () ->

		expect () ->
			configValidator {price : 'assa'}, {price : 'float'}
		.to.throw()

		expect(configValidator({price:87.2}, {price : 'float'})).to.equal(true)

	it 'should validate int correctly', () ->

		expect () ->
			configValidator {price : 19.4}, {price : 'int'}
		.to.throw()

		expect(configValidator({price:87}, {price : 'int'})).to.equal(true)

	it 'should validate object correctly', () ->

		expect () ->
			configValidator {obj : '2323'}, {obj : 'object'}
		.to.throw()

		expect(configValidator({obj:{a:'b'}}, {obj : 'object'})).to.equal(true)

	it 'should validate subschema correctly', () ->

		subSchema = 

			host : 'string'
			user : {type : 'object', required : true, opts: {
					schema : {
						name : 'string'
						password : 'string'
					}
				}}

		expect(configValidator({host:'lol',user:{ name : 'lol', password : 'lol' }}, subSchema)).to.equal(true)

	it 'should validate subschema correctly if not valid', () ->

		subSchema = 

			host : 'string'
			user : {type : 'schema', required : true, opts: {
					name : 'string'
					password : 'string'
				}}

		expect () ->
			configValidator {host:'lol',user:{ name : 'lol' }}, subSchema
		.to.throw()


	it 'should validate array correctly', () ->

		# simple
		expect () ->
			configValidator {prices : 1}, {prices : 'array'}
		.to.throw()

		expect(configValidator({prices:[1,2]}, {prices : 'array'})).to.equal(true)

	it 'should validate subtyped array correctly', () ->

		subSchema =
			prices : {type : 'array', opts : {elType : 'float'}}

		expect () ->
			configValidator {prices : ['s', 1]}, subSchema
		.to.throw()

		expect(configValidator({prices:[4, 5.4]}, subSchema)).to.equal(true)

		subSchema2 =
			users : {type : 'array', opts : {
						elType : {
							type : 'object'
							opts : {
								schema : {
									user : 'string'
									password : 'string'
								}
							}
						}
					}}

		expect () ->
			configValidator {users : [{user: 'lallal', password : 'lasas'}, {usr : 'lalala'}]}, subSchema2
		.to.throw()

		expect(configValidator({users:[{user:'lala',password:'lolo'}]}, subSchema2)).to.equal(true)
