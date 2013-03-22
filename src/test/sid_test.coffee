{ parse } = require '../../lib/sid'

exports.testSimpleNoValues = (test) ->
  result = parse """
    person
  """
  test.deepEqual result, [{
    'name': 'person'
  }]
  test.done()


exports.testSimpleOneValue = (test) ->
  result = parse """
    person 'foo'
  """
  test.deepEqual result, [{
    'name': 'person'
    'value': 'foo'
  }]
  test.done()

exports.testSimpleArrayValue = (test) ->
  result = parse """
    person [ 'foo', 'bar' ]
  """
  test.deepEqual result, [{
    'name': 'person'
    'value': [ 'foo', 'bar' ]
  }]
  test.done()

exports.testOneChild = (test) ->
  result = parse """
    person
      name 'John'
  """
  test.deepEqual result, [{
    'name': 'person'
    'children': [
      {
        name: 'name'
        value: 'John'
      }
    ]
  }]
  test.done()

exports.testSameNames = (test) ->
  result = parse """
    person
      address
        street 'Foo'
      address
        street 'Bar'
  """
  test.deepEqual result, [{
    'name': 'person'
    'children': [
      {
        name: 'address'
        children: [
          {
            name: 'street'
            value: 'Foo'
          }
        ]
      }
      {
        name: 'address'
        children: [
          {
            name: 'street'
            value: 'Bar'
          }
        ]
      }
    ]
  }]
  test.done()
