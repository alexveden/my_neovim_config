local ls = require "luasnip"
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require "luasnip.util.types"
local conds = require "luasnip.extras.conditions"
local conds_expand = require "luasnip.extras.conditions.expand"

local snutils = require "snippets.snutils"
local h = snutils.hint

local is_unit_test_buf = function() return snutils.buffnmatch "test_.+%.c$" end

return {
  s(
    "fmt1",
    fmt("To {title} {} {}.", {
      i(2, "Name"),
      i(3, "Surname"),
      title = c(1, { t "Mr.", t "Ms." }),
    })
  ),

  s(
    {trig="as", desc="Inserts assertion (atassert/uassert)"},
    d(1, function()
      if is_unit_test_buf() then
        -- Switch to specific atassert call when in unit test
        return sn(
          nil,
          fmta([[atassert(<expression> <eq> <val> && "<msg>");<fin>]], {
            expression = i(1, "", h "boolean expression"),
            eq = c(2, { t "==", t "!=", t "<", t ">", t ">=", t "<=" }),
            val = i(3, "", h "value to check"),
            msg = i(4, "", h "error message"),
            fin = i(0),
          })
        )
      else
        -- regular code keep using uassert
        return sn(
          nil,
          fmta([[uassert(<expression> <eq> <val> && "<msg>");<fin>]], {
            expression = i(1, "", h "boolean expression"),
            eq = c(2, { t "==", t "!=", t "<", t ">", t ">=", t "<=" }),
            val = i(3, "", h "value to check"),
            msg = i(4, "", h "error message"),
            fin = i(0),
          })
        )
      end
    end)
  ),
  s(
    "pf",
    fmta([[printf("<format>\n"<values>);<fin>]], {
      format = i(1, "", h "printf format"),
      values = i(2, "", h "values to print"),
      fin = i(0),
    })
  ),
}
