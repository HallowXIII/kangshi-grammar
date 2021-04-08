-- This is a BBCODE custom writer for pandoc.
--
-- Invoke with: pandoc --to bbcode.lua
--

-- Character escaping
local function escape(s)
  return s:gsub("([%[%]])", function (capture)
    if (capture == "]") then
      return "[/bk]"
    else
      return "[bk]"
    end
  end)
end

-- Blocksep is used to separate block elements.
function Blocksep()
  return "\n\n"
end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- This gives you a fragment.  You could use the metadata table to
-- fill variables in a custom lua template.  Or, pass `--template=...`
-- to pandoc, and pandoc will add do the template processing as
-- usual.
function Doc(body, metadata, variables)
  return body
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return escape(s)
end

function DoubleQuoted(s)
  return escape(s)
end

function SingleQuoted(s)
  return escape(s)
end

function Space()
  return " "
end

function SoftBreak()
  return "\n"
end

function LineBreak()
  return "\n\n"
end

function Emph(s)
  return ("[i]%s[/i]"):format(s)
end

function Strong(s)
  return ("[b]%s[/b]"):format(s)
end

function Subscript(s)
  return ("[sub]%s[/sub]"):format(s)
end

function Superscript(s)
  return ("[sup]%s[/sup]"):format(s)
end

function SmallCaps(s)
  return ("[size=85]%s[/size]"):format(s:upper())
end

function Strikeout(s)
  return ("[strike]%s[/strike]"):format(s)
end

function Link(s, src, tit, attr)
  return ("[url=%s]%s[/url]"):format(src, escape(s))
end

function Image(s, src, tit, attr)
  return ("[image]%s[/image]"):format(src)
end

function Code(s, attr)
  return ("[tt]%s[/tt]"):format(s)
end

function InlineMath(s)
  return ("[tt]%s[/tt]"):format(escape(s))
end

function DisplayMath(s)
  return ("[code]%s[/code]"):format(escape(s))
end

function Note(s)
  return Str(s)
end

function Span(s, attr)
  return s
end

function RawInline(format, str)
  return format == "bbcode"
    and str
    or ""
end

function Cite(s, cs)
  return ("??%s??"):format(escape(s))
end

function Plain(s)
  return s
end

function Para(s)
  return s
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
  local adjusted_header = lev > 5 and 5 or lev
  return ("[size=%d][b]%s[/b][/size]"):format(200 - 20*lev, s)
end

function BlockQuote(s)
  return ("[bq]%s[/bq]"):format(s)
end

function HorizontalRule()
  return "----"
end

function LineBlock(ls)
  return table.concat(ls, '\n')
end

function CodeBlock(s, attr)
  return ("[code]%s[/code]"):format(s)
end

function BulletList(items)
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, "[*] " .. item)
  end
  local itemstring = table.concat(buffer, "\n")
  return ("[list]\n%s\n[/list]"):format(itemstring)
end

function OrderedList(items)
  local buffer = {}
  for _, item in pairs(items) do
    table.insert(buffer, "[*] " .. item)
  end
  local itemstring = table.concat(buffer, "\n")
  return ("[list=1]\n%s\n[/list]"):format(itemstring)
end

function DefinitionList(items)
  return BulletList(items)
end

function CaptionedImage(src, tit, caption, attr)
   return Image(caption, src, tit, attr)
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  local buffer = {}
  local function add(s)
    table.insert(buffer, s)
  end
  add("[table]")
  local header_row = {}
  local empty_header = true
  for _, h in pairs(headers) do
    table.insert(header_row, ("[cell]%s[/cell]"):format(h))
    empty_header = empty_header and h == ""
  end
  if empty_header then
    head = ""
  else
    add(("[rowh]%s[/rowh]"):format(table.concat(header_row, "")))
  end
  for _, row in pairs(rows) do
    local content_row = {}
    for _, c in pairs(row) do
        table.insert(content_row, ("[cell]%s[/cell]"):format(c))
    end
    add(("[row]%s[/row]"):format(table.concat(content_row, "")))
  end
  add("[/table]\n")
  return table.concat(buffer,'\n')
end

function RawBlock(format, str)
  return format == "bbcode" and str or ""
end

function Div(s, attr)
  return Para(s, attr)
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function() return "" end
  end
setmetatable(_G, meta)

