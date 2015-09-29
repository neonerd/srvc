# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

coreValidators = require("../../../src/validators/core").validators

# -- tests

describe 'object validator', () ->

	it 'should pass a simple object', () ->

		expect(coreValidators.object({foo:'bar'}).length).to.equal(0)

	it 'should pass object with propType', () ->

		expect(coreValidators.object({foo:1}, {propType : 'int'}).length)
		.to.equal(0)

	it 'should fail', () ->

		expect(coreValidators.object(1).length)
		.to.equal(1)

	it 'should fail with propType', () ->

		expect(coreValidators.object({foo:'1'}, {propType : 'int'}).length)
		.to.equal(1)