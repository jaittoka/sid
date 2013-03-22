
istr = ('          ' for i in [0...10]).join '          '

itemToString = (item, level = 0) ->
  value = if item.value? then JSON.stringify(item.value) else ''
  """
    #{istr.substring 0, level*2}#{item.name} #{value}
    #{(itemToString(c, level+1) for c in item.children).join ''}
  """

maybeGetJSON = (v, opts) ->
  if v?
    try
      eval "(#{v})"
    catch error
      console.log "Invalid value: #{v}"

calculateIndentLevel = (indent, tabSize) -> 
  res = 0
  indent.replace /( )|(\t)/g, (all, s, t) ->
    if s?
      res++
    else if t?
      res += tabSize
  res

DEFAULT_TAB_SIZE = 4  
TOKEN_PATTERN = /(?:(?:^|(?:\r|\n)+)([ \t]*))(\w+)(?:[ \t]+([^\r\n]*))?/g
T_INDENT = 1
T_DEINDENT = 2
T_ITEM = 3

tokenize = (str, tabSize) ->
  result = []
  levels = []
  level = 0
  while (m = TOKEN_PATTERN.exec str)?
    n = calculateIndentLevel m[1], tabSize
    if n > level
      levels.push level
      level = n
      result.push { type: T_INDENT }
    else if n < level
      while n < level
        result.push { type: T_DEINDENT } 
        level = levels.pop()
    result.push { type: T_ITEM, name: m[2], value: maybeGetJSON m[3] }
    
  while levels.length > 0
    levels.pop()
    result.push { type: T_DEINDENT } 
  result

parse = (str, opts = {}) ->
  parents = [ ]
  parent = { name: 'ROOT', value: '', children: [] }
  for s in tokenize String(str), opts.tabSize or DEFAULT_TAB_SIZE
    switch s.type
      when T_INDENT
        parents.push parent
        parent = item
      when T_DEINDENT
        parent = parents.pop()
      when T_ITEM
        item = 
          name: s.name
          value: if typeof s.value is 'function' then s.value opts else s.value
          children: []
        parent.children.push item
      else
        throw new Error 'Invalid item type: '+s.type
  parent.children

module.exports = {
  parse
  tokenize
  itemToString
}

