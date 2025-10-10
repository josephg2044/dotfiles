local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local get_visual = function(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else
		return sn(nil, i(1))
	end
end

local tex = {}
tex.in_math = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
	return not tex.in_math()
end

return {

	-- environments
	s(
		{ trig = "mm", snippetType = "autosnippet", condition = line_begin, dscr = "equation env (star choice)" },
		fmta(
			[[\begin{equation<>}
    <>
\end{equation<>}]],
			{ c(1, { t(""), t("*") }), i(2), rep(1) }
		)
	),

	s(
		{ trig = "aa", snippetType = "autosnippet", condition = line_begin, dscr = "align env (star choice)" },
		fmta(
			[[\begin{align<>}
    <>
\end{align<>}]],
			{ c(1, { t(""), t("*") }), i(2), rep(1) }
		)
	),

	s(
		{ trig = "env", snippetType = "autosnippet", condition = line_begin, dscr = "generic environment" },
		fmta(
			[[\begin{<>}
    <>
\end{<>}]],
			{ i(1, "environment"), i(2), rep(1) }
		)
	),

	s(
		{ trig = "nn", snippetType = "autosnippet", wordTrig = true, condition = tex.in_text, dscr = "inline $...$" },
		fmta("$<>$", { d(1, get_visual) })
	),

	-- sections
	s({ trig = "sn", snippetType = "autosnippet", condition = line_begin }, fmta("\\section{<>}", { i(1) })),
	s({ trig = "ssn", snippetType = "autosnippet", condition = line_begin }, fmta("\\subsection{<>}", { i(1) })),
	s({ trig = "sssn", snippetType = "autosnippet", condition = line_begin }, fmta("\\subsubsection{<>}", { i(1) })),

	-- math
	s(
		{ trig = "ff", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\frac{<>}{<>}", { i(1), i(2) })
	),
	s(
		{ trig = "ss", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("_{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "uu", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("^{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "jk", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("_{<>}^{<>}", { i(1), i(2) })
	),

	s(
		{ trig = "sq", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\sqrt{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "rr", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\sqrt[<>]{<>}", { i(1), d(1, get_visual) })
	),

	s(
		{ trig = "ovl", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\overline{<>}", { d(1, get_visual) })
	),

	s({ trig = "cb", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{3}")),
	s({ trig = "sr", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{2}")),
	s({ trig = "nv", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{-1}")),
	s({ trig = "compl", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\complement}")),
	s({ trig = "dag", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\dag")),
	s({ trig = "hat", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\hat")),
	s({ trig = "tr", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\top")),
	s({ trig = "subs", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\subset}")),
	s({ trig = "subseq", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\subseteq}")),
	s({ trig = "in", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\in")),
	s({ trig = "cap", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\cap}")),
	s({ trig = "bcap", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\bigcap}")),
	s({ trig = "cup", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\cup}")),
	s({ trig = "bcup", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("^{\\bcup}")),

	s({ trig = "**", snippetType = "autosnippet", wordTrig = false, condition = tex.in_math }, t("\\cdot")),
	s({ trig = "EE", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\exists")),
	s({ trig = "nx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\nexists")),
	s({ trig = "AA", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\forall")),
	s({ trig = "nf", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\infty")),

	-- limits
	s(
		{ trig = "lim", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\lim_{<> \\to <>}", { i(1), i(2) })
	),
	s(
		{ trig = "limsup", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\limsup_{<> \\to <>}", { i(1), i(2, "") })
	),

	s(
		{ trig = "binom", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\binom{<>}{<>}", { i(1), i(2) })
	),

	s(
		{ trig = "bm", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\bm{<>}", { d(1, get_visual) })
	),

	s(
		{ trig = "mb", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\mathbb{<>}", { d(1, get_visual) })
	),

	s(
		{ trig = "mc", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\mathcal{<>}", { d(1, get_visual) })
	),

	-- parents
	s(
		{ trig = "ceil", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\left\\lceil<>\\right\\rceil", { d(1, get_visual) })
	),

	s(
		{ trig = "floor", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\left\\lfloor<>\\right\\rfloor", { d(1, get_visual) })
	),

	s(
		{ trig = "angle", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\left\\langle<>\\right\\rangle", { d(1, get_visual) })
	),

	s(
		{ trig = "dp", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\left(<>\\right)", { d(1, get_visual) })
	),

	s(
		{ trig = "dr", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\left[<>\\right]", { d(1, get_visual) })
	),

	s(
		{ trig = "db", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\left\\{<>\\right\\}", { d(1, get_visual) })
	),

	-- greek
	s({ trig = "alpha", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\alpha")),
	s({ trig = "beta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\beta")),
	s({ trig = "gamma", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\gamma")),
	s({ trig = "delta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\delta")),
	s({ trig = "eps", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\epsilon")),
	s({ trig = "veps", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\varepsilon")),
	s({ trig = "zeta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\zeta")),
	s({ trig = "eta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\eta")),
	s({ trig = "theta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\theta")),
	s({ trig = "vtheta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\vartheta")),
	s({ trig = "iota", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\iota")),
	s({ trig = "kappa", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\kappa")),
	s({ trig = "lambda", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\lambda")),
	s({ trig = "mu", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\mu")),
	s({ trig = "nu", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\nu")),
	s({ trig = "xi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\xi")),
	s({ trig = "pi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\pi")),
	s({ trig = "rho", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\rho")),
	s({ trig = "vrho", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\varrho")),
	s({ trig = "sigma", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\sigma")),
	s({ trig = "tau", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\tau")),
	s({ trig = "upsilon", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\upsilon")),
	s({ trig = "phi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\phi")),
	s({ trig = "varphi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\varphi")),
	s({ trig = "chi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\chi")),
	s({ trig = "psi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\psi")),
	s({ trig = "omega", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\omega")),

	s({ trig = "Gamma", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Gamma")),
	s({ trig = "Delta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Delta")),
	s({ trig = "Theta", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Theta")),
	s({ trig = "Lambda", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Lambda")),
	s({ trig = "Xi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Xi")),
	s({ trig = "Pi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Pi")),
	s({ trig = "Sigma", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Sigma")),
	s({ trig = "Upsilon", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Upsilon")),
	s({ trig = "Phi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Phi")),
	s({ trig = "Psi", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Psi")),
	s({ trig = "Omega", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\Omega")),

	-- ===== Operators (math) =====
	s({ trig = "log", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\log")),
	s({ trig = "ln", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\ln")),
	s({ trig = "sin", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\sin")),
	s({ trig = "cos", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\cos")),
	s({ trig = "tan", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\tan")),
	s({ trig = "sec", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\sec")),
	s({ trig = "csc", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\csc")),
	s({ trig = "cot", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\cot")),
	s({ trig = "sinh", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\sinh")),
	s({ trig = "cosh", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\cosh")),
	s({ trig = "tanh", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\tanh")),
	s({ trig = "asin", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\arcsin")),
	s({ trig = "acos", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\arccos")),
	s({ trig = "atan", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\arctan")),
	s({ trig = "sum", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\sum")),
	s({ trig = "prod", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\prod")),
	s({ trig = "int", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\int")),
	s({ trig = "grad", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\grad")),
	s({ trig = "curl", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\curl")),
	s({ trig = "div", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\div")),
	s({ trig = "lapl", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\laplacian")),
	s({ trig = "vb", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\vb")),
	s({ trig = "vu", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\vu")),
	s({ trig = "dot", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\dot")),
	s({ trig = "ddot", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math }, t("\\ddot")),

	-- Physics package
	s(
		{ trig = "norm", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\norm{<>}", { d(1, get_visual) })
	),

	s(
		{ trig = "abs", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\abs{<>}", { d(1, get_visual) })
	),

	s(
		{ trig = "ket", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\ket{<>}", { d(1, get_visual) })
	),

	s(
		{ trig = "bra", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\bra{<>}", { d(1, get_visual) })
	),

	s(
		{ trig = "braket", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		c(1, {
			fmta("\\braket{<>}", { d(1, get_visual) }),
			fmta("\\braket{<>}{<>}", { i(1), i(2) }),
		})
	),

	s(
		{ trig = "ketbra", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		c(1, {
			fmta("\\ketbra{<>}", { d(1, get_visual) }),
			fmta("\\ketbra{<>}{<>}", { i(1), i(2) }),
		})
	),

	s(
		{ trig = "expval", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		c(1, {
			fmta("\\expval{<>}", { d(1, get_visual) }),
			fmta("\\expval{<>}{<>}", { i(1), i(2) }),
		})
	),

	-- deriv
	s(
		{ trig = "dx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\dd{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "ndx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\dd[<>]{<>}", { i(1), d(2, get_visual) })
	),
	s(
		{ trig = "ddx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\dv{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "nddx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\dv[<>]{<>}", { i(1), d(2, get_visual) })
	),
	s(
		{ trig = "dfdx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\dv{<>}{<>}", { d(1, get_visual), i(2) })
	),
	s(
		{ trig = "ndfdx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\dv[<>]{<>}{<>}", { i(1), d(2, get_visual), i(3) })
	),

	-- partials
	s(
		{ trig = "px", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\pp{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "npx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\pp[<>]{<>}", { i(1), d(2, get_visual) })
	),

	s(
		{ trig = "ppx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\pdv{<>}", { d(1, get_visual) })
	),
	s(
		{ trig = "nppx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\pdv[<>]{<>}", { i(1), d(2, get_visual) })
	),
	s(
		{ trig = "pfdx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\pdv{<>}{<>}", { d(1, get_visual), i(2) })
	),
	s(
		{ trig = "npfdx", snippetType = "autosnippet", wordTrig = true, condition = tex.in_math },
		fmta("\\pdv[<>]{<>}{<>}", { i(1), d(2, get_visual), i(3) })
	),
}
