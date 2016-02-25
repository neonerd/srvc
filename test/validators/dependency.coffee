# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

dependencyValidator = require "../../src/validators/dependency"

# -- tests

describe 'dependency validator', () ->

	it 'should work when the right type is passed', () ->

		schema = 
			redis : {type : 'object'}

		expect(dependencyValidator({redis : {connect:1}}, schema)).to.equal(true)

	it 'should fail when the right type is not passed', () ->

		schema =
			redis : {type : 'object'}

		expect () ->
			dependencyValidator({redis : 1}, schema)
		.to.throw()

	it 'should work when not required', () ->

		schema =
			redis : {type: 'object', required : false}

		expect(dependencyValidator({}, schema)).to.equal(true)