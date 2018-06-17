{
    function create_user_defined_box(blocktype, name, body) {
	    if (blocktype === "definition") {
		    var header  =  "<span class='definition_box_title'><span class='definition_box_flag'>def.</span> " + name + "</span><br>\n"
		    var boxbody =  "<p class='definition_box_body'>" + body + "</p>"
		    return "<div class='common_box definition_box'>" + header + boxbody + "</div>"
	    }
        return undefined
    }
    
    function config_to_json(settings) {
    	var json = {}
        for (var setting of settings) {
        	json[setting[0]] = setting[1]
        }
        
        return json
    }
}

// Structure
document               = breakline* config:config breakline* body:body breakline*         { return {'config': config, 'body': body } }
config                 = settings:settings                                                { return settings }
body                   = blocks

// Utils
_                      = [ ]+ / breakline+                     { return "" }
breakline              = [\r\n]                                { return "" }
square_bracket         = "[" squared_content:$(!"]" .)+ "]"    { return squared_content }
round_bracket          = "(" rounded_content:$(!")" .)+ ")"    { return rounded_content }

// Special Expressions
math_expression        = $[^$]+
content_bold           = $(!"**" !"\n" .)*
content_italic         = $(!"_" !"\n" .)*
code_chars             = code:$[^`]*                           { return code.replace("<", "&lt;").replace(">", "&gt;") }

// Setting of Document
settings               = settings:setting*                                                { return config_to_json(settings) } 
setting                = key:setting_key assignment_symbol value:setting_value breakline* { return [key, value] }
setting_key            = $([a-z_]+)
setting_value          = $([^ \n][^\n]+)
assignment_symbol      = [ ]* "=" [ ]*

// Passage: Block
blocks                 = block*
block                  = self_defined_block / comment / list / image / horizontal / math_block / code_block / quote_block / h1 / h2 / h3/ h4 / h5 / h6 / paragraph / effective_breaklines / reference_block
comment                = "<!--" content_comment "-->"                     { return "" }
    content_comment    = $(!"-->" . breakline?)*
list                   = items:list_item+                                 { return "<ul>\n" + items.join("\n") + "\n</ul>" } 
    list_item          = list_flag item:char_component breakline*         { return "<li>" + item + "</li>" }
    list_flag          = ("* ") / ("- ")
image                  = "!" alternative:square_bracket ref:round_bracket { return "<img src='" + ref + "' alt='" + alternative + "' />"}
horizontal             = "---" "-"*                                       { return "<hr />" }
math_block             = "$$" expression:math_expression "$$"             { return "$$" + expression + "$$" }
code_block             = "```" code_block_option code:code_chars "```"    { return "<div class='common_box code_block'><pre><code>" + code + "</code></pre></div>" }
    code_block_option  = [^\n]* breakline                                 { return "" }
quote_block            = quote:quote_line+                                { return "<blockquote>" + quote.join("<br>") + "</blockquote>" }
    quote_line         = ">" [ ]* quote:$[^\n]* breakline?                { return quote }
h1                     = "# "      head:char_components breakline?        { return "<h1>" + head + "</h1>" }
h2                     = "## "     head:char_components breakline?        { return "<h2>" + head + "</h2>" }
h3                     = "### "    head:char_components breakline?        { return "<h3>" + head + "</h3>" }
h4                     = "#### "   head:char_components breakline?        { return "<h4>" + head + "</h4>" }
h5                     = "##### "  head:char_components breakline?        { return "<h5>" + head + "</h5>" }
h6                     = "###### " head:char_components breakline?        { return "<h6>" + head + "</h6>" }
paragraph              = passage:char_components breakline?               { return "<p>" + passage.join("") + "</p>" }
effective_breaklines   = breakline:breakline+                             { return "<br>" }
reference_block        = lines:reference_line+                            { return lines.join("<br>") }
    reference_line     = "[" id:[0-9]+ "] " url:[^\n]+                    { return "[" + id + "] " + url.join("") } 


// // Self-defined
self_defined_block     = definition / table_of_content / virtual_image
definition             = "def. " name:chars breakline body:indented_line* { return create_user_defined_box("definition", name, body.join("<br />")) }
    indented_line      = [ ]+ content:char_components                     { return content.join("") }
table_of_content       = "[toc]" / "[TOC]"
virtual_image          = $("<img:" [^>]+ ">")


// Inline arguments
char_components        = char_component+
char_component         = bold / italic / link / math_inline / inline_code / chars / reference / [ ]
bold                   = "**" content:content_bold   "**"                 { return "<strong>" + content + "</strong>" }
italic                 = "_"  content:content_italic "_"                  { return "<i>" + content + "</i>" }
link                   = content:square_bracket ref:round_bracket         { return "<a href='" + ref + "'>" + content + "</a>" }
math_inline            = "$" expression:$math_expression "$"              { return "$" + expression + "$" }
inline_code            = "`" code:$(!"`" .)+ "`"                          { return "<code class='common_box code_block'>" + code + "</code>" }
chars                  = $(!" **" !" _" !" `" !" $" !"[" !"\n" .)+
reference              = "[^" id:[0-9]+ "]"                               { return "[" + id + "]" }