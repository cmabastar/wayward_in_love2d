
----------------------------------------

local function sortcomp( l, r )
  if type(l)=="number" and type(r)=="string" then return false end
  if type(l)=="string" and type(r)=="number" then return true end
  return l < r
end

local function print_r(t, indent)
  if not t then return end
  local indent=indent or ''
  local keys = {}
  for k, _ in pairs(t) do
    keys[#keys+1]=k
  end
  table.sort( keys, sortcomp )
  for _, key in ipairs(keys) do
    local value = t[key]
    io.write(indent,'[',tostring(key),']') 
    if type(value)=="table" then io.write(':\n') print_r(value,indent..' ')
    else io.write(' = ',tostring(value),'\n') end
  end
end

local function bounded( a, b, c )
  return math.max( a, math.min( b, c ) )
end

local function random( l, r )
  local d = math.random( 0, 10000 ) / 10000 
  return l + (d * (r - l))
end

local function fuzzycmp( x, y )
  local r = math.abs(x - y)
  return ( ( r < 0.001 ) and true ) or false
end

local function shuffle( list )
  local N = #list
  for i = 1, N do
    local x = math.random( i, N )
    list[i], list[x] = list[x], list[i]
  end
end

----------------------------------------

return {
  print_r = print_r;
  bounded = bounded;
  random = random;
  fuzzycmp = fuzzycmp;
  shuffle = shuffle;
}

----------------------------------------
