Mbox = {}
ffwiki = require "Module:FFWiki"

function Mbox.main(frame)
  local fr = frame:getParent().args["image"] and frame:getParent() or frame
  f = ffwiki.emptystring(fr.args)

  local container = mw.html.create("table")
    :addClass("mbox")
    if f[1] and mw.text.trim(f[1]) == "SD" then container:addClass("SD") end

  local firstrow = container:tag("tr")

  local imagetd = firstrow:tag("td")
    :attr("rowspan", "2")
    :addClass("mbox-image")
    :wikitext("[[File:" .. f["image"] .. "|" .. (f["imagesize"] or "75px") .. "]]")

  local characterquote = mw.html.create("span")
      :addClass("quote")
      :wikitext(f["characterquote"])

  local quotetd = firstrow:tag("td")
    :addClass("mbox-quote")
    :wikitext(frame:expandTemplate({ title = "SL", args = {f["character"], f["characterlink"] or f["character"], color = "white" }}) .. ": "):node(characterquote)
  
  local secondrow = container:tag("td")
  
  local text = secondrow:wikitext(f["text"])

  return container
end

return Mbox
