local ls = require("luasnip")
local f = ls.function_node
local d = ls.dynamic_node
local r = ls.restore_node

-- Auxiliary functions

-- Math zone context
-- taken from https://ejmastnak.com/

local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

-- Visual placeholder
-- taken from https://ejmastnak.com/

local get_visual = function(args, parent, default_text)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1,parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1,default_text))
  end
end

local function v(pos, default_text)
  return d(pos, function(args, parent) return get_visual(args, parent, default_text) end)
end

-- Matrices and cases
-- taken from github.com/evesdropper

local generate_matrix = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ " \\\\", "" }))
	end
	nodes[#nodes] = t(" \\\\")
	return sn(nil, nodes)
end

local generate_hom_matrix = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		if j == 1 then
			table.insert(nodes, r(ins_indx,i(1)))
			table.insert(nodes, t("_{11}"))
		else
			table.insert(nodes, rep(1))
			table.insert(nodes, t("_{" .. tostring(j) .. "1}"))
		end
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, rep(1))
			table.insert(nodes, t("_{" .. tostring(j) .. tostring(k) .. "}"))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ " \\\\", "" }))
	end
	nodes[#nodes] = t(" \\\\")
	return sn(nil, nodes)
end

local generate_cases = function(args, snip)
	local rows = tonumber(snip.captures[1]) or 2 
	local cols = 2
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", sn(1,{t("    \\hfil "),i(1)})))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ " \\\\", "" }))
	end
    table.remove(nodes, #nodes)
	return sn(nil, nodes)
end

-- Snippets

return {

-- Math

-- Math alphabet identifiers

s({trig = "mc", name = "Calligraphic math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathcal{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mr", name = "Roman math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathrm{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mb", name = "Bold math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathbf{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ms", name = "Sans serif math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathsf{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mt", name = "Typewriter math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathtt{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mn", name = "Normal math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathnormal{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mi", name = "Italic math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathit{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mf", name = "Euler Fraktur math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathfrak{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "mk", name = "Blackboard bold math font"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathbb{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

-- Display environments and alignment structures

s({trig = "mm", name = "Inline display"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("$"), d(1,get_visual), t("$")
    }
),

s({trig = "en", name = "Generic environment"},
    {
		t("\\begin{"), i(1,"env"), t("}"),
		t({"",""}), t("    "), d(2,get_visual),
		t({"",""}), t("\\end{"), rep(1), t("}")
    }
),

s({trig = "nn", name = "New equation"},
    {
        c(1,
            {
                {
                    t("\\begin{equation*}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{equation*}")
                },
                {
                    t("\\begin{equation}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{equation}")
                }
            }
        )
    }
),

s({trig = "ml", name = "New multline"},
    {
        c(1,
            {
                {
                    t("\\begin{multline}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{multline}")
                },
                {
                    t("\\begin{multline*}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{multline*}")
                }
            }
        )
    }
),

s({trig = "gap", name = "Multline gap"},
    {
        t("\\setlenght\\multlinegap{0pt}")
    }
),

s({trig = "sp", name = "New split"},
    {
		t("\\begin{split}"),
		t({"",""}), t("    "), d(1,get_visual),
		t({"",""}), t("\\end{split}")
    }
),

s({trig = "gg", name = "New gather"},
    {
        c(1,
            {
                {
                    t("\\begin{gather}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{gather}")
                },
                {
                    t("\\begin{gather*}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{gather*}")
                }
            }
        )
    }
),

s({trig = "aa", name = "New align"},
    {
        c(1,
            {
                {
                    t("\\begin{align*}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{align*}")
                },
                {
                    t("\\begin{align}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{align}")
                }
            }
        )
    }
),

s({trig = "fal", name = "New falign"},
    {
        c(1,
            {
                {
                    t("\\begin{falign}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{falign}")
                },
                {
                    t("\\begin{falign*}"),
					t({"",""}), t("    "), d(1,get_visual),
					t({"",""}), t("\\end{falign*}")
                }
            }
        )
    }
),

s({trig = "(%d?)cs", name = "New cases environment", regTrig = true},
	{
        t("\\begin{cases}"),
		t({"",""}), d(1,generate_cases),
		t({"",""}), t("\\end{cases}")
	},
    {condition = in_mathzone}
),

s({trig = "br", name = "Display line break"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\\\"),
		t({"",""}), i(1)
    },
    {condition = in_mathzone}
),

s({trig = "itr", name = "Short text between lines"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\intertext{"), v(1,"text"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "tx", name = "Text inside display"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\text{"), v(1,"text"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "dib", name = "Display page break"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\displaybreak")
    },
    {condition = in_mathzone}
),

s({trig = "dis", name = "Displaystyle"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\displaystyle")
    },
    {condition = in_mathzone}
),

s({trig = "ty", name = "Textstyle"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\textstyle")
    },
    {condition = in_mathzone}
),

-- Equation numbering and tags

s({trig = "ntg", name = "Suppress equation tag"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\notag")
    },
    {condition = in_mathzone}
),

s({trig = "tag", name = "Equation tag"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\tag{"), v(1,"tag"), t("}")
                },
                {
                    t("\\tag*{"), v(1,"tag"), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "teq", name = "Last number equation"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\theequation")
    }
),

-- Matrix-like environments

s({trig = "([bBpvV])(%d+)x(%d+)", name = "New matrix", regTrig = true},
    {
		t("\\begin{"), f(function(_, snip) return snip.captures[1] .. "matrix" end), t("}"),
		t({"",""}), d(1,generate_matrix),
		t({"",""}), t("\\end{"), f(function(_, snip) return snip.captures[1] .. "matrix" end), t("}")
    },
    {condition = in_mathzone}
),


s({trig = "([bBpvV])(%d+)h(%d+)", name = "New homogeneous matrix", regTrig = true},
    {
		t("\\begin{"), f(function(_, snip) return snip.captures[1] .. "matrix" end), t("}"),
		t({"",""}), d(1,generate_hom_matrix),
		t({"",""}), t("\\end{"), f(function(_, snip) return snip.captures[1] .. "matrix" end), t("}")
    },
    {condition = in_mathzone}
),


s({trig = "([bBpvV])gn", name = "New generic matrix", regTrig = true},
    {
        t("\\begin{"), f(function(_, snip) return snip.captures[1] .. "matrix" end), t("}"),
		t({"",""}), t("    "), i(1), t("_{11} & "), rep(1), t("_{12} & \\cdots & "), rep(1), t("_{1"), i(2), t("}"), t(" \\\\"),
		t({"",""}), t("    "), rep(1), t("_{21} & "), rep(1), t("_{22} & \\cdots & "), rep(1), t("_{2"), rep(2), t("}"), t(" \\\\"),
		t({"",""}), t("    "), t("\\vdots & \\vdots & \\ddots & \\vdots \\\\"),
		t({"",""}), t("    "), rep(1), t("_{"), i(3), t("1} & "), rep(1), t("_{"), rep(3), t("2} & \\cdots & "), rep(1), t("_{"), rep(3), rep(2), t("} \\\\"),
		t({"",""}), t("\\end{"), f(function(_, snip) return snip.captures[1] .. "matrix" end), t("}")
    },
    {condition = in_mathzone}
),

-- Subscripts and superscripts

s({trig = ";", name = "Short subscript", wordTrig = false},
    {
        t("_")
    },
    {condition = in_mathzone}
),

s({trig = ":", name = "Subscript", wordTrig = false},
    {
        t("_{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "´", name = "Short superscript", wordTrig = false},
    {
        t("^")
    },
    {condition = in_mathzone}
),

s({trig = "¨", name = "Superscript", wordTrig = false},
    {
        t("^{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "¨", name = "Superscript", wordTrig = false},
    {
        t("^{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "\'", name = "Subscript and superscript", wordTrig = false},
    {
		t("_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "st", name = "Stacking"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\substack{"), i(1), t(" \\\\ "), i(2), t("}")
    },
    {condition = in_mathzone}
),

-- Compound structures

s({trig = "lxl", name = "Left relation arrow"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
        			t("\\xleftarrow{"), i(1,"top"), t("}")
		        },
		        {
        			t("\\xleftarrow["), i(1,"bottom"), t("]{"), i(2,"top"), t("}")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "lxr", name = "Left relation arrow"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
        			t("\\xrightarrow{"), i(1,"top"), t("}")
		        },
		        {
        			t("\\xrightarrow["), i(1,"bottom"), t("]{"), i(2,"top"), t("}")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "cf", name = "Continued fraction"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\cfrac{"), i(1,"num"), t("}{"),
					t({"",""}), t("    "), i(2,"den"),
					t({"",""}), t("}")
                },
                {
                    t("\\cfrac["), i(1,"num-alignment"), t("]{"), i(2,"num"), t("}{"),
					t({"",""}), t("    "), i(3,"den"),
					t({"",""}), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "bx", name = "Boxed formula"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\boxed{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ff", name = "Fraction"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\frac{"), i(1), t("}{"), i(2), t("}")
                },
                {
                    t("\\dfrac{"), i(1), t("}{"), i(2), t("}")
                },
                {
                    t("\\tfrac{"), i(1), t("}{"), i(2), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "bm", name = "Binomial coefficient"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\binom{"), i(1), t("}{"), i(2), t("}")
                },
                {
                    t("\\dbinom{"), i(1), t("}{"), i(2), t("}")
                },
                {
                    t("\\tbinom{"), i(1), t("}{"), i(2), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

-- Decorations

s({trig = "abv", name = "Place material above"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\overset{"), i(1,"above"), t("}{"), v(2,"material"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "bel", name = "Place material below"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\underset{"), i(1,"below"), t("}{"), v(2,"material"), t("}")
    },
    {condition = in_mathzone}
),

-- Limiting positions

s({trig = "lim", name = "Above/below operator"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\limits")
    },
    {condition = in_mathzone}
),

s({trig = "nli", name = "Right of the operator"},
    {
        t("\\nolimits")
    },
    {condition = in_mathzone}
),

-- Relations

s({trig = "eq", name = "Congruence relation"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\equiv")
    },
    {condition = in_mathzone}
),

s({trig = "mod", name = "Modular relation"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
		            i(1,"..."), t(" \\equiv "), i(2,"..."), t(" \\pmod{"), i(3,"..."), t("}")
		        },
		        {
		            i(1,"..."), t(" \\not\\equiv "), i(2,"..."), t(" \\pmod{"), i(3,"..."), t("}")
		        },
		        {
		            i(1,"..."), t(" \\equiv "), i(2,"..."), t(" \\mod{"), i(3,"..."), t("}")
		        },
		        {
		            i(1,"..."), t(" \\not\\equiv "), i(2,"..."), t(" \\mod{"), i(3,"..."), t("}")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "sbg", name = "Left triangle"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\vartriangleleft")
                },
                {
                    i(1,"\\ntriangleleft")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "sgc", name = "Right triangle"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\vartriangleright")
                },
                {
                    i(1,"\\ntriangleright")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "ne", name = "Not equal"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ne")
    },
    {condition = in_mathzone}
),

s({trig = "nr", name = "Relation negation"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\not")
    },
    {condition = in_mathzone}
),

s({trig = "app", name = "Approx"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\approx")
    },
    {condition = in_mathzone}
),

s({trig = "cn", name = "Congruent"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\cong")
                },
                {
                    i(1,"\\ncong")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "le", name = "Less or equal"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\le")
    },
    {condition = in_mathzone}
),

s({trig = "ge", name = "Greater or equal"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ge")
    },
    {condition = in_mathzone}
),

s({trig = "pc", name = "Precedes"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\prec")
                },
                {
                    i(1,"\\nprec")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "sx", name = "Succedes"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\succ")
                },
                {
                    i(1,"\\nsucc")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "re", name = "Relation"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\sim")
                },
                {
                    i(1,"\\nsim")
                }
            }
        )
    },
    {condition = in_mathzone}
),

-- Operators

s({trig = "opr", name = "Define new operator"},
    {
        c(1,
            {
                {
                    t("\\DeclareMathOperator{"), i(1,"cmd"), t("}{"), i(2,"text"), t("}")
                },
                {
                    t("\\DeclareMathOperator*{"), i(1,"cmd"), t("}{"), i(2,"text"), t("}")
                }
            }
        )
    }
),

s({trig = "ce", name = "Ceiling"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\lceil "), d(1,get_visual), t(" \\rceil")
                },
                {
                    t("\\left\\lceil "), d(1,get_visual), t(" \\right\\rceil")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "fl", name = "Floor"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\lfloor "), d(1,get_visual), t(" \\rfloor")
                },
                {
                    t("\\left\\lfloor "), d(1,get_visual), t(" \\right\\rfloor")
                }
            }
        )
        
    },
    {condition = in_mathzone}
),

s({trig = "sq", name = "Square root"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\sqrt{"), d(1,get_visual), t("}")
                },
                {
                    t("\\sqrt["), i(1,"n-th"), t("]{"), d(2,get_visual), t("}")
                },
                {
                    t("\\sqrt[\\leftroot{"), i(1,"x"), t("}\\uproot{"), i(2,"y"), t("} "), i(3,"n-th"), t("]{"), d(4,get_visual), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "imp", name = "Imaginary part"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Im")
    },
    {condition = in_mathzone}
),

s({trig = "rpa", name = "Real part"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Re")
    },
    {condition = in_mathzone}
),

s({trig = "opm", name = "Mod operator"},
    {
		f(function(_,snip) return snip.captures[1] end),
        i(1,"..."), t(" \\bmod "), i(2,"...")
    },
    {condition = in_mathzone}
),

s({trig = "mp", name = "Minus plus"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mp")
    },
    {condition = in_mathzone}
),

s({trig = "pm", name = "Plus minus"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\pm")
    },
    {condition = in_mathzone}
),

s({trig = "tm", name = "Times"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\times")
    },
    {condition = in_mathzone}
),

s({trig = "cd", name = "Centered dot"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cdot")
    },
    {condition = in_mathzone}
),

s({trig = "cir", name = "Circle"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\circ")
    },
    {condition = in_mathzone}
),

s({trig = "opl", name = "Oplus"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\oplus")
    },
    {condition = in_mathzone}
),

s({trig = "omt", name = "Otimes"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\otimes")
    },
    {condition = in_mathzone}
),

s({trig = "dv", name = "Middle bar"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mid")
    },
    {condition = in_mathzone}
),

s({trig = "ndv", name = "Middle bar"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\centernot\\mid")
    },
    {condition = in_mathzone}
),

s({trig = "xm", name = "Maximum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\max")
                },
                {
                    t("\\max_{"), i(1,"..."), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "mu", name = "Minimum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\min")
                },
                {
                    t("\\min_{"), i(1,"..."), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "nf", name = "Infimum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\inf")
                },
                {
                    t("\\inf_{"), i(1,"..."), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "sr", name = "Supremum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\sup")
                },
                {
                    t("\\sup_{"), i(1,"..."), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "arg", name = "Argument"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arg")
    },
    {condition = in_mathzone}
),

s({trig = "deg", name = "Degree"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\deg")
    },
    {condition = in_mathzone}
),

s({trig = "det", name = "Determinant"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\det")
    },
    {condition = in_mathzone}
),

s({trig = "dim", name = "Dimension"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dim")
    },
    {condition = in_mathzone}
),

s({trig = "gc", name = "Greatest common divisor"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\gcd")
    },
    {condition = in_mathzone}
),

s({trig = "hm", name = "Hom"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\hom")
    },
    {condition = in_mathzone}
),

s({trig = "kr", name = "Kernel"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ker")
    },
    {condition = in_mathzone}
),

s({trig = "lap", name = "Laplacian"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\nabla^2 ")
    },
    {condition = in_mathzone}
),

s({trig = "div", name = "Divergence"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
        			t("\\nabla\\cdot\\vv{"), i(1), t("}")
		        },
		        {
        			t("\\nabla\\cdot\\vec{"), i(1), t("}")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "cur", name = "Curl"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
        			t("\\nabla\\times\\vv{"), i(1), t("}")
		        },
		        {
        			t("\\nabla\\times\\vec{"), i(1), t("}")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "ba", name = "Bra"},
    {
        c(1,
            {
                {
                    t("\\bra{"), i(1), t("}")
                },
                {
                    t("\\bra*{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "kt", name = "Ket"},
    {
        c(1,
            {
                {
                    t("\\ket{"), i(1), t("}")
                },
                {
                    t("\\ket*{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "bk", name = "Braket"},
    {
        c(1,
            {
                {
                    t("\\braket{"), i(1), t("}{"), i(2), t("}")
                },
                {
                    t("\\braket*{"), i(1), t("}{"), i(2), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

-- Operators with limits

s({trig = "lm", name = "Limit"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\lim_{"), i(1), t(" \\to "), i(2), t("}")
                },
                {
					i(1,"\\lim")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "lif", name = "liminf"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\liminf_{"), i(1), t(" \\to "), i(2), t("}")
                },
                {
					i(1,"\\liminf")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "lsu", name = "limsup"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\limsup_{"), i(1), t(" \\to "), i(2), t("}")
                },
                {
					i(1,"\\limsup")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "lvf", name = "varliminf"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\varliminf_{"), i(1), t(" \\to "), i(2), t("}")
                },
                {
					i(1,"\\varliminf")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "lvu", name = "varlimsup"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\varlimsup_{"), i(1), t(" \\to "), i(2), t("}")
                },
                {
					i(1,"\\varlimsup")
                }
            }
        )
    },
    {condition = in_mathzone}
),

-- Functions

s({trig = "fn", name = "Function domain and codomain"},
    {
		f(function(_,snip) return snip.captures[1] end),
        i(1,"fun"), t(" : "), i(2,"dom"), t(" \\longrightarrow "), i(3,"cod")
    },
    {condition = in_mathzone}
),

s({trig = "fd", name = "Function definition"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\begin{align*}"),
		t({"",""}), t("    "), i(1,"fun"), t(" : "), i(2,"dom"), t(" & \\longrightarrow "), i(3,"cod"), t(" \\\\"),
		t({"",""}), t("    "), i(4,"point"), t(" & \\longmapsto "), i(5,"img"),
		t({"",""}), t("\\end{align*}")
    }
),

s({trig = "sni", name = "sin"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\sin")
    },
    {condition = in_mathzone}
),

s({trig = "co", name = "cos"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cos")
    },
    {condition = in_mathzone}
),

s({trig = "tan", name = "tan"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\tan")
    },
    {condition = in_mathzone}
),

s({trig = "ot", name = "cot"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cot")
    },
    {condition = in_mathzone}
),

s({trig = "sc", name = "sec"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\sec")
    },
    {condition = in_mathzone}
),

s({trig = "cc", name = "csc"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\csc")
    },
    {condition = in_mathzone}
),

s({trig = "asin", name = "arcsin"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arcsin")
    },
    {condition = in_mathzone}
),

s({trig = "acos", name = "arccos"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arccos")
    },
    {condition = in_mathzone}
),

s({trig = "atan", name = "arctan"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arctan")
    },
    {condition = in_mathzone}
),

s({trig = "acot", name = "arccot"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arccot")
    },
    {condition = in_mathzone}
),

s({trig = "asec", name = "arcsec"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arcsec")
    },
    {condition = in_mathzone}
),

s({trig = "acc", name = "arccsc"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arccsc")
    },
    {condition = in_mathzone}
),

s({trig = "sinh", name = "sinh"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\sinh")
    },
    {condition = in_mathzone}
),

s({trig = "cosh", name = "cosh"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cosh")
    },
    {condition = in_mathzone}
),

s({trig = "tanh", name = "tanh"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\tanh")
    },
    {condition = in_mathzone}
),

s({trig = "coth", name = "coth"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\coth")
    },
    {condition = in_mathzone}
),

s({trig = "sh", name = "sech"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\sech")
    },
    {condition = in_mathzone}
),

s({trig = "hcc", name = "csch"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\csch")
    },
    {condition = in_mathzone}
),

s({trig = "ahsin", name = "arcsinh"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arcsinh")
    },
    {condition = in_mathzone}
),

s({trig = "ahcos", name = "arccosh"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arccosh")
    },
    {condition = in_mathzone}
),

s({trig = "ahtan", name = "arctanh"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arctanh")
    },
    {condition = in_mathzone}
),

s({trig = "ahcot", name = "arccoth"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arccoth")
    },
    {condition = in_mathzone}
),

s({trig = "ahsec", name = "arcsech"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arcsech")
    },
    {condition = in_mathzone}
),

s({trig = "ahcc", name = "arccsch"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\arccsch")
    },
    {condition = in_mathzone}
),

s({trig = "xp", name = "exp"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\exp")
    },
    {condition = in_mathzone}
),

s({trig = "ln", name = "ln"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ln")
    },
    {condition = in_mathzone}
),

s({trig = "lg", name = "log"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\log")
    },
    {condition = in_mathzone}
),

-- Ellipsis

s({trig = "dd", name = "Lower dots"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ldots")
    },
    {condition = in_mathzone}
),

s({trig = "cr", name = "Centered dots"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cdots")
    },
    {condition = in_mathzone}
),

s({trig = "vd", name = "Vertical dots"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\vdots")
    },
    {condition = in_mathzone}
),

s({trig = "gd", name = "Diagonal dots"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ddots")
    },
    {condition = in_mathzone}
),

s({trig = "cln", name = "Colon"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t(":")
    },
    {condition = in_mathzone}
),

s({trig = "sln", name = "Semicolon"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t(";")
    },
    {condition = in_mathzone}
),

-- Horizontal extensions

s({trig = "ovr", name = "Overline"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\overline{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "und", name = "Underline"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\underline{"), d(1,get_visual), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ovb", name = "Overbrace"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\overbrace{"), d(1,get_visual), t("}^{"), i(2,"top"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "unb", name = "Underbrace"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\underbrace{"), d(1,get_visual), t("}_{"), i(2,"bottom"), t("}")
    },
    {condition = in_mathzone}
),

-- Delimiters

s({trig = "dp", name = "Parenthesis"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\left( "), d(1,get_visual), t(" \\right)")
    },
    {condition = in_mathzone}
),

s({trig = "ds", name = "Brackets"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\left[ "), d(1,get_visual), t(" \\right]")
    },
    {condition = in_mathzone}
),

s({trig = "bb", name = "Braces"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\{ "), d(1,get_visual), t(" \\}")
    },
    {condition = in_mathzone}
),

s({trig = "db", name = "Extensible braces"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\left\\{ "), d(1,get_visual), t(" \\right\\}")
    },
    {condition = in_mathzone}
),

s({trig = "dk", name = "Angle brackets"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\left\\langle "), d(1,get_visual), t(" \\right\\rangle")
                },
                {
                    t("\\langle "), d(1,get_visual), t(" \\rangle")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "da", name = "Pipes"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\left\\lvert "), d(1,get_visual), t(" \\right\\rvert")
                },
                {
                    t("\\lvert "), d(1,get_visual), t(" \\rvert")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "dn", name = "Double pipes"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\left\\lVert "), d(1,get_visual), t(" \\right\\rVert")
                },
                {
                    t("\\lVert "), d(1,get_visual), t(" \\rVert")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "big", name = "Big-d delimiters"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\big")
                },
                {
                    i(1,"\\Big")
                },
                {
                    i(1,"\\bigg")
                },
                {
                    i(1,"\\Bigg")
                }
            }
        )
    },
    {condition = in_mathzone}
),

-- Spacing commands

s({trig = "thp", name = "Thin space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\,")
    },
    {condition = in_mathzone}
),

s({trig = "mdn", name = "Medium space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\:")
    },
    {condition = in_mathzone}
),

s({trig = "tkp", name = "Thick space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\;")
    },
    {condition = in_mathzone}
),

s({trig = "enp", name = "Enskip"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\enskip")
    },
    {condition = in_mathzone}
),

s({trig = "qu", name = "Quad"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\quad")
    },
    {condition = in_mathzone}
),

s({trig = "qq", name = "Double quad"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\qquad")
    },
    {condition = in_mathzone}
),

s({trig = "thn", name = "Negative thin space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\!")
    },
    {condition = in_mathzone}
),

s({trig = "men", name = "Negative medium space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\negmedspace")
    },
    {condition = in_mathzone}
),

s({trig = "tkn", name = "Negative thick space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\negthickspace")
    },
    {condition = in_mathzone}
),

s({trig = "hs", name = "Horizontal space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\hspace{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "vs", name = "Vertical space"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\vspace{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

-- Greek alphabet

s({trig = "[.]a", name = "Alpha", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\alpha")
    },
    {condition = in_mathzone}
),

s({trig = "[.]b", name = "Beta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\beta")
    },
    {condition = in_mathzone}
),

s({trig = "[.]c", name = "Chi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\chi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]D", name = "Uppercase delta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Delta")
    },
    {condition = in_mathzone}
),

s({trig = "[.]d", name = "Lowercase delta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\delta")
    },
    {condition = in_mathzone}
),

s({trig = "[.]e", name = "Epsilon", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
		t("\\varepsilon")
    },
    {condition = in_mathzone}
),

s({trig = "[.]G", name = "Uppercase gamma", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Gamma")
    },
    {condition = in_mathzone}
),

s({trig = "[.]g", name = "Lowercase gamma", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\gamma")
    },
    {condition = in_mathzone}
),

s({trig = "[.]h", name = "Eta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\eta")
    },
    {condition = in_mathzone}
),

s({trig = "[.]i", name = "Iota", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\iota")
    },
    {condition = in_mathzone}
),

s({trig = "[.]k", name = "Kappa", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\kappa")
    },
    {condition = in_mathzone}
),

s({trig = "[.]L", name = "Uppercase lambda", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Lambda")
    },
    {condition = in_mathzone}
),

s({trig = "[.]l", name = "Lowercase lambda", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\lambda")
    },
    {condition = in_mathzone}
),

s({trig = "[.]m", name = "Mu", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mu")
    },
    {condition = in_mathzone}
),

s({trig = "[.]n", name = "Nu", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\nu")
    },
    {condition = in_mathzone}
),

s({trig = "[.]O", name = "Uppercase omega", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Omega")
    },
    {condition = in_mathzone}
),

s({trig = "[.]o", name = "Lowercase omega", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\omega")
    },
    {condition = in_mathzone}
),

s({trig = "[.]Ph", name = "Uppercase phi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Phi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]ph", name = "Lowecase phi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
		t("\\phi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]Pi", name = "Uppercase pi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Pi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]pi", name = "Lowercase pi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\pi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]Ps", name = "Uppercase psi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Psi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]ps", name = "Lowercase psi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\psi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]r", name = "Rho", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\rho")
    },
    {condition = in_mathzone}
),

s({trig = "[.]S", name = "Uppercase sigma", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Sigma")
    },
    {condition = in_mathzone}
),

s({trig = "[.]s", name = "Lowercase sigma", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\sigma")
    },
    {condition = in_mathzone}
),

s({trig = "[.]ta", name = "Tau", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\tau")
    },
    {condition = in_mathzone}
),

s({trig = "[.]Th", name = "Uppercase theta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Theta")
    },
    {condition = in_mathzone}
),

s({trig = "[.]th", name = "Lowercase theta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\theta")
    },
    {condition = in_mathzone}
),

s({trig = "[.]U", name = "Uppercase upsilon", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Upsilon")
    },
    {condition = in_mathzone}
),

s({trig = "[.]u", name = "Lowecase upsilon", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\upsilon")
    },
    {condition = in_mathzone}
),

s({trig = "[.]X", name = "Uppercase xi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\Xi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]x", name = "Lowercase xi", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\xi")
    },
    {condition = in_mathzone}
),

s({trig = "[.]z", name = "Zeta", regTrig = true},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\zeta")
    },
    {condition = in_mathzone}
),

-- Letter-shaped symbols

s({trig = "ha", name = "Aleph"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\aleph")
    },
    {condition = in_mathzone}
),

s({trig = "hb", name = "Beth"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\beth")
    },
    {condition = in_mathzone}
),

s({trig = "hd", name = "Daleth"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\daleth")
    },
    {condition = in_mathzone}
),

s({trig = "hg", name = "Gimel"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\gimel")
    },
    {condition = in_mathzone}
),

s({trig = "ll", name = "ell"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ell")
    },
    {condition = in_mathzone}
),

s({trig = "cm", name = "Set complement"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\complement")
    },
    {condition = in_mathzone}
),

s({trig = "hr", name = "hbar"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\hbar")
    },
    {condition = in_mathzone}
),

s({trig = "hl", name = "hslash"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\hslash")
    },
    {condition = in_mathzone}
),

s({trig = "pt", name = "Partial"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\partial")
    },
    {condition = in_mathzone}
),

-- Miscellaneous symbols

s({trig = "dl", name = "Dollar sign"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\$")
    },
    {condition = in_mathzone}
),

s({trig = "hh", name = "Numeral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\#")
    },
    {condition = in_mathzone}
),

s({trig = "fy", name = "Infinity"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\infty")
    },
    {condition = in_mathzone}
),

s({trig = "pr", name = "Prime"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\prime")
    },
    {condition = in_mathzone}
),

s({trig = "per", name = "Percentaje"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\%")
    },
    {condition = in_mathzone}
),

s({trig = "amp", name = "Ampersand"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\&")
    },
    {condition = in_mathzone}
),

s({trig = "ang", name = "Angle"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\angle")
    },
    {condition = in_mathzone}
),

s({trig = "nb", name = "Nabla"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\nabla")
    },
    {condition = in_mathzone}
),

s({trig = "ch", name = "Section symbol"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\S")
    }
),

-- Accents

s({trig = "dr", name = "Dot accent"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
					t("\\dot{"), v(1,"..."), t("}")
		        },
		        {
					t("\\ddot{"), v(1,"..."), t("}")
		        },
		        {
					t("\\dddot{"), v(1,"..."), t("}")
		        },
		        {
					t("\\ddddot{"), v(1,"..."), t("}")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "ht", name = "Hat"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\hat{"), v(1,"..."), t("}")
                },
                {
                    t("\\widehat{"), v(1,"..."), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "rng", name = "Math ring"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\mathring{"), v(1,"..."), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "til", name = "Tilde"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\tilde{"), i(1), t("}")
                },
                {
                    t("\\widetilde{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "vv", name = "Vector"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\vv{"), v(1,"..."), t("}")
                },
                {
                    t("\\vec{"), v(1,"..."), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

-- Logic

s({trig = "fa", name = "For all"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\forall")
    },
    {condition = in_mathzone}
),

s({trig = "ex", name = "Exists"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\exists")
    },
    {condition = in_mathzone}
),

s({trig = "nx", name = "Not exist"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\nexists")
    },
    {condition = in_mathzone}
),

s({trig = "lt", name = "Logic negation"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\lnot")
    },
    {condition = in_mathzone}
),

s({trig = "lan", name = "Logic and"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\land")
    },
    {condition = in_mathzone}
),

s({trig = "lor", name = "Logic or"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\lor")
    },
    {condition = in_mathzone}
),

s({trig = "ip", name = "Implies"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\implies")
    },
    {condition = in_mathzone}
),

s({trig = "ib", name = "Implied by"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\impliedby")
    },
    {condition = in_mathzone}
),

s({trig = "iff", name = "If and only if"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\iff")
    },
    {condition = in_mathzone}
),

-- Sets and inclusion

s({trig = "in", name = "Belongs to"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\in")
    },
    {condition = in_mathzone}
),

s({trig = "ntn", name = "Not in"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\notin")
    },
    {condition = in_mathzone}
),

s({trig = "na", name = "Owns"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\ni")
    },
    {condition = in_mathzone}
),

s({trig = "vc", name = "Empty set"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\emptyset")
                },
                {
                    i(1,"\\varnothing")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "nun", name = "Union"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cup")
    },
    {condition = in_mathzone}
),

s({trig = "bun", name = "Big union"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigcup")
    },
    {condition = in_mathzone}
),

s({trig = "sun", name = "Big subscript union"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigcup_{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "dun", name = "Big definite union"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigcup_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "nit", name = "Intersection"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\cap")
    },
    {condition = in_mathzone}
),

s({trig = "bit", name = "Big intersection"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigcap")
    },
    {condition = in_mathzone}
),

s({trig = "sit", name = "Big subscript intersection"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigcap_{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "dit", name = "Big definite intersection"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigcap_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "sf", name = "Set difference"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\setminus")
    },
    {condition = in_mathzone}
),

s({trig = "sbs", name = "Subset"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\subset")
    },
    {condition = in_mathzone}
),

s({trig = "sbq", name = "Subset or equals"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\subseteq")
                },
                {
                    i(1,"\\nsubseteq")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "sus", name = "Contains"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\supset")
    },
    {condition = in_mathzone}
),

s({trig = "suq", name = "Contains or equals"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\supseteq")
                },
                {
                    i(1,"\\nsupseteq")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "setd", name = "Dots set"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\{ "), i(1), t(" \\std "), i(2), t(" \\}")
    },
    {condition = in_mathzone}
),

s({trig = "setb", name = "Bar set"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\{ "), i(1), t(" \\mid "), i(2), t(" \\}")
    },
    {condition = in_mathzone}
),

-- Arrows

s({trig = "rar", name = "Long right arrow"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\longrightarrow")
    },
    {condition = in_mathzone}
),

s({trig = "lar", name = "Long left arrow"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\longleftarrow")
    },
    {condition = in_mathzone}
),

s({trig = "to", name = "Long maps to"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\longmapsto")
    },
    {condition = in_mathzone}
),

-- Sums

s({trig = "sm", name = "Subscript sum"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
        			t("\\sum_{"), i(1), t("}")
		        },
		        {
        			i(1,"\\sum")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "ss", name = "Definite sum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\sum_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "sos", name = "Subscript o-sum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigoplus_{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "nos", name = "Definite o-sum"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigoplus_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

-- Products

s({trig = "sp", name = "Subscript product"},
    {
		f(function(_,snip) return snip.captures[1] end),
		c(1,
		    {
		        {
        			t("\\prod_{"), i(1), t("}")
		        },
		        {
        			i(1,"\\prod")
		        }
		    }
		)
    },
    {condition = in_mathzone}
),

s({trig = "pp", name = "Definite product"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\prod_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "sop", name = "Subscript o-product"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigotimes_{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "nop", name = "Definite o-product"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\bigotimes_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

-- Derivatives

s({trig = "dx", name = "Differential"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dd{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ndx", name = "n-th Differential"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dd["), i(1, "n"), t("]{"), i(2, "x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ddx", name = "Derivative operator"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dv{"), i(1,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "nddx", name = "n-th Derivative operator"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dv["), i(1, "n"), t("]{"), i(2,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "dfdx", name = "Derivative"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dv{"), i(1,"f"), t("}{"), i(2,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ndfdx", name = "n-th Derivative"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\dv["), i(1, "n"), t("]{"), i(2,"f"), t("}{"), i(3,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "px", name = "Partial differential"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\partial{"), i(1, "x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "ppx", name = "Partial derivative operator"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\pdv{"), i(1,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "nppx", name = "n-th Partial derivative operator"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\pdv["), i(1, "n"), t("]{"), i(2,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "pfpx", name = "Partial derivative"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\pdv{"), i(1,"f"), t("}{"), i(2,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "npfpx", name = "n-th Partial derivative"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\pdv["), i(1, "n"), t("]{"), i(2,"f"), t("}{"), i(3,"x"), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "evl", name = "Derivative evaluation"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\evl{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

-- Integrals

s({trig = "itn", name = "Integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\int")
                },
                {
                    i(1,"\\oint")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "its", name = "Subscript integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\int_{"), i(1), t("}")
                },
                {
                    t("\\oint_{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "itd", name = "Definite integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        t("\\int_{"), i(1), t("}^{"), i(2), t("}")
    },
    {condition = in_mathzone}
),

s({trig = "itbn", name = "Double integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\iint")
                },
                {
                    i(1,"\\oiint")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "itbs", name = "Double integral subscript"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\iint_{"), i(1), t("}")
                },
                {
                    t("\\oiint_{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "ittn", name = "Triple integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\iiint")
                },
                {
                    i(1,"\\oiiint")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "itts", name = "Triple integral subscript"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\iiint_{"), i(1), t("}")
                },
                {
                    t("\\oiiint_{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "itqn", name = "Quadruple integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    i(1,"\\iiiint")
                },
                {
                    i(1,"\\oiiint")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "itqs", name = "Quadruple integral subscript"},
    {
		f(function(_,snip) return snip.captures[1] end),
        c(1,
            {
                {
                    t("\\iiint_{"), i(1), t("}")
                },
                {
                    t("\\oiiint_{"), i(1), t("}")
                }
            }
        )
    },
    {condition = in_mathzone}
),

s({trig = "itmn", name = "Multiple integral"},
    {
		f(function(_,snip) return snip.captures[1] end),
		t("\\idotsint")
    },
    {condition = in_mathzone}
),

s({trig = "itms", name = "Multiple integral subscript"},
    {
		f(function(_,snip) return snip.captures[1] end),
		t("\\idotsint_{"), i(1), t("}")
    },
    {condition = in_mathzone}
),

}
