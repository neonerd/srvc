# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

coreValidators = require("../../../src/validators/core").validators

# -- tests

describe 'number validator', () ->

	it 'should work with a normal number', () ->

		expect(coreValidators.number(1).length).to.equal(0)

	it 'should fail with something else than number', () ->

		expect(coreValidators.number('1').length).to.equal(1)

	it 'should work with max option', () ->

		expect(coreValidators.number(5, {max:6}).length).to.equal(0)
		expect(coreValidators.number(7, {max:6}).length).to.equal(1)

	it 'should work with min option', () ->

		expect(coreValidators.number(5, {min:4}).length).to.equal(0)
		expect(coreValidators.number(3, {min:4}).length).to.equal(1)

	it 'should work with isIn option', () ->

		expect(coreValidators.number(5, {isIn:[4,5,6]}).length).to.equal(0)
		expect(coreValidators.number(3, {isIn:[4,5,6]}).length).to.equal(1)