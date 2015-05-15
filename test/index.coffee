# -- dependencies

chai = require "chai"
srvc = require "../src"

# -- test tools

expect = chai.expect;

# -- TESTS

describe 'when defining a service', () ->

	it 'should return a service constructor', () ->

		serviceConstructor = srvc.define 'client', {}
		expect(serviceConstructor).to.be.a('function')