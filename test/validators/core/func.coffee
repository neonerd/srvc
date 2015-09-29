# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

coreValidators = require("../../../src/validators/core").validators

# -- tests

describe 'func validator', () ->

	it 'should pass', () ->

		f = () ->
			return 1

		expect(coreValidators.func(f).length).to.equal(0)


	it 'should fail', () ->

		f = 'hello world'

		expect(coreValidators.func(f).length).to.equal(1)