# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

dependencyValidator = require "../../src/validators/dependency"

# -- tests

describe 'dependency validator', () ->

	it 'should work', () ->

		schema = 
			redis : {type : 'object'}

		expect(dependencyValidator({redis : {connect:1}}, schema)).to.equal(true)

	it 'should fail', () ->

		schema =
			redis : {type : 'object'}

		expect () ->
			dependencyValidator({redis : 1}, schema)
		.to.throw()