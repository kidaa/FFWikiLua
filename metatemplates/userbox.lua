Userbox = {}
ffwiki = require "Module:FFWiki"

function Userbox.main(frame)
  local fr = frame:getParent().args["text"] and frame:getParent() or frame
  f = ffwiki.emptystring(fr.args)

  local container = mw.html.create("table")
    :addClass("userbox")
    :addClass(f["class"] and f["class"] or "")
    :attr("cellspacing", "0")
    :css("border", f["bordercolor"] and "solid " .. f["bordercolor"] .. " 1px" or "")
    :css("background", f["textbg"] and f["textbg"] or "")

  local row = container:tag("tr")

  local image1 = row:tag("td")
    :addClass("userbox-image")
    :addClass(f["class"] and "a" or "")
    :css("background", f["imagebg"] or "")
    :css("color", f["textimage"] or "")
    :wikitext(f["image"])

  local text = row:tag("td")
    :addClass("userbox-text")
    :addClass(f["class"] and "b" or "")
    :css("color", f["fontcolor"] or "")
    :wikitext(f["text"])

  if f["image2"] then local image2 = row:tag("td")
    :addClass("userbox-image")
    :addClass(f["class"] and "a" or "")
    :css("background", f["imagebg2"] or "")
    :css("color", f["textimage2"] or "")
    :wikitext(f["image2"])
  end

  return container
end
 
return Userbox
