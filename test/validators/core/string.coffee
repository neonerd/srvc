# -- dependencies

chai = require "chai"

# -- test tools

expect = chai.expect;

# -- tested parts

coreValidators = require("../../../src/validators/core").validators

# -- tests

describe 'string validator', () ->

	it 'should validate value type', () ->

		expect(coreValidators.string('hello world').length).to.equal(0)
		expect(coreValidators.string(1).length).to.equal(1)

	it 'should validate max length', () ->

		expect(coreValidators.string('toooooooo large', {maxLength : 5}).length).to.equal(1)
		expect(coreValidators.string('ok', {maxLength: 5}).length).to.equal(0)

	it 'should validate min length', () ->

		expect(coreValidators.string('toooooooo large', {minLength : 5}).length).to.equal(0)
		expect(coreValidators.string('ok', {minLength: 5}).length).to.equal(1)

	it 'should validate regex', () ->

		expect(coreValidators.string('', {regex : /.+/}).length).to.equal(1)
		expect(coreValidators.string('00', {regex : /.+/}).length).to.equal(0)

	it 'should validate is in', () ->

		expect(coreValidators.string('foo', {isIn : ['bar']}).length).to.equal(1)
		expect(coreValidators.string('bar', {isIn : ['bar']}).length).to.equal(0)