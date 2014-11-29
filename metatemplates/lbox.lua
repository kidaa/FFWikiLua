Lbox = {}
ffwiki = require "Module:FFWiki"

function Lbox.main(frame)
  local fr = frame:getParent().args["text"] and frame:getParent() or frame
  f = ffwiki.emptystring(fr.args)

  local container = mw.html.create("table")
    :addClass("lbox")
    :addClass("darklinks")

  local firstrow = container:tag("tr")

  local license = f["license"] and string.sub(f["license"], 0, 4):lower() or ""

  local imageswitch, captionswitch = (function(a)
    if a == "publ" then 
      return "PD-icon", "Public Domain"
    elseif a == "fair" then 
      return "Fair use logo", "Fair Use"
    elseif a=="crea" or a=="cc" then 
      return "CreativeCommons", "Creative Commons"
    else
      return "Red copyright", "Copyright"
    end
  end)(license)

  local imagecolumn = firstrow:tag("td")
    :addClass("lbox-image")
    :wikitext("[[File:" .. imageswitch .. ".png|" .. (f["imagesize"] or "85px") .. "|" .. captionswitch .. "]]")

  local textcolumn = firstrow:tag("td")
    :wikitext(f["text"])

  return container
end
 
return Lbox
