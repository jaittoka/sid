Background
----------

SID is a simple hierarchial data definition language. I created it just 
for simplifying the data normally entered in JSON-format.

It is very lightweight: code is less than 80 lines of CoffeeScript and it has
no dependencies to other modules.

Overview
--------

Item in SID contains a name, value and children. Value can be anything that is a valid Javascript expression.

Items are specified hierarchially using indentation.

For example (in CoffeeScript):
```
{ parse } = require 'sid'
data = """
  person
    name 'John Doe'
    address
      street 'W 38th St 412'
      code 94823
      town 'New York'
    address
      street 'Chestnut St 12'
      code 52362
      town 'San Francisco'
"""
console.log JSON.stringify parse(data), null, '  '

```

Above code would print:
```
[
  {
    "name": "person",
    "children": [
      {
        "name": "name",
        "value": "John Doe",
        "children": []
      },
      {
        "name": "address",
        "children": [
          {
            "name": "street",
            "value": "W 38th St 412",
            "children": []
          },
          {
            "name": "code",
            "value": 94823,
            "children": []
          },
          {
            "name": "town",
            "value": "New York",
            "children": []
          }
        ]
      },
      {
        "name": "address",
        "children": [
          {
            "name": "street",
            "value": "Chestnut St 12",
            "children": []
          },
          {
            "name": "code",
            "value": 52362,
            "children": []
          },
          {
            "name": "town",
            "value": "San Francisco",
            "children": []
          }
        ]
      }
    ]
  }
]
```
