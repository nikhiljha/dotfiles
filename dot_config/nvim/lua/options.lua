local o = vim.opt

o.termguicolors = false

-- syntax highlighting: tonsky-style minimal palette using terminal colors
-- green(10)=strings, purple(5)=constants, yellow(11)=comments,
-- blue(12)=definitions, gray(8)=punctuation, default fg=everything else
local function set_highlights()
  local hi = vim.api.nvim_set_hl

  -- constants: strings green, numbers/booleans purple
  hi(0, 'String',    { ctermfg = 10 })
  hi(0, 'Number',    { ctermfg = 5 })
  hi(0, 'Float',     { ctermfg = 5 })
  hi(0, 'Boolean',   { ctermfg = 5 })
  hi(0, 'Constant',  { ctermfg = 5 })
  hi(0, 'Character', { ctermfg = 10 })

  -- comments: yellow, bold -- they deserve attention
  hi(0, 'Comment', { ctermfg = 11, bold = true })

  -- definitions: blue (only declarations, not usage)
  hi(0, 'Function', { ctermfg = 12 })

  -- everything else: default fg (no highlight)
  hi(0, 'Statement',   { bold = false })
  hi(0, 'Keyword',     {})
  hi(0, 'Conditional', {})
  hi(0, 'Repeat',      {})
  hi(0, 'Identifier',  {})
  hi(0, 'Type',        {})
  hi(0, 'Special',     {})
  hi(0, 'PreProc',     {})
  hi(0, 'Operator',    { ctermfg = 8 })

  -- punctuation: dimmed gray
  hi(0, 'Delimiter', { ctermfg = 8 })

  -- treesitter overrides
  hi(0, '@string',             { ctermfg = 10 })
  hi(0, '@number',             { ctermfg = 5 })
  hi(0, '@number.float',       { ctermfg = 5 })
  hi(0, '@boolean',            { ctermfg = 5 })
  hi(0, '@constant',           { ctermfg = 5 })
  hi(0, '@constant.builtin',   { ctermfg = 5 })
  hi(0, '@character',          { ctermfg = 10 })
  hi(0, '@comment',            { ctermfg = 11, bold = true })
  hi(0, '@function',           { ctermfg = 12 })
  hi(0, '@function.call',      {})
  hi(0, '@function.method.call', {})
  hi(0, '@variable',           {})
  hi(0, '@variable.parameter', {})
  hi(0, '@variable.member',    {})
  hi(0, '@keyword',            {})
  hi(0, '@keyword.function',   {})
  hi(0, '@keyword.return',     {})
  hi(0, '@keyword.conditional',{})
  hi(0, '@keyword.repeat',     {})
  hi(0, '@keyword.operator',   {})
  hi(0, '@type',               {})
  hi(0, '@type.builtin',       {})
  hi(0, '@constructor',        {})
  hi(0, '@punctuation',            { ctermfg = 8 })
  hi(0, '@punctuation.bracket',    { ctermfg = 8 })
  hi(0, '@punctuation.delimiter',  { ctermfg = 8 })
  hi(0, '@punctuation.special',    { ctermfg = 8 })
  hi(0, '@operator',               { ctermfg = 8 })
  hi(0, '@tag.delimiter',          { ctermfg = 8 })
  hi(0, '@tag.attribute',          {})

  -- LSP semantic tokens: clear so treesitter rules apply
  hi(0, '@lsp.type.variable',  {})
  hi(0, '@lsp.type.parameter', {})
  hi(0, '@lsp.type.property',  {})
  hi(0, '@lsp.type.function',  { ctermfg = 12 })
  hi(0, '@lsp.type.method',    { ctermfg = 12 })
  hi(0, '@lsp.type.keyword',   {})
  hi(0, '@lsp.type.type',      {})
  hi(0, '@lsp.type.namespace', {})
end

set_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_highlights })

o.list = true
o.listchars = {
    tab = '→ ',
    lead = '·',
    trail = '·',
    extends = '›',
    precedes = '‹',
}

-- eol = '¬'
