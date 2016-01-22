SRVC
====

A node.js layer for creating and working with functional (micro)services.

Concept
-------

*srvc* aims to provide a standarized, user-friendly way of defining interoperating services, communicating either in one application or via HTTP APIs. While it utilizes dependency injection, it remains purely functional (no classes, inheritance, magic methods) and doesn't have almost any additional footprint.

Installation
------------

```
npm install srvcs --save
```

Basic usage
-----------

A new service is defined via the publicly exposed srvc.define function that returns a constructor function.

srvc.define accepts a service name and its schema, which defines basic configuration rules for service construction, dependency schema for injecting dependencies and service methods.

```javascript
var srvc = require('srvc');

authService = srvc.define('auth', {
	config : {
		salt : 'string'
	},
	dependencies : {
		knex : 'object'
	},
	methods : {
		verifyToken : {
			parameters : {token : 'string'},
			dispatcher : function(parameters, dependencies, config) {
				// method implementation
			}
		}
	}
})
```


