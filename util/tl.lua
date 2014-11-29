tl = {}

function tl.new(frame)
  local string = require "Module:String"
  local array = require "Module:Array"

  local subst = false
  local substdisplay = ""
  local invoke = falsef
  local invokedisplay = ""
  local ns = "Template"
  local nsdisplay = ""
  local page = ""
  local pagedisplay =""
  local pagefollow = ""

  local prefix = { "|", "int|MediaWiki", "Final Fantasy Wiki|Project", "User|User", "Etymology|Etymology", "MediaWiki|MediaWiki", "Template|Template", "Project|Project" }
  local self = { "#if", "#ifeq", "#switch", "plural", "#ifexpr", "gender", "#iferror", "#ifexist", "ifsubst", "ifstring", "ifnum", "ifregistered", "ifuser", "ifgroup" }
  local selfpage = "Help:Selection Functions"
  local strf = { "lc", "uc", "lcfirst", "ucfirst", "urlencode", "#urldecode", "anchorencode", "#len", "#pos", "#rpos", "#sub", "#explode", "splitjoin", "padleft", "padright", "#pad", "char", "#replace", "parameterize" }
  local strfpage = "Help:String Functions"
  local matf = { "#expr", "%", "round", "cap" }
  local matfpage = "Help:Mathematical Functions"
  local magw = { "TOCright", "TOCleft", "TOClimit", "DISPLAYTITLE", "DEFAULTSORT", "PAGENAME", "NAMESPACE", "FULLPAGENAME", "SUBPAGENAME", "BASEPAGENAME", "FULLBASEPAGENAME", "ROOTPAGENAME", "FULLROOTPAGENAME", "TALKSPACE", "TALKPAGENAME", "CURRENTTIMESTAMP", "CURRENTDATETIME", "CURRENTYEAR", "CURRENTMONTH", "CURRENTMONTHNAME", "CURRENTMONTHABBREV", "CURRENTWEEK", "CURRENTDAY", "CURRENTDAY2", "CURRENTDOW", "CURRENTDAYNAME", "CURRENTTIME", "CURRENTHOUR", "CURRENTMINUTE", "CURRENTSECOND", "NUMBEROFCONTENT", "NUMBEROFARTICLES", "NUMBEROFPAGES", "NUMBEROFFILES", "NUMBEROFEDITS", "NUMBEROFUSERS", "NUMBEROFACTIVEUSERS", "NUMBEROFMODS", "NUMBEROFADMINS", "USERNAME", "SITENAME", "SERVER", "SERVERNAME" }
  local magwpage = "Help:Magic Words"
  local nopg = { "formatnum", "ns", "pagesincategory", "#invoke", "#time", "#tag" }

  temp = frame:getParent().args[1] and frame:getParent() or frame
  temp = require "Module:FFWiki".reargs(temp.args)

  a = array.shift(temp) or ""
  b = array.join(temp, "&#124;")

  if string.sub(string.lower(a), 1, 6) == "subst:" then
    subst = true
    substdisplay = string.sub(a, 1, 6)
    a = string.sub(a, 7)
  end

  if string.sub(string.lower(a), 1, 8) == "#invoke:" then
    invoke = true
    invokedisplay = string.sub(a, 1, 8)
    ns = "Module"
    nsdisplay = ""
    a = string.sub(a, 9)
  end

  if string.find(a, ":")~= nil then
    local spl = string.split(a, ":")
    nsdisplay = array.shift(spl)
    for i=1, #prefix do
      if string.lower(nsdisplay) == string.split(string.lower(prefix[i]), "|")[1] then
        ns = string.split(prefix[i], "|")[2]
        if ns=="" then nsdisplay = ":" end
        pagedisplay = array.join(spl, ":")
        break
      end
      if i==#prefix then
        pagedisplay = nsdisplay
        nsdisplay = ""
        ns = "Template"
        pagefollow = ":" .. array.join(spl, ":")
      end
    end
  end

  if pagedisplay == "" then pagedisplay = a end

  page = pagedisplay

  if nsdisplay == "" and not invoke then
    if     array.indexof(self, string.lower(string.sub(pagedisplay, 1, 1)) .. string.sub(pagedisplay, 2)) ~= -1 then page = string.split(selfpage, ":")[2] .. "#" .. pagedisplay; ns = string.split(selfpage, ":")[1]
    elseif array.indexof(strf, string.lower(string.sub(pagedisplay, 1, 1)) .. string.sub(pagedisplay, 2)) ~= -1 then page = string.split(strfpage, ":")[2] .. "#" .. pagedisplay; ns = string.split(strfpage, ":")[1]
    elseif array.indexof(matf, string.lower(string.sub(pagedisplay, 1, 1)) .. string.sub(pagedisplay, 2)) ~= -1 then page = string.split(matfpage, ":")[2] .. "#" .. pagedisplay; ns = string.split(matfpage, ":")[1]
    elseif array.indexof(magw, string.lower(string.sub(pagedisplay, 1, 1)) .. string.sub(pagedisplay, 2)) ~= -1 then page = string.split(magwpage, ":")[2] .. "#" .. pagedisplay; ns = string.split(magwpage, ":")[1]
    elseif array.indexof(nopg, string.lower(string.sub(pagedisplay, 1, 1)) .. string.sub(pagedisplay, 2)) ~= -1 then page = ""
    else
      page = pagedisplay
    end
  end

  local pref = (subst and substdisplay or "") .. (invoke and invokedisplay or "")
  local link = page~="" and (ns .. (ns=="" and "" or ":") .. page) or ""
  local text = nsdisplay .. ((nsdisplay=="" or nsdisplay==":") and"" or ":") .. pagedisplay
  local suff = pagefollow

  local out = "{{" .. pref .. (link~="" and ("[[" .. link .. "|" .. text .. "]]") or text) .. suff .. (b~="" and "|" .. b or "") .. "}}"

  return '<span class="code">' .. out .. '</span>'
end

return tl
