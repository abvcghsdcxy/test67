--bobtholamews ui lib :heart: :fire: :300 gadgillion dollhairs:
--line 25  locals / services
--line 36  library table
--line 58  key maps
--line 66  color constants
--line 94  text helpers
--line 149  icon cache / element heights
--line 186  element helpers
--line 269  drawing primitives
--line 352  config system
--line 458  window / tabs
--line 551  addon registration
--line 557  addon tab builder
--line 633  hooks
--line 637  groupbox builders
--line 871  render loop (Step)
--line 2735  loading screen
--line 2825  notifications
--line 2852  draggable labels
--line 2875  theme system
--line 2954  dialogs
--line 3005  ui settings tab
--line 3115  init / destroy

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local floor,ceil,max,min,abs,pow=math.floor,math.ceil,math.max,math.min,math.abs,math.pow
local random,rad,cos,sin=math.random,math.rad,math.cos,math.sin
local sort,concat,remove=table.sort,table.concat,table.remove
local sub,match,format,lower,find,gmatch,gsub,upper,rep=string.sub,string.match,string.format,string.lower,string.find,string.gmatch,string.gsub,string.upper,string.rep
local v2,c3,rgb,hsv=Vector2.new,Color3.new,Color3.fromRGB,Color3.fromHSV
local FNT_ID=5
local _b=("1429064".."510140".."059649")

local Library = {
    Drawings={},Tabs={},ActiveTab=nil,Notifications={},DraggableLabels={},
    Flags={},Options={},Toggles={},Callbacks={},Defaults={},Keybinds={},
    Addons={},_aHooks={Step={},Render={},Toggle={},FlagChange={},Destroy={}},_customEls={},
    State={
        Open=true,Tick=0,ToggleKey=0x2E,
        Drag=false,DragOff=v2(0,0),
        Resize=false,ResizeAnchor=v2(0,0),ResizeBase=v2(0,0),
        ActiveSlider=nil,
        ActiveDD=nil,
        ActiveCP=nil,CPDrag=nil,
        FocusInput=nil,KBListen=nil,
        SearchText="",SearchFocused=false,
        HoverTooltip=nil,HoverStart=0,
        IndPos=nil,IndDrag=false,IndDragOff=v2(0,0),
        WMPos=v2(20,20),WMDrag=false,WMDragOff=v2(0,0),
    },
    Input={MX=0,MY=0,Down=false,Prev=false,Click=false,RDown=false,RPrev=false,RClick=false,Keys={}},
    Window=nil,
}

local VKS={0x23,0x1B,0x21,0x22,0x10,0x11,0x12}
local VK={[0x41]="A",[0x42]="B",[0x43]="C",[0x44]="D",[0x45]="E",[0x46]="F",[0x47]="G",[0x48]="H",[0x49]="I",[0x4A]="J",[0x4B]="K",[0x4C]="L",[0x4D]="M",[0x4E]="N",[0x4F]="O",[0x50]="P",[0x51]="Q",[0x52]="R",[0x53]="S",[0x54]="T",[0x55]="U",[0x56]="V",[0x57]="W",[0x58]="X",[0x59]="Y",[0x5A]="Z",[0x30]="0",[0x31]="1",[0x32]="2",[0x33]="3",[0x34]="4",[0x35]="5",[0x36]="6",[0x37]="7",[0x38]="8",[0x39]="9",[0x70]="F1",[0x71]="F2",[0x72]="F3",[0x73]="F4",[0x74]="F5",[0x75]="F6",[0x76]="F7",[0x77]="F8",[0x78]="F9",[0x79]="F10",[0x7A]="F11",[0x7B]="F12",[0x10]="Shift",[0x11]="Ctrl",[0x12]="Alt",[0x20]="Space",[0x1B]="Esc",[0x08]="Bksp",[0x0D]="Enter",[0x09]="Tab",[0x23]="End",[0x24]="Home",[0x21]="PgUp",[0x22]="PgDn",[0x2D]="Ins",[0x2E]="Del",[0x05]="M4",[0x06]="M5"}
local VKC={[0x41]="a",[0x42]="b",[0x43]="c",[0x44]="d",[0x45]="e",[0x46]="f",[0x47]="g",[0x48]="h",[0x49]="i",[0x4A]="j",[0x4B]="k",[0x4C]="l",[0x4D]="m",[0x4E]="n",[0x4F]="o",[0x50]="p",[0x51]="q",[0x52]="r",[0x53]="s",[0x54]="t",[0x55]="u",[0x56]="v",[0x57]="w",[0x58]="x",[0x59]="y",[0x5A]="z",[0x30]="0",[0x31]="1",[0x32]="2",[0x33]="3",[0x34]="4",[0x35]="5",[0x36]="6",[0x37]="7",[0x38]="8",[0x39]="9",[0x20]=" ",[0xBE]=".",[0xBD]="-",[0xBC]=",",[0xBF]="/"}
local VKAll={}; for k in pairs(VK) do VKAll[#VKAll+1]=k end; for k in pairs(VKC) do if not VK[k] then VKAll[#VKAll+1]=k end end
Library._TY_MAP={toggle="Tgl",tgl="Tgl",checkbox="Chk",chk="Chk",check="Chk",slider="Sld",sld="Sld",range="RSld",rangeslider="RSld",rsld="RSld",dropdown="DD",dd="DD",drop="DD",select="DD",input="Inp",inp="Inp",text="Inp",textbox="Inp",button="Btn",btn="Btn",label="Lbl",lbl="Lbl",divider="Div",div="Div",separator="Div",colorpicker="CP",color="CP",cp="CP",keybind="KB",keypicker="KB",kb="KB",key="KB",image="Img",img="Img",multicombo="MC",multi="MC",mc="MC"}
local MIN_W,MIN_H=480,360; local MIN_SIDE,MIN_CONTENT=128,256; local RESIZE_ZONE=24
local TAB_H,GB_HDR,GB_PAD,GB_SPACE,GB_GAP,COL_PAD,COL_GAP=40,34,7,8,6,6,6

local COL={
    BG=rgb(15,15,15),BG_DK=rgb(13,13,13),BG_LT=rgb(17,17,17),
    MAIN=rgb(25,25,25),OUTLINE=rgb(40,40,40),ACCENT=rgb(125,85,255),
    FONT=rgb(255,255,255),FONT50=rgb(128,128,128),FONT40=rgb(153,153,153),
    SHADOW=rgb(0,0,0),BOT=rgb(23,23,23),
    HOV20=rgb(20,20,20),HOV22=rgb(22,22,22),DD18=rgb(18,18,18),
    SBT55=rgb(55,55,55),SBT75=rgb(75,75,75),SBT90=rgb(90,90,90),
    DEP18=rgb(18,18,18),RISKY=rgb(255,50,50),
    BG_TP=rgb(20,20,22),OL_TP=rgb(45,45,50),FNT_TP=rgb(235,235,240),
    N_BG=rgb(20,20,22),N_OL=rgb(45,45,50),N_ACC=rgb(125,85,255),
    N_FNT=rgb(235,235,240),N_DESC=rgb(150,150,160),N_TB=rgb(12,12,14),
    BG_D=rgb(18,18,20),BG2_D=rgb(22,22,25),OL_D=rgb(45,45,50),OL2_D=rgb(60,60,65),
    MAIN_D=rgb(32,32,36),FNT_D=rgb(245,245,250),DESC_D=rgb(175,175,185),
    DLG_PRI=rgb(125,85,255),DLG_PRI_OL=rgb(95,60,200),
    DLG_DEL=rgb(220,38,38),DLG_DEL_OL=rgb(180,30,30),
}

local function shade(c,amt)
    local r=c.R*255+amt; local g=c.G*255+amt; local b=c.B*255+amt
    if r<0 then r=0 end; if r>255 then r=255 end
    if g<0 then g=0 end; if g>255 then g=255 end
    if b<0 then b=0 end; if b>255 then b=255 end
    return rgb(r,g,b)
end
local function scale(c,s)
    return rgb(c.R*255*s,c.G*255*s,c.B*255*s)
end

local function tw(s,sz) return #s*(sz*0.52) end
local wrapLines
local function wrapLinesCached(el,text,sz,maxW)
    if el._wrpTx==text and el._wrpSz==sz and el._wrpW==maxW and el._wrpLn then return el._wrpLn end
    el._wrpLn=wrapLines(text,sz,maxW)
    el._wrpTx=text; el._wrpSz=sz; el._wrpW=maxW
    return el._wrpLn
end
wrapLines=function(text,sz,maxW)
    if not text or text=="" then return{""} end
    if maxW<=0 then return{text} end
    local lines={}; local cur=""
    for w in gmatch(text,"%S+") do
        local test=cur=="" and w or cur.." "..w
        if #test*(sz*0.52)<=maxW then cur=test
        else
            if cur~="" then lines[#lines+1]=cur end
            if #w*(sz*0.52)>maxW then
                local maxChars=max(1,floor(maxW/(sz*0.52)))
                local i=1
                while i<=#w do lines[#lines+1]=sub(w,i,i+maxChars-1); i=i+maxChars end
                cur=""
                if #lines>0 then cur=lines[#lines]; lines[#lines]=nil end
            else cur=w end
        end
    end
    if cur~="" then lines[#lines+1]=cur end
    if #lines==0 then lines[1]="" end
    return lines
end
local function truncFit(s,sz,maxW)
    if not s or s=="" then return s end
    if #s*(sz*0.52)<=maxW then return s end
    local maxChars=floor(maxW/(sz*0.52))-1
    if maxChars<2 then return"" end
    return sub(s,1,maxChars-1)..".."
end
local function tailFit(s,sz,maxW)
    if not s or s=="" then return s end
    if #s*(sz*0.52)<=maxW then return s end
    local maxChars=floor(maxW/(sz*0.52))
    if maxChars<1 then return"" end
    return sub(s,#s-maxChars+1)
end
local _imx,_imy=0,0
local function inB(x,y,w,h) return _imx>=x and _imx<=x+w and _imy>=y and _imy<=y+h end
local function clamp(v,lo,hi) return v<lo and lo or v>hi and hi or v end
local function bary(px,py,ax,ay,bx,by,cx,cy)
    local d=(by-cy)*(ax-cx)+(cx-bx)*(ay-cy); if d==0 then return -1,-1,-1 end
    local a=((by-cy)*(px-cx)+(cx-bx)*(py-cy))/d
    local b=((cy-ay)*(px-cx)+(ax-cx)*(py-cy))/d
    return a,b,1-a-b
end

local IconCache={}
local IconRetry={}
local ICON_URL="https://raw.githubusercontent.com/27timenumber1gurningchampionworldwide/ObsidianLib/main/icons/"
local function fetchIcon(url)
    if not url or url=="" then return end
    if not(sub(url,1,4)=="http") then url=ICON_URL..url..".png" end
    if IconCache[url]==nil then
        IconCache[url]="fetching"; IconRetry[url]={n=0,t=0}
        task.spawn(function()
            local ok,data=pcall(function() return game:HttpGet(url) end)
            if ok and type(data)=="string" and #data>8 and sub(data,1,4)=="\137PNG" then
                IconCache[url]=data; IconRetry[url]=nil
            else
                IconCache[url]=false; IconRetry[url]={n=1,t=os.clock()}
                if errorl then errorl("[ObsidianLib] icon fetch failed, retrying: "..url) end
            end
        end)
    end
    if IconCache[url]==false and IconRetry[url] and IconRetry[url].n<50 and os.clock()-IconRetry[url].t>=2.5 then
        IconRetry[url].t=os.clock(); IconRetry[url].n=IconRetry[url].n+1
        local attempt=IconRetry[url].n
        IconCache[url]="fetching"
        task.spawn(function()
            local ok,data=pcall(function() return game:HttpGet(url) end)
            if ok and type(data)=="string" and #data>8 and sub(data,1,4)=="\137PNG" then
                IconCache[url]=data; IconRetry[url]=nil
            else
                IconCache[url]=false
                if attempt>=50 then IconRetry[url]=nil; if errorl then errorl("[ObsidianLib] icon gave up after 50 attempts: "..url) end end
            end
        end)
    end
    return url
end
local function r2h(c) local r,g,b=c.R,c.G,c.B; local mx,mn=max(r,g,b),min(r,g,b); local d,h,s,v=mx-mn,0,0,mx; if mx~=0 then s=d/mx end; if d~=0 then if mx==r then h=(g-b)/d+(g<b and 6 or 0) elseif mx==g then h=(b-r)/d+2 else h=(r-g)/d+4 end; h=h/6 end; return h,s,v end

local EH={Tgl=18,Chk=18,Btn=21,Sld=33,RSld=33,MC=21,DD=39,Inp=39,Lbl=18,Div=6,CP=18,KB=18,Img=100}
local function _kbSet(arr) local s={}; if arr then for _,k in ipairs(arr) do s[k]=true end; return s end end
local function _kbModeShown(kd)
    if not kd or not kd.Modes or #kd.Modes<2 then return false end
    if not kd._modeShownTick or os.clock()-kd._modeShownTick>5 then return false end
    return true
end
local function _kbModeSfx(kd) if not _kbModeShown(kd) then return"" end; return" ["..(kd.Mode and sub(kd.Mode,1,1) or"T").."]" end
local function _kbRClick(kd)
    local now=os.clock(); local last=kd._lastRClick or 0
    if kd._modeShownTick and os.clock()-kd._modeShownTick<=5 and now-last<0.4 and kd.Modes and #kd.Modes>1 then
        local cur=1
        for i,m in ipairs(kd.Modes) do if m==kd.Mode then cur=i; break end end
        kd.Mode=kd.Modes[(cur%#kd.Modes)+1]
        if kd._onChanged then pcall(kd._onChanged,kd.Name,kd.Mode) end
    end
    kd._modeShownTick=now; kd._lastRClick=now
end
local function elCommon(el,c)
    if c and c.Visible~=nil then el.Visible=c.Visible end
    if el.Visible==nil then el.Visible=true end
    function el:SetVisible(v) self.Visible=v end
end
local function mkKP(parentId,kpId,tx)
    local kp={Id=kpId,Tx=tx,_parentId=parentId}
    function kp:GetState()
        local f=Library.Flags[self._parentId]
        return type(f)=="boolean" and f or false
    end
    function kp:SetValue(name)
        local kd=Library.Keybinds[kpId]
        kd.Name=name or"none"; kd.Key=nil; kd.Mods={}
        if name and name~="none" and name~=".." then
            for part in gmatch(name,"[^%+]+") do
                if part=="Ctrl" then kd.Mods[0x11]=true
                elseif part=="Shift" then kd.Mods[0x10]=true
                elseif part=="Alt" then kd.Mods[0x12]=true
                else for kc,kn in pairs(VK) do if kn==part then kd.Key=kc; break end end end
            end
        end
    end
    function kp:SetText(t) self.Tx=t end
    function kp:OnClick(fn) Library.Keybinds[kpId]._onClick=fn end
    function kp:OnChanged(fn) Library.Keybinds[kpId]._onChanged=fn end
    function kp:GetMode() local kd=Library.Keybinds[kpId]; return kd and kd.Mode or"Toggle" end
    function kp:SetMode(m) local kd=Library.Keybinds[kpId]; kd.Mode=m; if kd._onChanged then pcall(kd._onChanged,kd.Name,kd.Mode) end end
    return kp
end
local function elH(el)
    if el.Visible==false then return 0 end
    if el.Ty=="Sld" and el.Compact then return 15 end
    if el.Ty=="DD" and not el.Tx then return 21 end
    if el.Ty=="Inp" and not el.Tx then return 21 end
    if el.Ty=="MC" then local r=el._mcRows or 1; return(el.Tx and 18 or 0)+r*21+(r-1)*4 end
    if el.Ty=="Img" then return(el.Sz and el.Sz.Y) or el.Height or 100 end
    if el.Ty=="Div" then
        local h=(el.Tx and el.Tx~="") and 16 or 6
        return h+(el.MarginTop or 0)+(el.MarginBottom or 0)
    end
    if el.Ty=="Lbl" and el.Wrap and el._lastW and el._lastW>0 then
        local lns=wrapLinesCached(el,el.Tx or"",el.Sz or 14,el._lastW)
        return max(1,#lns)*18
    end
    if el.Ty=="DepBox" or el.Ty=="DepGB" then
        if not el:_checkDeps() then return 0 end
        local h=0; for i,sub in ipairs(el.Els) do if i>1 then h=h+GB_SPACE end; h=h+(elH(sub) or 0) end
        if el.Ty=="DepGB" then h=h+GB_PAD*2+2 end
        return h
    end
    if el.Custom and el._reg then local hf=el._reg.Height; if type(hf)=="function" then return hf(el) end; if type(hf)=="number" then return hf end end
    return EH[el.Ty] or 18
end
local function gbH(g) local h=GB_PAD*2; local visCount=0; for i,el in ipairs(g.Els) do local eh=elH(el); if eh>0 then if visCount>0 then h=h+GB_SPACE end; h=h+eh; visCount=visCount+1 end end; if #g.Els==0 or visCount==0 then h=h+20 end; return GB_HDR+1+h end
local TB_BTN_H=34
local function tbH(tb)
    local activeH=GB_PAD*2+20
    for _,st in ipairs(tb.SubTabs) do if st.Name==tb.ActiveSub then
        activeH=GB_PAD*2; for i,el in ipairs(st.Els) do if i>1 then activeH=activeH+GB_SPACE end; activeH=activeH+elH(el) end
        if #st.Els==0 then activeH=activeH+20 end; break end end
    return TB_BTN_H+1+activeH
end

local function _v2ne(a,b) return not b or a.X~=b.X or a.Y~=b.Y end
local function _c3ne(a,b) return not b or a.R~=b.R or a.G~=b.G or a.B~=b.B end
function Library:D(id,dt,p)
    if self.State._noDraw then return end
    local D=self.Drawings; local c=D[id]; if not c then c={O=Drawing.new(dt),Tk=self.State.Tick,P={}}; D[id]=c end
    local o,cp=c.O,c.P; local vis=p.Visible~=false
    if cp.Visible~=vis then o.Visible=vis; cp.Visible=vis end
    if not vis then c.Tk=self.State.Tick; return o end
    local v
    v=p.Text; if v~=nil and cp.Text~=v then o.Text=v; cp.Text=v end
    v=p.Size; if v~=nil then if type(v)=="number" then if cp.Size~=v then o.Size=v; cp.Size=v end elseif _v2ne(v,cp.Size) then o.Size=v; cp.Size=v end end
    v=p.Font; if v~=nil and cp.Font~=v then o.Font=v; cp.Font=v end
    v=p.Color; if v~=nil and _c3ne(v,cp.Color) then o.Color=v; cp.Color=v end
    v=p.Transparency; if v~=nil and cp.Transparency~=v then o.Transparency=v; cp.Transparency=v end
    v=p.ZIndex; if v~=nil and cp.ZIndex~=v then o.ZIndex=v; cp.ZIndex=v end
    v=p.Position; if v~=nil and _v2ne(v,cp.Position) then o.Position=v; cp.Position=v end
    v=p.Filled; if v~=nil and cp.Filled~=v then o.Filled=v; cp.Filled=v end
    v=p.Thickness; if v~=nil and cp.Thickness~=v then o.Thickness=v; cp.Thickness=v end
    v=p.Radius; if v~=nil and cp.Radius~=v then o.Radius=v; cp.Radius=v end
    v=p.NumSides; if v~=nil and cp.NumSides~=v then o.NumSides=v; cp.NumSides=v end
    v=p.Center; if v~=nil and cp.Center~=v then o.Center=v; cp.Center=v end
    if dt=="Text" then v=p.Outline; if v==nil then v=true end; if cp.Outline~=v then o.Outline=v; cp.Outline=v end end
    v=p.From; if v~=nil and _v2ne(v,cp.From) then o.From=v; cp.From=v end
    v=p.To; if v~=nil and _v2ne(v,cp.To) then o.To=v; cp.To=v end
    v=p.PointA; if v~=nil and _v2ne(v,cp.PointA) then o.PointA=v; cp.PointA=v end
    v=p.PointB; if v~=nil and _v2ne(v,cp.PointB) then o.PointB=v; cp.PointB=v end
    v=p.PointC; if v~=nil and _v2ne(v,cp.PointC) then o.PointC=v; cp.PointC=v end
    v=p.PointD; if v~=nil and _v2ne(v,cp.PointD) then o.PointD=v; cp.PointD=v end
    v=p.Data; if v~=nil and cp.Data~=v then
        if dt=="Image" and not(type(v)=="string" and #v>8 and(sub(v,1,4)=="\137PNG" or sub(v,1,2)=="\255\216")) then
            if cp.Visible then o.Visible=false; cp.Visible=false end; cp.Data=v; c.Tk=self.State.Tick; return o
        end
        o.Data=v; cp.Data=v
    end
    c.Tk=self.State.Tick; return o
end

local RR_SUFFIXES={"_h","_v","_tl","_tr","_bl","_br"}
local RR_HIDE={"_v","_tl","_tr","_bl","_br"}
function Library:RR(id,x,y,w,h,r,col,z,tr)
    tr=tr or 1; r=max(r,0); if w<1 or h<1 then return end
    r=min(r,floor(h/2),floor(w/2))
    if r<1 then
        self:D(id.."_h","Square",{Filled=true,Color=col,ZIndex=z,Transparency=tr,Position=v2(x,y),Size=v2(w,h)})
        local D,tk=self.Drawings,self.State.Tick
        for _,sfx in ipairs(RR_HIDE) do local c=D[id..sfx]; if c then if c.P.Visible then c.O.Visible=false; c.P.Visible=false end; c.Tk=tk end end
        return
    end
    self:D(id.."_h","Square",{Filled=true,Color=col,ZIndex=z,Transparency=tr,Position=v2(x+r,y),Size=v2(max(w-r*2,0),h)})
    local vh=h-r*2; if vh>0 then self:D(id.."_v","Square",{Filled=true,Color=col,ZIndex=z,Transparency=tr,Position=v2(x,y+r),Size=v2(w,vh)}) else self:D(id.."_v","Square",{Visible=false}) end
    self:D(id.."_tl","Circle",{Filled=true,Color=col,Radius=r,NumSides=20,ZIndex=z,Transparency=tr,Position=v2(x+r,y+r)})
    self:D(id.."_tr","Circle",{Filled=true,Color=col,Radius=r,NumSides=20,ZIndex=z,Transparency=tr,Position=v2(x+w-r,y+r)})
    self:D(id.."_bl","Circle",{Filled=true,Color=col,Radius=r,NumSides=20,ZIndex=z,Transparency=tr,Position=v2(x+r,y+h-r)})
    self:D(id.."_br","Circle",{Filled=true,Color=col,Radius=r,NumSides=20,ZIndex=z,Transparency=tr,Position=v2(x+w-r,y+h-r)})
end
function Library:HideRR(id)
    for _,sfx in ipairs(RR_SUFFIXES) do
        local c=self.Drawings[id..sfx]
        if c and c.P.Visible then c.O.Visible=false; c.P.Visible=false end
    end
end

local FAIL_ICON_URL=ICON_URL.."icon_template.png"
function Library:DrawFailIcon(id,x,y,sz,z)
    fetchIcon(FAIL_ICON_URL)
    local data=IconCache[FAIL_ICON_URL]
    if data and data~="fetching" and data~=false then
        self:D(id.."_xi","Image",{Data=data,Size=v2(sz,sz),Transparency=1,Color=c3(1,1,1),ZIndex=z+1,Position=v2(x,y)})
    else
        self:D(id.."_xi","Image",{Visible=false})
    end
end
function Library:HideFailIcon(id)
    self:D(id.."_xi","Image",{Visible=false})
end

function Library:Pill(id,x,y,w,h,col,z,tr)
    tr=tr or 1; local r=floor(h/2)
    self:D(id.."_l","Circle",{Filled=true,Color=col,Radius=r,NumSides=20,ZIndex=z,Transparency=tr,Position=v2(x+r,y+r)})
    self:D(id.."_r","Circle",{Filled=true,Color=col,Radius=r,NumSides=20,ZIndex=z,Transparency=tr,Position=v2(x+w-r,y+r)})
    local cw=w-r*2; if cw>0 then self:D(id.."_c","Square",{Filled=true,Color=col,ZIndex=z,Transparency=tr,Position=v2(x+r,y),Size=v2(cw,h)}) else self:D(id.."_c","Square",{Visible=false}) end
end

function Library:_CloseOverlays() self.State.ActiveDD=nil; self.State.ActiveCP=nil; self.State.CPDrag=nil; self.State.FocusInput=nil; self.State.KBListen=nil; self.State._ddScrollDrag=false; self.State.SearchFocused=false end

function Library:_ConfigFolder()
    local gid=tostring(pcall(function() return game.PlaceId end) and game.PlaceId or 0)
    pcall(makefolder,"ObsidianLib")
    pcall(makefolder,"ObsidianLib/config")
    pcall(makefolder,"ObsidianLib/config/"..gid)
    return "ObsidianLib/config/"..gid
end
function Library:SaveConfig(name)
    local folder=self:_ConfigFolder()
    local objs={}
    for id,el in pairs(self.Options) do
        if el.Ty=="Sld" then objs[#objs+1]={type="Slider",idx=id,value=tostring(self.Flags[id])}
        elseif el.Ty=="DD" then objs[#objs+1]={type="Dropdown",idx=id,value=self.Flags[id],multi=el.Multi or false}
        elseif el.Ty=="Inp" then objs[#objs+1]={type="Input",idx=id,text=self.Flags[id]}
        elseif el.Ty=="CP" then local c=self.Flags[id]; if typeof(c)=="Color3" then objs[#objs+1]={type="ColorPicker",idx=id,value=format("%02x%02x%02x",floor(c.R*255),floor(c.G*255),floor(c.B*255))} end
        end
    end
    for id,el in pairs(self.Toggles) do objs[#objs+1]={type="Toggle",idx=id,value=self.Flags[id]} end
    for id,kb in pairs(self.Keybinds) do objs[#objs+1]={type="KeyPicker",idx=id,key=kb.Name or"none",mode=kb.Mode or"Toggle"} end
    objs[#objs+1]={type="Font",value=FNT_ID}
    for _,dl in ipairs(self.DraggableLabels) do if dl.Id and dl._alive then objs[#objs+1]={type="DragLabel",idx=dl.Id,x=floor(dl.Pos.X),y=floor(dl.Pos.Y)} end end
    local _cs=tonumber(_b) or 0; for _,o in ipairs(objs) do _cs=(_cs+#(o.idx or""))%2147483647 end
    objs[#objs+1]={type="_cs",value=_cs}
    local ok,json=pcall(function() return HttpService:JSONEncode({objects=objs}) end)
    if ok then pcall(writefile,folder.."/"..name..".json",json); return true end
    return false
end
function Library:LoadConfig(name)
    local folder=self:_ConfigFolder()
    local path=folder.."/"..name..".json"
    local ok,raw=pcall(readfile,path); if not ok or not raw then return false end
    local ok2,data=pcall(function() return HttpService:JSONDecode(raw) end); if not ok2 or not data or not data.objects then return false end
    for _,obj in ipairs(data.objects) do
        if obj.type=="Toggle" and self.Toggles[obj.idx] then
            self.Flags[obj.idx]=obj.value; if self.Toggles[obj.idx].Value~=nil then self.Toggles[obj.idx].Value=obj.value end
            if self.Callbacks[obj.idx] then self.Callbacks[obj.idx](obj.value) end
        elseif obj.type=="Slider" and self.Options[obj.idx] then
            local v=tonumber(obj.value); if v then self.Flags[obj.idx]=v; if self.Callbacks[obj.idx] then self.Callbacks[obj.idx](v) end end
        elseif obj.type=="Dropdown" and self.Options[obj.idx] then
            self.Flags[obj.idx]=obj.value; if self.Callbacks[obj.idx] then self.Callbacks[obj.idx](obj.value) end
        elseif obj.type=="Input" and self.Options[obj.idx] then
            self.Flags[obj.idx]=obj.text or""; if self.Callbacks[obj.idx] then self.Callbacks[obj.idx](obj.text) end
        elseif obj.type=="ColorPicker" and self.Options[obj.idx] then
            if #obj.value==6 then local r=tonumber(obj.value:sub(1,2),16); local g=tonumber(obj.value:sub(3,4),16); local b=tonumber(obj.value:sub(5,6),16); if r and g and b then local c=Color3.fromRGB(r,g,b); self.Flags[obj.idx]=c; if self.Callbacks[obj.idx] then self.Callbacks[obj.idx](c) end end end
        elseif obj.type=="KeyPicker" and self.Keybinds[obj.idx] then
            local kd=self.Keybinds[obj.idx]
            kd.Name=obj.key; kd.Mode=obj.mode; kd.Key=nil; kd.Mods={}
            if obj.key and obj.key~="none" and obj.key~=".." then
                for part in gmatch(obj.key,"[^%+]+") do
                    if part=="Ctrl" then kd.Mods[0x11]=true
                    elseif part=="Shift" then kd.Mods[0x10]=true
                    elseif part=="Alt" then kd.Mods[0x12]=true
                    else for kc,kn in pairs(VK) do if kn==part then kd.Key=kc; break end end end
                end
            end
        elseif obj.type=="Font" then
            self:SetFont(tonumber(obj.value) or 5)
        elseif obj.type=="DragLabel" and obj.idx then
            for _,dl in ipairs(self.DraggableLabels) do if dl.Id==obj.idx and dl._alive then dl.Pos=v2(tonumber(obj.x) or 20,tonumber(obj.y) or 60); break end end
        end
    end
    if self.Options.ConfigList then self.Flags.ConfigList=name end
    if self.Keybinds.MenuKeybind and self.Keybinds.MenuKeybind.Key then self.State.ToggleKey=self.Keybinds.MenuKeybind.Key end
    return true
end
function Library:DeleteConfig(name)
    local folder=self:_ConfigFolder()
    local path=folder.."/"..name..".json"
    if pcall(isfile,path) then pcall(delfile,path); return true end
    return false
end
function Library:ListConfigs()
    local folder=self:_ConfigFolder()
    local configs={}
    local ok,files=pcall(listfiles,folder)
    if ok and files then
        for _,file in ipairs(files) do
            local name=match(file,"([^/\\]+)%.json$")
            if name and name~="autoload" then configs[#configs+1]=name end
        end
    end
    return configs
end
function Library:SetAutoload(name)
    local folder=self:_ConfigFolder()
    pcall(writefile,folder.."/autoload.txt",name)
end
function Library:GetAutoload()
    local folder=self:_ConfigFolder()
    local ok,name=pcall(readfile,folder.."/autoload.txt")
    if ok and name then return name end
    return nil
end
function Library:ResetAutoload()
    local folder=self:_ConfigFolder()
    pcall(delfile,folder.."/autoload.txt")
end
function Library:LoadAutoloadConfig()
    local name=self:GetAutoload()
    if name then return self:LoadConfig(name) end
    return false
end

function Library:CreateWindow(cfg)
    cfg=cfg or{}; local sz=cfg.Size or v2(720,600); local pos=v2(100,100); local centered=false
    pcall(function() local vp=workspace.CurrentCamera.ViewportSize; if vp.X>0 and vp.Y>0 then pos=v2(floor((vp.X-sz.X)/2),floor((vp.Y-sz.Y)/2)); centered=true end end)
    self.Window={Title=cfg.Title or"mspaint",Pos=cfg.Position or pos,Size=sz,SideW=ceil(sz.X*0.3),HdrH=48,BotH=20,Sub=cfg.Subtitle or"",CR=cfg.CornerRadius or 4,Cfg=cfg.ConfigName or"Default",IconURL=cfg.Icon,BgImage=nil,BgImageTr=cfg.BackgroundImageTransparency or 0.85}
    self.Window._autoCenter=(cfg.Position==nil) and not centered
    if cfg.Icon then task.spawn(function() pcall(function() self.Window._titleIcon=game:HttpGet(cfg.Icon) end); self.Window._titleIconDone=true end) end
    if cfg.BackgroundImage then task.spawn(function() pcall(function() self.Window.BgImage=game:HttpGet(cfg.BackgroundImage) end); self.Window._bgImageDone=true end) end
    if cfg.ToggleKey then self.State.ToggleKey=cfg.ToggleKey end
    self.State.Open=false
    local ldCfg=cfg.Loading
    if ldCfg~=false then
        local isCustom=type(ldCfg)=="table"
        local totalSteps=isCustom and #ldCfg or 3
        self._loading={Title=self.Window.Title,Step=0,Total=totalSteps,SmoothStep=0,Message="Initializing...",Description="",Alive=true,Angle=0,LastTick=os.clock(),Pos=v2(0,0),W=450,H=275,CR=self.Window.CR,TweenTime=1}
        for _,c in pairs(self.Drawings) do if c.P.Visible then c.O.Visible=false; c.P.Visible=false end end
        pcall(function() local vp=workspace.CurrentCamera.ViewportSize; if vp.X>0 and vp.Y>0 then self._loading.Pos=v2(floor((vp.X-450)/2),floor((vp.Y-275)/2)) end end)
        task.spawn(function()
            local ld=self._loading
            if isCustom then
                for i,s in ipairs(ldCfg) do
                    ld.Message=s.Message or s[1] or""; ld.Description=s.Description or s[2] or""; ld.Step=i-1
                    task.wait(s.Duration or s[3] or 1)
                end
                ld.Step=totalSteps
            else
                local function plr() local p; pcall(function() p=game:GetService("Players").LocalPlayer end); return p end
                ld.Total=1; ld.Step=0; ld.Message="Loading "..self.Window.Title.."..."
                ld.Description="Waiting for game"
                pcall(function() if not plr() then repeat task.wait(0.1) until plr() end end)
                pcall(function() local p=plr(); if p and not p.Character then p.CharacterAdded:Wait() end end)
                pcall(function() local p=plr(); if p and p.Character then p.Character:WaitForChild("HumanoidRootPart",5) end end)
                pcall(function() workspace:WaitForChild("Camera",5) end)
                ld.Description="Initializing interface"
                local t0=os.clock(); while not self._R and os.clock()-t0<10 do task.wait(0.05) end
                task.wait(0.1)
                local deadline=os.clock()+15
                while os.clock()<deadline do
                    local total,done=0,0
                    for _,iv in pairs(IconCache) do total=total+1; if iv~="fetching" then done=done+1 end end
                    if cfg.Icon then total=total+1; if self.Window._titleIconDone then done=done+1 end end
                    if cfg.BackgroundImage then total=total+1; if self.Window._bgImageDone then done=done+1 end end
                    if total==0 then break end
                    ld.Total=total; ld.Step=done; ld.Description="Loading assets ("..done.."/"..total..")"
                    if done>=total then break end
                    task.wait(0.05)
                end
                ld.Step=ld.Total
            end
            ld.Message="Done!"; ld.Description=""; task.wait(0.3)
            ld.Alive=false
            for _,c in pairs(self.Drawings) do if c.P.Visible then c.O.Visible=false; c.P.Visible=false end end
            self.State.Open=true
        end)
    else self.State.Open=true end

    local WI={}
    self._WI=WI
    function WI:AddTab(name,icon)
        if type(name)=="table" then icon=name.Icon; name=name.Name end
        local tab={Name=name,Icon=icon,LG={},RG={},Visible=true}
        if icon then tab._iconURL=fetchIcon(icon) end
        table.insert(Library.Tabs,tab)
        if not Library.ActiveTab then Library.ActiveTab=tab.Name end
        local TI={}
        function TI:AddLeftGroupbox(t) return Library:_BuildGroup(tab,"L",t) end
        function TI:AddRightGroupbox(t) return Library:_BuildGroup(tab,"R",t) end
        function TI:AddLeftTabbox(name) return Library:_BuildTabbox(tab,"L",name) end
        function TI:AddRightTabbox(name) return Library:_BuildTabbox(tab,"R",name) end
        function TI:SetVisible(v) tab.Visible=v end
        function TI:SetName(n) tab.Name=n; if Library.ActiveTab==name then Library.ActiveTab=n end; name=n end
        function TI:SetIcon(i) tab.Icon=i; tab._iconURL=fetchIcon(i) end
        return TI
    end
    function WI:ChangeTitle(t) Library.Window.Title=t end
    function WI:SetTitle(t) Library.Window.Title=t end
    function WI:SetSubtitle(s) Library.Window.Sub=s or"" end
    function WI:SetFooter(s) Library.Window.Sub=s or"" end
    function WI:SetCornerRadius(r) Library.Window.CR=r or 4 end
    function WI:Toggle(state)
        if state==nil then Library.State.Open=not Library.State.Open
        else Library.State.Open=state end
        if not Library.State.Open then Library:_CloseOverlays() end
    end
    function WI:IsOpen() return Library.State.Open end
    function WI:GetSize() return Library.Window.Size end
    function WI:SetSize(sz) Library.Window.Size=sz; Library.Window.SideW=clamp(ceil(sz.X*0.3),MIN_SIDE,sz.X-MIN_CONTENT) end
    function WI:GetPosition() return Library.Window.Pos end
    function WI:SetPosition(p) Library.Window.Pos=p end
    function WI:SetBackgroundImage(url,transparency)
        if url then task.spawn(function() pcall(function() Library.Window.BgImage=game:HttpGet(url) end) end)
        else Library.Window.BgImage=nil end
        if transparency then Library.Window.BgImageTr=transparency end
    end
    return WI
end

function Library:RegAddon(name,cfg)
    if self.Addons[name] then return end
    if type(cfg)=="function" then cfg={Init=cfg} end
    cfg.Name=name; cfg.Desc=cfg.Description or cfg.Desc or""; cfg.Author=cfg.Author or""; cfg.Version=cfg.Version or""; cfg.Icon=cfg.Icon
    self.Addons[name]=cfg; if self._R then pcall(cfg.Init,self) end
end; Library.RegisterAddon=Library.RegAddon
function Library:_BuildAddonTab()
    local all={}; for _,a in pairs(self.Addons) do all[#all+1]=a end
    if #all==0 or not self._WI then return end
    local CH,ISZ,CP=44,34,5; local TX=ISZ+CP*2+2
    local C_BG,C_BG2,C_OL,C_PH=rgb(22,22,24),rgb(28,28,30),rgb(40,40,42),rgb(35,35,38)
    local C_OL_HOV=rgb(55,55,58)
    self:RegEl("_ACard",{Height=CH,Draw=function(L,el,eid,x,y,w,h,blk)
        local a=el._data; if not a or w<10 then return end
        local hov=not blk and h>=20 and inB(x,y,w,h)
        if not el._hovT then el._hovT=0 end
        local dt=(L._tick or 0)-(el._lastTk or L._tick or 0); el._lastTk=L._tick or 0
        el._hovT=el._hovT+((hov and 1 or 0)-el._hovT)*min(dt*30,1)
        local t=el._hovT
        local bgR=22+6*t; local olR=40+15*t
        local bg=rgb(bgR,bgR,bgR+2); local ol=rgb(olR,olR,olR+2)
        L:RR("ac_b"..eid,x,y,w,h,0,bg,26); L:RR("ac_o"..eid,x,y,w,h,0,ol,25); L:RR("ac_i"..eid,x+1,y+1,w-2,h-2,0,bg,26)
        local showIco=h>CP; local showName=h>6+12; local showAuth=h>23+10
        local ix,iy=x+CP,y+CP
        local d=a._icoUrl and IconCache[a._icoUrl]; local isz=min(ISZ,h-CP*2)
        if showIco and d and d~="fetching" and d~=false then
            L:D("ac_ic"..eid,"Image",{Data=d,Size=v2(isz,isz),Transparency=1,ZIndex=27,Position=v2(ix,iy)})
            L:HideRR("ac_ph"..eid); L:D("ac_sp"..eid,"Circle",{Visible=false}); L:HideFailIcon("ac_fi"..eid)
        elseif showIco and d=="fetching" then
            L:D("ac_ic"..eid,"Image",{Visible=false}); L:HideFailIcon("ac_fi"..eid)
            L:RR("ac_ph"..eid,ix,iy,isz,isz,0,C_PH,27)
            local ct=L._tick or 0; local ang=(ct*4)%(math.pi*2); local cx,cy=ix+isz/2,iy+isz/2
            L:D("ac_sp"..eid,"Circle",{Filled=false,Color=rgb(125,85,255),Thickness=2,Radius=isz/2-4,NumSides=8,ZIndex=28,Transparency=0.5,Position=v2(cx+cos(ang)*2,cy+sin(ang)*2)})
        elseif showIco then
            L:D("ac_ic"..eid,"Image",{Visible=false}); L:D("ac_sp"..eid,"Circle",{Visible=false}); L:HideRR("ac_ph"..eid)
            L:DrawFailIcon("ac_fi"..eid,ix,iy,isz,27)
        else
            L:HideRR("ac_ph"..eid); L:D("ac_ic"..eid,"Image",{Visible=false}); L:D("ac_sp"..eid,"Circle",{Visible=false}); L:HideFailIcon("ac_fi"..eid)
        end
        local tx,tw2=x+TX,w-TX-CP; local nm=a.Name..(a.Version~="" and " v"..a.Version or "")
        if showName then L:D("ac_n"..eid,"Text",{Text=truncFit(nm,14,tw2),Size=15,Font=FNT_ID,Color=rgb(255,255,255),ZIndex=27,Position=v2(tx,y+6)})
        else L:D("ac_n"..eid,"Text",{Visible=false}) end
        if showAuth and a.Author~="" then L:D("ac_a"..eid,"Text",{Text=truncFit("by "..a.Author,13,tw2),Size=13,Font=FNT_ID,Color=rgb(120,120,130),ZIndex=27,Position=v2(tx,y+23)})
        else L:D("ac_a"..eid,"Text",{Visible=false}) end
        if hov and a.Desc~="" and truncFit(a.Desc,12,tw2)~=a.Desc then L.State._nextTooltip=a.Desc end
        if hov and L.Input.RClick and a.Settings then L.State._adnSel=a end
    end})
    local tab=self._WI:AddTab("Addons","package")
    local g=tab:AddLeftGroupbox("Installed ("..#all..")")
    local rg=nil; local built=nil
    local DEF_ICO=ICON_URL.."icon_template.png"
    for i,a in ipairs(all) do
        local ico=a.Icon or DEF_ICO; fetchIcon(ico); a._icoUrl=ico; if sub(ico,1,4)~="http" then a._icoUrl=ICON_URL..ico..".png" end
        g:AddCustom("_adn_"..i,{Type="_ACard",Data=a})
    end
    local function buildSettings(a)
        if built==a.Name then
            if rg then rg:SetVisible(not rg.Visible) end
            return
        end
        built=a.Name
        local nm=a.Name..(a.Version~="" and " v"..a.Version or "")
        if not rg then rg=tab:AddRightGroupbox(nm) else rg.Els={}; rg:SetName(nm); rg:SetVisible(true) end
        if a.Desc~="" then rg:AddLabel(a.Desc,{Size=13}) end
        if not a.Settings then return end
        for _,s in ipairs(a.Settings) do
            local ty=s.Type or s.type or""
            if ty=="Toggle" then rg:AddToggle(s.Id,{Text=s.Text,Default=s.Default,Callback=s.Callback,Tooltip=s.Tooltip})
            elseif ty=="Slider" then rg:AddSlider(s.Id,{Text=s.Text,Default=s.Default,Min=s.Min,Max=s.Max,Rounding=s.Rounding or 0,Suffix=s.Suffix,Prefix=s.Prefix,Callback=s.Callback,Tooltip=s.Tooltip})
            elseif ty=="Dropdown" then rg:AddDropdown(s.Id,{Text=s.Text,Default=s.Default,Values=s.Values,Multi=s.Multi,Callback=s.Callback,Tooltip=s.Tooltip})
            elseif ty=="Input" then rg:AddInput(s.Id,{Text=s.Text,Default=s.Default,Placeholder=s.Placeholder,Callback=s.Callback,Tooltip=s.Tooltip})
            elseif ty=="ColorPicker" then rg:AddColorPicker(s.Id,{Text=s.Text,Default=s.Default,Callback=s.Callback})
            elseif ty=="KeyPicker" then rg:AddLabel(s.Text or s.Id):AddKeyPicker(s.Id,{Default=s.Default,Text=s.Text or s.Id,Mode=s.Mode,Modes=s.Modes})
            elseif ty=="Label" then rg:AddLabel(s.Text or"",{Size=s.Size})
            end
        end
    end
    self:Hook("Step",function()
        local sel=self.State._adnSel; if not sel then return end
        self.State._adnSel=nil; buildSettings(sel)
    end)
end
function Library:Hook(ev,fn) local t=self._aHooks[ev]; if t then t[#t+1]=fn end end
function Library:_FHook(ev,...) for _,f in ipairs(self._aHooks[ev] or{}) do pcall(f,...) end end; Library._FireHook=Library._FHook
function Library:RegEl(name,cfg) self._customEls[name]=cfg; EH[name]=type(cfg.Height)=="number" and cfg.Height or nil end; Library.RegisterElement=Library.RegEl

function Library:_BuildGroup(tab,side,title)
    local g={Name=title,Side=side,Tab=tab.Name,Els={},Visible=true}
    if side=="L" then tab.LG[#tab.LG+1]=g else tab.RG[#tab.RG+1]=g end
    function g:SetVisible(v) self.Visible=v end
    function g:SetName(n) self.Name=n end
    function g:AddToggle(id,c) c=c or{}; Library.Flags[id]=c.Default or false; Library.Defaults[id]=c.Default or false; Library.Callbacks[id]=c.Callback
        local el={Ty="Tgl",Id=id,Tx=c.Text or"Toggle",Cb=c.Callback,Risky=c.Risky,Disabled=c.Disabled,Value=c.Default or false,CPs={},KP=nil,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        function el:SetValue(v) Library.Flags[id]=v; self.Value=v; if Library.Callbacks[id] then Library.Callbacks[id](v) end end
        function el:SetText(t) self.Tx=t end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        function el:AddColorPicker(cpId,cfg2) cfg2=cfg2 or{}; Library.Flags[cpId]=cfg2.Default or Color3.new(1,1,1); Library.Defaults[cpId]=cfg2.Default or Color3.new(1,1,1); Library.Callbacks[cpId]=cfg2.Callback
            local cp={Id=cpId,Cb=cfg2.Callback,_rx=0,_ry=0}; self.CPs[#self.CPs+1]=cp; Library.Options[cpId]=cp; return self end
        function el:AddKeyPicker(kpId,cfg2) cfg2=cfg2 or{}; Library.Keybinds[kpId]={Key=nil,Name=cfg2.Default or"..",Mods={},EN=cfg2.Text or kpId,Mode=cfg2.Mode or"Toggle",Modes=cfg2.Modes or{"Toggle","Hold"},Blacklist=_kbSet(cfg2.Blacklist),Whitelist=_kbSet(cfg2.Whitelist),NoBind=cfg2.NoBind,NoUI=cfg2.NoUI,SyncToggle=cfg2.SyncToggleState,ParentId=id}
            if cfg2.Default and cfg2.Default~="None" and cfg2.Default~="none" then for kc,kn in pairs(VK) do if kn==cfg2.Default then Library.Keybinds[kpId].Key=kc; break end end end
            self.KP=mkKP(id,kpId,cfg2.Text or kpId); Library.Options[kpId]=self.KP; return self end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; Library.Toggles[id]=el; return el end

    function g:AddCheckbox(id,c) c=c or{}; Library.Flags[id]=c.Default or false; Library.Defaults[id]=c.Default or false; Library.Callbacks[id]=c.Callback
        local el={Ty="Chk",Id=id,Tx=c.Text or"Checkbox",Cb=c.Callback,Risky=c.Risky,Disabled=c.Disabled,Value=c.Default or false,CPs={},KP=nil,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        function el:SetValue(v) Library.Flags[id]=v; self.Value=v; if Library.Callbacks[id] then Library.Callbacks[id](v) end end
        function el:SetText(t) self.Tx=t end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        function el:AddColorPicker(cpId,cfg2) cfg2=cfg2 or{}; Library.Flags[cpId]=cfg2.Default or Color3.new(1,1,1); Library.Defaults[cpId]=cfg2.Default or Color3.new(1,1,1); Library.Callbacks[cpId]=cfg2.Callback
            local cp={Id=cpId,Cb=cfg2.Callback,_rx=0,_ry=0}; self.CPs[#self.CPs+1]=cp; Library.Options[cpId]=cp; return self end
        function el:AddKeyPicker(kpId,cfg2) cfg2=cfg2 or{}; Library.Keybinds[kpId]={Key=nil,Name=cfg2.Default or"..",Mods={},EN=cfg2.Text or kpId,Mode=cfg2.Mode or"Toggle",Modes=cfg2.Modes or{"Toggle","Hold"},Blacklist=_kbSet(cfg2.Blacklist),Whitelist=_kbSet(cfg2.Whitelist),NoBind=cfg2.NoBind,NoUI=cfg2.NoUI,ParentId=id}
            if cfg2.Default and cfg2.Default~="None" and cfg2.Default~="none" then for kc,kn in pairs(VK) do if kn==cfg2.Default then Library.Keybinds[kpId].Key=kc; break end end end
            self.KP=mkKP(id,kpId,cfg2.Text or kpId); Library.Options[kpId]=self.KP; return self end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; Library.Toggles[id]=el; return el end
    function g:AddButton(c) c=c or{}
        local el={Ty="Btn",Tx=c.Text or"Button",Cb=c.Func or c.Callback,Risky=c.Risky,DblClick=c.DoubleClick,Disabled=c.Disabled,Subs={},_confirming=false,_confirmTick=0,_locked=false,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip,Img=fetchIcon(c.Image),ImgSz=c.ImageSize or 14,ImgPos=c.ImagePosition or"Left",ImgCol=c.ImageColor,ImgOnly=c.ImageOnly}; elCommon(el,c)
        function el:AddButton(c2) c2=c2 or{}; local sub={Tx=c2.Text or"Button",Cb=c2.Func or c2.Callback,Risky=c2.Risky,DblClick=c2.DoubleClick,Disabled=c2.Disabled,_confirming=false,_confirmTick=0,_locked=false,Img=fetchIcon(c2.Image),ImgSz=c2.ImageSize or 14,ImgPos=c2.ImagePosition or"Left",ImgCol=c2.ImageColor,ImgOnly=c2.ImageOnly}
            function sub:SetText(t) self.Tx=t end; function sub:SetDisabled(v) self.Disabled=v end
            function sub:SetImage(u) self.Img=fetchIcon(u) end
            self.Subs[#self.Subs+1]=sub; return el end
        function el:SetText(t) self.Tx=t end; function el:SetDisabled(v) self.Disabled=v end
        function el:SetImage(u) self.Img=fetchIcon(u) end
        function el:SetImageSize(s) self.ImgSz=s end
        function el:SetImagePosition(p) self.ImgPos=p end
        self.Els[#self.Els+1]=el; return el end
    function g:AddSlider(id,c) c=c or{}; local mn,mx=c.Min or 0,c.Max or 100
        Library.Flags[id]=clamp(c.Default or mn,mn,mx); Library.Defaults[id]=c.Default or mn; Library.Callbacks[id]=c.Callback
        local el={Ty="Sld",Id=id,Tx=c.Text or"Slider",Mn=mn,Mx=mx,Rnd=c.Rounding or 0,Pf=c.Prefix or"",Sf=c.Suffix or"",Compact=c.Compact,HideMax=c.HideMax,Fmt=c.FormatDisplayValue,Cb=c.Callback,Disabled=c.Disabled,_smoothFill=0,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        function el:SetValue(v) v=clamp(v,self.Mn,self.Mx); Library.Flags[id]=v; if Library.Callbacks[id] then Library.Callbacks[id](v) end end
        function el:SetText(t) self.Tx=t end
        function el:SetMin(v) self.Mn=v; Library.Flags[id]=clamp(Library.Flags[id],v,self.Mx) end
        function el:SetMax(v) self.Mx=v; Library.Flags[id]=clamp(Library.Flags[id],self.Mn,v) end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddRangeSlider(id,c) c=c or{}
        local mn,mx=c.Min or 0,c.Max or 100
        local def=c.Default or{mn,mx}
        local dMin=(type(def)=="table" and(def[1] or def.Min)) or mn
        local dMax=(type(def)=="table" and(def[2] or def.Max)) or mx
        dMin=clamp(dMin,mn,mx); dMax=clamp(dMax,mn,mx)
        if dMin>dMax then dMin,dMax=dMax,dMin end
        Library.Flags[id]={Min=dMin,Max=dMax}
        Library.Defaults[id]={Min=dMin,Max=dMax}
        Library.Callbacks[id]=c.Callback
        local el={Ty="RSld",Id=id,Tx=c.Text or"Range",Mn=mn,Mx=mx,Rnd=c.Rounding or 0,Pf=c.Prefix or"",Sf=c.Suffix or"",Cb=c.Callback,Disabled=c.Disabled,_drag=nil,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        function el:SetValue(lo,hi)
            local v=Library.Flags[id]; if type(v)~="table" then v={Min=self.Mn,Max=self.Mx} end
            if lo then v.Min=clamp(lo,self.Mn,self.Mx) end
            if hi then v.Max=clamp(hi,self.Mn,self.Mx) end
            if v.Min>v.Max then v.Min,v.Max=v.Max,v.Min end
            Library.Flags[id]=v
            if Library.Callbacks[id] then Library.Callbacks[id](v.Min,v.Max) end
        end
        function el:SetText(t) self.Tx=t end
        function el:SetMin(v) self.Mn=v end
        function el:SetMax(v) self.Mx=v end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddDropdown(id,c) c=c or{}
        local function normOpts(src)
            local names,imgs={},{}
            for i,v in ipairs(src or{}) do
                if type(v)=="table" then
                    names[i]=v.Name or v.Text or tostring(i)
                    if v.Image then imgs[names[i]]=fetchIcon(v.Image) end
                else names[i]=tostring(v) end
            end
            return names,imgs
        end
        local names,imgs=normOpts(c.Values or c.Options or{"None"})
        local el={Ty="DD",Id=id,Tx=c.Text,Opts=names,OptImgs=imgs,Multi=c.Multi,AllowNull=c.AllowNull,MaxI=c.MaxVisibleDropdownItems or c.MaxItems or 8,Cb=c.Callback,Disabled=c.Disabled,DisabledVals=c.DisabledValues or{},FmtDisp=c.FormatDisplayValue,FmtList=c.FormatListValue,_rx=0,_ry=0,_rw=0,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        local def=c.Default
        if el.Multi then
            if type(def)=="table" then local m={}; for _,v in ipairs(def) do m[v]=true end; def=m
            elseif type(def)=="number" then def={[el.Opts[def]]=true}
            else def={} end
        else
            if type(def)=="number" then def=el.Opts[def] elseif def==nil and not el.AllowNull then def=el.Opts[1] end
        end
        Library.Flags[id]=def; Library.Defaults[id]=def; Library.Callbacks[id]=c.Callback
        function el:SetValue(v) Library.Flags[id]=v; if Library.Callbacks[id] then Library.Callbacks[id](v) end end
        function el:SetValues(v)
            local n2,i2=normOpts(v)
            self.Opts=n2; self.OptImgs=i2
        end
        function el:AddValues(v)
            if type(v)=="table" then
                for _,x in ipairs(v) do
                    if type(x)=="table" then
                        local nm=x.Name or x.Text
                        self.Opts[#self.Opts+1]=nm
                        if x.Image then self.OptImgs[nm]=fetchIcon(x.Image) end
                    else self.Opts[#self.Opts+1]=x end
                end
            else self.Opts[#self.Opts+1]=v end
        end
        function el:SetText(t) self.Tx=t end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        function el:GetActiveValues() if self.Multi then local n=0; for _,v in pairs(Library.Flags[id] or{}) do if v then n=n+1 end end; return n else return Library.Flags[id] and 1 or 0 end end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddMultipleChoice(id,c) c=c or{}
        local opts={}
        for i,v in ipairs(c.Values or c.Options or{}) do
            if type(v)=="table" then opts[i]={Name=v.Name or v.Text or tostring(i),Img=fetchIcon(v.Image),Tooltip=v.Tooltip}
            else opts[i]={Name=tostring(v)} end
        end
        local el={Ty="MC",Id=id,Tx=c.Text,Opts=opts,Multi=c.Multi,Disabled=c.Disabled,Cb=c.Callback,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        local def=c.Default
        if el.Multi then
            if type(def)=="table" then local m={}; for _,v in ipairs(def) do m[v]=true end; def=m
            else def={} end
        else
            if type(def)=="number" and opts[def] then def=opts[def].Name
            elseif def==nil and opts[1] then def=opts[1].Name end
        end
        Library.Flags[id]=def; Library.Defaults[id]=def; Library.Callbacks[id]=c.Callback
        function el:SetValue(v) Library.Flags[id]=v; if Library.Callbacks[id] then Library.Callbacks[id](v) end end
        function el:SetText(t) self.Tx=t end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddInput(id,c) c=c or{}
        local el={Ty="Inp",Id=id,Tx=c.Text,PH=c.Placeholder or"",ML=c.MaxLength,Num=c.Numeric,AllowNeg=c.AllowNegative~=false,Finished=c.Finished,ClearOnFocus=c.ClearTextOnFocus==true,ClearOnBlur=c.ClearTextOnBlur,AllowEmpty=c.AllowEmpty~=false,EmptyReset=c.EmptyReset or"---",Verify=c.VerifyValue,Cb=c.Callback,Disabled=c.Disabled,_x=0,_y=0,_w=0,_h=0,Tooltip=c.Tooltip,DisabledTooltip=c.DisabledTooltip}; elCommon(el,c)
        if el.Verify and not el.Finished then el.Finished=true end
        local def=c.Default or""
        if not el.AllowEmpty and #def==0 then def=el.EmptyReset end
        if el.ML and #def>el.ML then def=sub(def,1,el.ML) end
        Library.Flags[id]=def; Library.Defaults[id]=def; Library.Callbacks[id]=c.Callback
        function el:SetValue(txt)
            if self.Disabled then Library.Flags[id]=txt; return end
            if not self.AllowEmpty and #tostring(txt)==0 then txt=self.EmptyReset end
            if self.ML and #txt>self.ML then txt=sub(txt,1,self.ML) end
            if self.Num and #txt>0 and not tonumber(txt) then txt=Library.Flags[id] end
            if self.Verify and txt~=self.EmptyReset and self.Verify(txt)~=true then txt=self.EmptyReset end
            Library.Flags[id]=txt; if Library.Callbacks[id] then Library.Callbacks[id](txt) end
        end
        function el:SetText(t) self.Tx=t end
        function el:SetDisabled(v) self.Disabled=v end
        function el:OnChanged(fn) Library.Callbacks[id]=fn end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddLabel(text,wrap,idx)
        local c={}
        if type(text)=="table" then c=text; text=c.Text or""
        elseif type(text)=="string" then c.Text=text end
        local el={Ty="Lbl",Tx=text or"",Col=c.Color,Sz=c.Size or 14,Wrap=wrap or c.DoesWrap,CPs={},KP=nil,Tooltip=c.Tooltip}; elCommon(el,c)
        function el:SetText(t) self.Tx=t end
        function el:AddColorPicker(cpId,cfg2) cfg2=cfg2 or{}; Library.Flags[cpId]=cfg2.Default or Color3.new(1,1,1); Library.Defaults[cpId]=cfg2.Default or Color3.new(1,1,1); Library.Callbacks[cpId]=cfg2.Callback
            local cp={Id=cpId,Cb=cfg2.Callback,_rx=0,_ry=0}; self.CPs[#self.CPs+1]=cp; Library.Options[cpId]=cp; return self end
        function el:AddKeyPicker(kpId,cfg2) cfg2=cfg2 or{}; Library.Keybinds[kpId]={Key=nil,Name=cfg2.Default or"..",Mods={},EN=cfg2.Text or kpId,Mode=cfg2.Mode or"Toggle",Modes=cfg2.Modes or{"Toggle","Hold"},Blacklist=_kbSet(cfg2.Blacklist),Whitelist=_kbSet(cfg2.Whitelist),NoBind=cfg2.NoBind,NoUI=cfg2.NoUI,ParentId=nil}
            if cfg2.Default and cfg2.Default~="None" and cfg2.Default~=".." then for kc,kn in pairs(VK) do if kn==cfg2.Default then Library.Keybinds[kpId].Key=kc; break end end end
            self.KP=mkKP(nil,kpId,cfg2.Text or kpId); Library.Options[kpId]=self.KP; return self end
        self.Els[#self.Els+1]=el; if idx or c.Idx then Library.Options[idx or c.Idx]=el end; return el end
    function g:AddDivider(c)
        c=c or{}
        local el={Ty="Div",Tx=c.Text,MarginTop=c.MarginTop or c.Margin or(c.Text and 5 or 0),MarginBottom=c.MarginBottom or c.Margin or 0}
        elCommon(el,c)
        function el:SetText(t) self.Tx=t end
        self.Els[#self.Els+1]=el; return el end
    function g:AddImage(c) c=c or{}
        local el={Ty="Img",Image=fetchIcon(c.Image),Height=c.Height,Sz=c.Size,Col=c.Color,Tr=c.Transparency or 1,Tooltip=c.Tooltip}; elCommon(el,c)
        function el:SetImage(url) self.Image=fetchIcon(url) end
        function el:SetSize(s) self.Sz=s end
        function el:SetHeight(h) self.Height=h end
        function el:SetColor(col) self.Col=col end
        function el:SetTransparency(t) self.Tr=t end
        self.Els[#self.Els+1]=el; if c.Idx then Library.Options[c.Idx]=el end; return el end

    local function mkDepBox(isGB)
        local db={Ty=isGB and"DepGB" or"DepBox",Els={},Deps={},Visible=true}
        function db:SetupDependencies(deps) self.Deps=deps end
        function db:_checkDeps()
            for _,dep in ipairs(self.Deps) do
                local el,expected=dep[1],dep[2]
                if not el then return false end
                local val=Library.Flags[el.Id]
                if val~=expected then return false end
            end
            return true
        end
        for k,v in pairs(g) do if type(v)=="function" and k~="AddDependencyBox" and k~="AddDependencyGroupbox" then
            db[k]=function(self,...) return v(self,...) end
        end end
        return db
    end
    function g:AddDependencyBox() local db=mkDepBox(false); self.Els[#self.Els+1]=db; return db end
    function g:AddDependencyGroupbox() local db=mkDepBox(true); self.Els[#self.Els+1]=db; return db end
    function g:AddColorPicker(id,c) c=c or{}; Library.Flags[id]=c.Default or Color3.new(1,1,1); Library.Defaults[id]=c.Default or Color3.new(1,1,1); Library.Callbacks[id]=c.Callback; local el={Ty="CP",Id=id,Tx=c.Text or id,Cb=c.Callback,_rx=0,_ry=0}; elCommon(el,c); self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddKeypicker(id,c) c=c or{}; Library.Keybinds[id]={Key=c.DefaultKey,Name=c.DefaultName or"none",EN=c.Text or id}; local el={Ty="KB",Id=id,Tx=c.Text or id}; elCommon(el,c); self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    function g:AddCustom(id,c) c=c or{}; local reg=Library._customEls[c.Type or""]
        if not reg then return end
        local el={Ty=c.Type,Id=id,Tx=c.Text,Custom=true,_reg=reg,_data=c.Data or{}}; elCommon(el,c)
        if c.Default~=nil then Library.Flags[id]=c.Default; Library.Defaults[id]=c.Default end
        if c.Callback then Library.Callbacks[id]=c.Callback end
        function el:SetValue(v) Library.Flags[id]=v; if Library.Callbacks[id] then Library.Callbacks[id](v) end end
        function el:SetData(d) self._data=d end
        function el:GetData() return self._data end
        self.Els[#self.Els+1]=el; Library.Options[id]=el; return el end
    return g
end

function Library:_BuildTabbox(tab,side,name)
    local tb={IsTB=true,Name=name,Side=side,Tab=tab.Name,SubTabs={},ActiveSub=nil,Visible=true}
    if side=="L" then tab.LG[#tab.LG+1]=tb else tab.RG[#tab.RG+1]=tb end
    function tb:SetVisible(v) self.Visible=v end
    function tb:AddTab(subName)
        local dummyTab={LG={},RG={},Name="_tb"}
        local st=Library:_BuildGroup(dummyTab,"L",subName)
        st.IsSub=true; st.ParentTB=tb
        tb.SubTabs[#tb.SubTabs+1]=st
        if not tb.ActiveSub then tb.ActiveSub=subName end
        return st
    end
    return tb
end

function Library:Step()
    if not isrbxactive() then return end
    self.State.Tick=self.State.Tick+1
    local _tick=os.clock(); self._tick=_tick
    local S,I=self.State,self.Input
    local Flags,Toggles,Keybinds,Callbacks=self.Flags,self.Toggles,self.Keybinds,self.Callbacks
    local mx,my=50,50; I.MX=mx; I.MY=my; _imx=mx; _imy=my
    I.Down=input.is_mouse_down(1); I.Click=I.Down and not I.Prev
    local ism2=ismouse2pressed; I.RDown=ism2 and ism2() or false; I.RClick=I.RDown and not I.RPrev

    local _fullScan=S.KBListen or S.FocusInput or S.SearchFocused
    local _typing=_fullScan and true or false
    if _typing then pcall(setrobloxinput,false)
    elseif self._inputBlocked then pcall(setrobloxinput,true) end
    self._inputBlocked=_typing
    if _fullScan then
        if not self._scanFull then self._scanFull={}; for _,kc in ipairs(VKAll) do self._scanFull[kc]=true end end
        for _,kb in pairs(Keybinds) do if kb.Key then self._scanFull[kb.Key]=true end end
        if S.ToggleKey then self._scanFull[S.ToggleKey]=true end
    else
        if self._kbDirty~=false or not self._scanMin then
            self._scanMin={}
            for _,kc in ipairs(VKS) do self._scanMin[kc]=true end
            for _,kb in pairs(Keybinds) do if kb.Key then self._scanMin[kb.Key]=true end end
            if S.ToggleKey then self._scanMin[S.ToggleKey]=true end
            self._kbDirty=false
        end
    end
    local _toScan=_fullScan and self._scanFull or self._scanMin
    for kc in pairs(_toScan) do
        if not I.Keys[kc] then I.Keys[kc]={h=false,c=false} end
        local entry=I.Keys[kc]
        local wasHeld=entry.h
        local held=iskeypressed(kc)
        entry.h=held
        entry.c=held and not wasHeld
    end

    if S.FocusInput then local el=S.FocusInput; local val=self.Flags[el.Id] or""; local inputTick=_tick
        local maxLen=el.ML or 9999
        if I.Keys[0x11] and I.Keys[0x11].h and I.Keys[0x56] and I.Keys[0x56].c then
            pcall(function() local clip=getclipboard(); if clip then clip=gsub(clip,"\n",""); val=sub(val..clip,1,maxLen) end end)
        else
            for kc,ch in pairs(VKC) do if I.Keys[kc] and I.Keys[kc].c and #val<maxLen then
                local c2=I.Keys[0x10] and I.Keys[0x10].h and upper(ch) or ch
                if el.Num then
                    if tonumber(c2) then val=val..c2
                    elseif c2=="." and not find(val,".",1,true) then val=val..c2
                    elseif c2=="-" and val=="" and el.AllowNeg then val=val.."-" end
                else val=val..c2 end
            end end
        end
        if I.Keys[0x08] then
            if I.Keys[0x08].c then S._inpBksp=inputTick+0.4; if #val>0 then val=sub(val,1,#val-1) end
            elseif I.Keys[0x08].h and inputTick>(S._inpBksp or 0) then S._inpBksp=inputTick+0.05; if #val>0 then val=sub(val,1,#val-1) end end
        end
        if I.Keys[0x0D] and I.Keys[0x0D].c then
            S.FocusInput=nil; el:SetValue(val); return
        end
        if I.Keys[0x1B] and I.Keys[0x1B].c then
            self.Flags[el.Id]=el._pre or ""; S.FocusInput=nil; return
        end
        if I.Click and not inB(el._x,el._y,el._w,el._h) then
            if not el.Finished then el:SetValue(val) else self.Flags[el.Id]=el._pre or "" end
            S.FocusInput=nil
            if self.Flags.InputClickThrough==false or (self.ActiveDialog and self.ActiveDialog.Alive) then return end   -- dialogs always eat the click; else fall through so the click hits what you clicked
        end
        if S.FocusInput==el then self.Flags[el.Id]=val end
    end

    if S.SearchFocused then
        local val=S.SearchText; local inputTick=_tick
        if I.Keys[0x11] and I.Keys[0x11].h and I.Keys[0x56] and I.Keys[0x56].c then
            pcall(function() local clip=getclipboard(); if clip then clip=gsub(clip,"\n",""); val=val..clip end end)
        else
            for kc,ch in pairs(VKC) do if I.Keys[kc] and I.Keys[kc].c then val=val..(I.Keys[0x10] and I.Keys[0x10].h and upper(ch) or ch) end end
        end
        if I.Keys[0x08] then
            if I.Keys[0x08].c then S._sbBksp=inputTick+0.4; if #val>0 then val=sub(val,1,#val-1) end
            elseif I.Keys[0x08].h and inputTick>(S._sbBksp or 0) then S._sbBksp=inputTick+0.05; if #val>0 then val=sub(val,1,#val-1) end end
        end
        if I.Keys[0x1B] and I.Keys[0x1B].c then S.SearchFocused=false end
        if I.Keys[0x0D] and I.Keys[0x0D].c then S.SearchFocused=false end
        S.SearchText=val
    end

    if S.KBListen then
        for _,kc in ipairs(VKAll) do
            if I.Keys[kc] and I.Keys[kc].c and kc~=0x10 and kc~=0x11 and kc~=0x12 then
                local kbid=S.KBListen; local kd=Keybinds[kbid]
                local baseKey=VK[kc] or"?"
                local allowed=true
                if kc~=0x1B then
                    if kd.Whitelist and not kd.Whitelist[baseKey] then allowed=false end
                    if kd.Blacklist and kd.Blacklist[baseKey] then allowed=false end
                end
                if not allowed then S.KBListen=nil; break end
                if kc==0x1B then
                    kd.Key=nil; kd.Name="none"; kd.Mods={}
                else
                    kd.Key=kc
                    kd.Mods={}
                    if I.Keys[0x11] and I.Keys[0x11].h then kd.Mods[0x11]=true end
                    if I.Keys[0x10] and I.Keys[0x10].h then kd.Mods[0x10]=true end
                    if I.Keys[0x12] and I.Keys[0x12].h then kd.Mods[0x12]=true end
                    local parts={}
                    if kd.Mods[0x11] then parts[#parts+1]="Ctrl" end
                    if kd.Mods[0x10] then parts[#parts+1]="Shift" end
                    if kd.Mods[0x12] then parts[#parts+1]="Alt" end
                    parts[#parts+1]=baseKey
                    kd.Name=concat(parts,"+")
                end
                if kbid=="MenuKeybind" then S.ToggleKey=kd.Key or 0 end
                if kd._onChanged then pcall(kd._onChanged,kd.Name,kd.Mode) end
                self._kbDirty=true; S.KBListen=nil
                break
            end
        end
    end

    local function modsMatch(mods)
        local keys=I.Keys
        local kc=keys[0x11]; local ks=keys[0x10]; local ka=keys[0x12]
        return((kc and kc.h) or false)==(mods and mods[0x11] or false) and((ks and ks.h) or false)==(mods and mods[0x10] or false) and((ka and ka.h) or false)==(mods and mods[0x12] or false)
    end
    if not S.FocusInput and not S.KBListen then
        local tk=I.Keys[S.ToggleKey]
        if tk and tk.c and modsMatch(Keybinds.MenuKeybind and Keybinds.MenuKeybind.Mods) then
            S.Open=not S.Open; if not S.Open then self:_CloseOverlays() end
        end
        for id,kb in pairs(Keybinds) do
            local mode=kb.Mode or"Toggle"
            local k=kb.Key and I.Keys[kb.Key]
            if k then
                local tid=kb.ParentId or id
                local el=Toggles[tid]
                local prev=Flags[tid]
                local hasPill=el~=nil
                local pillOn=hasPill and el.Value or prev==true
                if mode=="Hold" then
                    local desired=pillOn and k and k.h and modsMatch(kb.Mods)
                    if prev~=desired then
                        Flags[tid]=desired; if Callbacks[tid] then Callbacks[tid](desired) end
                        if desired and kb._onClick then pcall(kb._onClick,true) end
                    end
                elseif k and k.c and modsMatch(kb.Mods) then
                    local newState=not pillOn
                    if el and el.Risky and newState then
                        local now=_tick
                        if kb._riskyConfirm and now-(kb._riskyTick or 0)<1 then
                            kb._riskyConfirm=false
                        else kb._riskyConfirm=true; kb._riskyTick=now; newState=nil end
                    end
                    if newState~=nil then
                        if hasPill then el.Value=newState end
                        Flags[tid]=newState
                        if Callbacks[tid] then Callbacks[tid](newState) end
                        if kb._onClick then pcall(kb._onClick,newState) end
                        if el and el.Risky then kb._riskyConfirm=false end
                    end
                end
            end
        end
    end

    local blk=false
    if self.ActiveDialog and self.ActiveDialog.Alive then blk=true end
    local nextTooltip=nil
    if S.Open and self.Window then
        local W=self.Window
        if W._autoCenter then pcall(function() local vp=workspace.CurrentCamera.ViewportSize; if vp.X>0 and vp.Y>0 then W.Pos=v2(floor((vp.X-W.Size.X)/2),floor((vp.Y-W.Size.Y)/2)); W._autoCenter=false end end) end
        local px,py=W.Pos.X,W.Pos.Y; local sx,sy=W.Size.X,W.Size.Y; local R=W.CR; local ct=_tick
        local BG,BG_DK,BG_LT=COL.BG,COL.BG_DK,COL.BG_LT
        local MAIN,OUTLINE,ACCENT=COL.MAIN,COL.OUTLINE,COL.ACCENT
        local FONT,FONT50,FONT40=COL.FONT,COL.FONT50,COL.FONT40
        local SHADOW,BOT=COL.SHADOW,COL.BOT
        local R2=max(floor(R/2),0); local R2inner=max(R2-1,0)
        local gbSmooth=self.Flags.BorderStyle~="Sharp"; local gR=gbSmooth and R or 0; local gR2=gbSmooth and R2 or 0; local gRp=gbSmooth and R+1 or 0; local gRm=gbSmooth and max(R-1,0) or 0

        if S.ActiveDD then
            local el=S.ActiveDD
            local ddX,ddY,ddW=px+el._rx,py+el._ry,el._rw
            local mv=min(#el.Opts,el.MaxI); local ddH=mv*21
            self:RR("od_ol",ddX,ddY,ddW,ddH,R2,OUTLINE,49)
            self:RR("od_bg",ddX+1,ddY+1,ddW-2,ddH-2,R2inner,BG,50)
            local hasScroll=#el.Opts>mv
            if not el._sc then el._sc=0 end
            if I.Keys[0x26] and I.Keys[0x26].c and inB(ddX,ddY,ddW,ddH) then el._sc=clamp(el._sc-1,0,#el.Opts-mv) end
            if I.Keys[0x28] and I.Keys[0x28].c and inB(ddX,ddY,ddW,ddH) then el._sc=clamp(el._sc+1,0,#el.Opts-mv) end
            for i=1,mv do
                local oi=i+el._sc; local opt=el.Opts[oi]
                if not opt then self:D("od_h"..i,"Square",{Visible=false}); self:D("od_t"..i,"Text",{Visible=false}); self:D("od_i"..i,"Image",{Visible=false}); break end
                local iy=ddY+((i-1)*21)
                local hov=inB(ddX,iy,ddW,21)
                local isDis=false; for _,dv in ipairs(el.DisabledVals or{}) do if dv==opt then isDis=true; break end end
                local sel=false
                if el.Multi then sel=type(self.Flags[el.Id])=="table" and self.Flags[el.Id][opt]
                else sel=(self.Flags[el.Id]==opt) end
                local itemBg=sel and MAIN or(hov and not isDis and COL.HOV20 or BG)
                self:D("od_h"..i,"Square",{Filled=true,Color=itemBg,ZIndex=51,Position=v2(ddX+1,iy),Size=v2(ddW-2-(hasScroll and 4 or 0),21)})
                local itemTxt=el.FmtList and el.FmtList(opt) or tostring(opt)
                local optF=(el.OptFonts and el.OptFonts[opt]) or FNT_ID
                local itemAlpha=isDis and 0.2 or(sel and 1 or 0.5)
                local imgUrl=el.OptImgs and el.OptImgs[opt]
                local imgData=imgUrl and IconCache[imgUrl]
                local hasImg=imgData and imgData~="fetching" and imgData~=false
                if hasImg then
                    self:D("od_i"..i,"Image",{Data=imgData,Size=v2(14,14),Transparency=itemAlpha,Color=FONT,ZIndex=52,Position=v2(ddX+6,iy+3)})
                    self:HideFailIcon("od_ph"..i)
                    self:D("od_t"..i,"Text",{Text=itemTxt,Size=14,Font=optF,Color=FONT,Transparency=itemAlpha,ZIndex=52,Position=v2(ddX+24,iy+2)})
                elseif imgUrl then
                    self:D("od_i"..i,"Image",{Visible=false})
                    self:DrawFailIcon("od_ph"..i,ddX+6,iy+3,14,52)
                    self:D("od_t"..i,"Text",{Text=itemTxt,Size=14,Font=optF,Color=FONT,Transparency=itemAlpha,ZIndex=52,Position=v2(ddX+24,iy+2)})
                else
                    self:D("od_i"..i,"Image",{Visible=false})
                    self:HideFailIcon("od_ph"..i)
                    self:D("od_t"..i,"Text",{Text=itemTxt,Size=14,Font=optF,Color=FONT,Transparency=itemAlpha,ZIndex=52,Position=v2(ddX+7,iy+2)})
                end
            end
            for i=mv+1,20 do self:D("od_h"..i,"Square",{Visible=false}); self:D("od_t"..i,"Text",{Visible=false}); self:D("od_i"..i,"Image",{Visible=false}); self:HideFailIcon("od_ph"..i) end
            if hasScroll then
                local maxSc=#el.Opts-mv; local sbW=8; local sbPad=3; local sbX=ddX+ddW-sbW-sbPad
                local trackH=ddH-sbPad*2; local thumbH=max((mv/#el.Opts)*trackH,20)
                local thumbY=ddY+sbPad+(el._sc/max(1,maxSc))*(trackH-thumbH)
                self:RR("od_strk",sbX,ddY+sbPad,sbW,trackH,3,COL.DD18,51)
                local thumbHov=inB(sbX,thumbY,sbW,thumbH)
                local thumbCol=S._ddScrollDrag and COL.SBT90 or(thumbHov and COL.SBT75 or COL.SBT55)
                self:RR("od_sthm",sbX,thumbY,sbW,thumbH,3,thumbCol,52)
                if I.Click and inB(sbX,ddY+sbPad,sbW,trackH) then
                    S._ddScrollDrag=true; S._ddScrollOff=my-thumbY; blk=true
                end
                if S._ddScrollDrag then
                    if I.Down then
                        local newThY=clamp(my-(S._ddScrollOff or 0),ddY+sbPad,ddY+sbPad+trackH-thumbH)
                        local frac=(trackH-thumbH)>0 and((newThY-(ddY+sbPad))/(trackH-thumbH)) or 0
                        el._sc=clamp(floor(frac*maxSc+0.5),0,maxSc)
                        blk=true
                    else S._ddScrollDrag=false end
                end
            else
                S._ddScrollDrag=false
                self:HideRR("od_strk"); self:HideRR("od_sthm")
            end
            if I.Click and not S._ddScrollDrag then
                local sbArea=hasScroll and inB(ddX+ddW-14,ddY,14,ddH) or false
                if not sbArea then blk=true end
                if inB(ddX,ddY,ddW,ddH) and not sbArea then
                    local idx=floor((my-ddY)/21)+1+el._sc; local opt=el.Opts[idx]
                    if opt then
                        local isDis2=false; for _,dv in ipairs(el.DisabledVals or{}) do if dv==opt then isDis2=true; break end end
                        if not isDis2 then
                            if el.Multi then
                                local t=self.Flags[el.Id]; if type(t)~="table" then t={} end
                                if t[opt] then t[opt]=nil else t[opt]=true end
                                self.Flags[el.Id]=t; if el.Cb then el.Cb(t) end
                            else
                                self.Flags[el.Id]=opt; if el.Cb then el.Cb(opt) end; S.ActiveDD=nil
                            end
                        end
                    end
                else S.ActiveDD=nil end
            end
        end

        if S.ActiveCP and not blk then
            local cp=S.ActiveCP; local cpEl=cp.Ref
            local cpX,cpY=px+cpEl._rx,py+cpEl._ry
            local pd,gap=6,8; local svX=cpX+pd; local infoY
            if self.Flags.ColorWheel then
                local diam,ringW=200,18; local Rout=diam/2; local rt=Rout-ringW-4; local Rmid=Rout-ringW/2
                local bgW,bgH=pd+diam+pd,pd+diam+gap+20+pd
                self:RR("oc_dk",cpX-1,cpY-1,bgW+2,bgH+2,R+1,SHADOW,48)
                self:RR("oc_ol",cpX,cpY,bgW,bgH,R,OUTLINE,49)
                self:RR("oc_bg",cpX+1,cpY+1,bgW-2,bgH-2,max(R-1,0),BG,50)
                local ccx,ccy=cpX+pd+Rout,cpY+pd+Rout; infoY=cpY+pd+diam+gap
                local a0=cp.H*6.2831853
                local vpx,vpy=ccx+cos(a0)*rt,ccy+sin(a0)*rt
                local vwx,vwy=ccx+cos(a0+2.0943951)*rt,ccy+sin(a0+2.0943951)*rt
                local vbx,vby=ccx+cos(a0+4.1887902)*rt,ccy+sin(a0+4.1887902)*rt
                local dx,dy=mx-ccx,my-ccy; local dist=math.sqrt(dx*dx+dy*dy)
                if I.Click then
                    if dist<=Rout and dist>=rt then S.CPDrag="WH"; blk=true
                    else local ba,bb,bc=bary(mx,my,vpx,vpy,vwx,vwy,vbx,vby)
                        if ba>=-0.03 and bb>=-0.03 and bc>=-0.03 then S.CPDrag="WT"; blk=true
                        elseif not inB(cpX,cpY,bgW,bgH) then S.ActiveCP=nil; S.CPDrag=nil
                        else blk=true end
                    end
                end
                if not I.Down then S.CPDrag=nil end
                if S.CPDrag=="WH" then local h=math.atan2(dy,dx)/6.2831853; if h<0 then h=h+1 end; cp.H=h; self.Flags[cp.Id]=hsv(cp.H,cp.S,cp.V); if self.Callbacks[cp.Id] then self.Callbacks[cp.Id](self.Flags[cp.Id]) end
                elseif S.CPDrag=="WT" then
                    local ba,bb,bc=bary(mx,my,vpx,vpy,vwx,vwy,vbx,vby)
                    if ba<0 then ba=0 end; if bb<0 then bb=0 end; if bc<0 then bc=0 end
                    local sm=ba+bb+bc; if sm<=0 then ba,bb=0,1 else ba=ba/sm; bb=bb/sm end
                    local vv=ba+bb; cp.V=vv; cp.S=vv>0 and ba/vv or 0
                    self.Flags[cp.Id]=hsv(cp.H,cp.S,cp.V); if self.Callbacks[cp.Id] then self.Callbacks[cp.Id](self.Flags[cp.Id]) end
                end
                a0=cp.H*6.2831853
                vpx,vpy=ccx+cos(a0)*rt,ccy+sin(a0)*rt
                vwx,vwy=ccx+cos(a0+2.0943951)*rt,ccy+sin(a0+2.0943951)*rt
                vbx,vby=ccx+cos(a0+4.1887902)*rt,ccy+sin(a0+4.1887902)*rt
                local N=30
                if not cp._tri then
                    local pidx={}; local pts={}; local np=0
                    for i=0,N do for j=0,N-i do np=np+1; pidx[i*100+j]=np; pts[np]={i/N,j/N} end end
                    local tris={}
                    for i=0,N-1 do for j=0,N-1-i do local A=pidx[i*100+j]; local B=pidx[(i+1)*100+j]; local C=pidx[i*100+(j+1)]
                        tris[#tris+1]={A,B,C,(pts[A][1]+pts[B][1]+pts[C][1])/3,(pts[A][2]+pts[B][2]+pts[C][2])/3} end end
                    for i=0,N-2 do for j=0,N-2-i do local A=pidx[(i+1)*100+j]; local B=pidx[i*100+(j+1)]; local C=pidx[(i+1)*100+(j+1)]
                        tris[#tris+1]={A,B,C,(pts[A][1]+pts[B][1]+pts[C][1])/3,(pts[A][2]+pts[B][2]+pts[C][2])/3} end end
                    cp._triPts=pts; cp._tri=tris
                    cp._triIds={}; for t=1,#tris do cp._triIds[t]="oc_tr"..t end
                end
                if cp._wColH~=cp.H or not cp._triCol then
                    cp._wColH=cp.H; cp._triCol={}; local pure=hsv(cp.H,1,1); local pr,pg,pb=pure.R,pure.G,pure.B
                    for t,tr in ipairs(cp._tri) do local a,b=tr[4],tr[5]; cp._triCol[t]=rgb((a*pr+b)*255,(a*pg+b)*255,(a*pb+b)*255) end
                end
                if cp._lpH~=cp.H or cp._lpX~=cpX or cp._lpY~=cpY or not cp._latPos then
                    cp._lpH=cp.H; cp._lpX=cpX; cp._lpY=cpY; cp._latPos={}
                    for k,p in ipairs(cp._triPts) do local a,b=p[1],p[2]; local c=1-a-b; cp._latPos[k]=v2(a*vpx+b*vwx+c*vbx,a*vpy+b*vwy+c*vby) end
                end
                local DR=self.Drawings; local tk=S.Tick
                local rk=fetchIcon("wheel_ring"); local rd=rk and IconCache[rk]
                if rd and rd~="fetching" and rd~=false then self:D("oc_ring","Image",{Data=rd,Size=v2(diam,diam),Color=FONT,Transparency=1,ZIndex=51,Position=v2(ccx-Rout,ccy-Rout)})
                else self:D("oc_ring","Image",{Visible=false}) end
                if cp._tdH~=cp.H or cp._tdX~=cpX or cp._tdY~=cpY or not cp._kaTri then
                    cp._tdH=cp.H; cp._tdX=cpX; cp._tdY=cpY; local tri,col,pos,tid=cp._tri,cp._triCol,cp._latPos,cp._triIds
                    for t=1,#tri do local tr=tri[t]; self:D(tid[t],"Triangle",{Filled=true,Color=col[t],ZIndex=52,PointA=pos[tr[1]],PointB=pos[tr[2]],PointC=pos[tr[3]]}) end
                    if not cp._kaTri then cp._kaTri={}; for t=1,#tri do cp._kaTri[t]=DR[tid[t]] end end
                else for t=1,#cp._kaTri do cp._kaTri[t].Tk=tk end end
                local off=2
                local e1x,e1y=vpx+(vpx-ccx)/rt*off,vpy+(vpy-ccy)/rt*off
                local e2x,e2y=vwx+(vwx-ccx)/rt*off,vwy+(vwy-ccy)/rt*off
                local e3x,e3y=vbx+(vbx-ccx)/rt*off,vby+(vby-ccy)/rt*off
                local function _ext(ax,ay,bx,by) local dx,dy=bx-ax,by-ay; local d=math.sqrt(dx*dx+dy*dy); if d<0.01 then d=1 end; dx,dy=dx/d*1.5,dy/d*1.5; return ax-dx,ay-dy,bx+dx,by+dy end
                local a1x,a1y,b1x,b1y=_ext(e1x,e1y,e2x,e2y)
                local a2x,a2y,b2x,b2y=_ext(e2x,e2y,e3x,e3y)
                local a3x,a3y,b3x,b3y=_ext(e3x,e3y,e1x,e1y)
                self:D("oc_te1","Line",{Color=OUTLINE,Thickness=2.5,ZIndex=53,From=v2(a1x,a1y),To=v2(b1x,b1y)})
                self:D("oc_te2","Line",{Color=OUTLINE,Thickness=2.5,ZIndex=53,From=v2(a2x,a2y),To=v2(b2x,b2y)})
                self:D("oc_te3","Line",{Color=OUTLINE,Thickness=2.5,ZIndex=53,From=v2(a3x,a3y),To=v2(b3x,b3y)})
                local ha=cp.V*cp.S; local hb=cp.V*(1-cp.S); local hc=1-cp.V
                local csX,csY=ha*vpx+hb*vwx+hc*vbx,ha*vpy+hb*vwy+hc*vby
                self:D("oc_curo","Circle",{Filled=false,Color=SHADOW,Thickness=2,Radius=5,NumSides=16,ZIndex=54,Position=v2(csX,csY)})
                self:D("oc_cur","Circle",{Filled=false,Color=FONT,Thickness=1,Radius=4,NumSides=16,ZIndex=55,Position=v2(csX,csY)})
                local hmx,hmy=ccx+cos(a0)*Rmid,ccy+sin(a0)*Rmid
                self:D("oc_hmo","Circle",{Filled=false,Color=SHADOW,Thickness=3,Radius=ringW/2,NumSides=18,ZIndex=53,Position=v2(hmx,hmy)})
                self:D("oc_hm","Circle",{Filled=false,Color=FONT,Thickness=2,Radius=ringW/2-1,NumSides=18,ZIndex=54,Position=v2(hmx,hmy)})
                cp._bgW=bgW; cp._bgH=bgH
            else
                local svSz,barW=200,16
                local bgW,bgH=pd+svSz+gap+barW+pd,pd+svSz+gap+20+pd
                local svY=cpY+pd; local huX=svX+svSz+gap
                self:RR("oc_dk",cpX-1,cpY-1,bgW+2,bgH+2,R+1,SHADOW,48)
                self:RR("oc_ol",cpX,cpY,bgW,bgH,R,OUTLINE,49)
                self:RR("oc_bg",cpX+1,cpY+1,bgW-2,bgH-2,max(R-1,0),BG,50)
                if I.Click then
                    if inB(svX,svY,svSz,svSz) then S.CPDrag="S"; blk=true
                    elseif inB(huX,svY,barW,svSz) then S.CPDrag="H"; blk=true
                    elseif not inB(cpX,cpY,bgW,bgH) then S.ActiveCP=nil; S.CPDrag=nil
                    else blk=true end
                end
                if not I.Down then S.CPDrag=nil end
                if S.CPDrag=="S" then cp.S=clamp((mx-svX)/svSz,0,1); cp.V=1-clamp((my-svY)/svSz,0,1); self.Flags[cp.Id]=Color3.fromHSV(cp.H,cp.S,cp.V); if self.Callbacks[cp.Id] then self.Callbacks[cp.Id](self.Flags[cp.Id]) end
                elseif S.CPDrag=="H" then cp.H=1-clamp((my-svY)/svSz,0,1); self.Flags[cp.Id]=Color3.fromHSV(cp.H,cp.S,cp.V); if self.Callbacks[cp.Id] then self.Callbacks[cp.Id](self.Flags[cp.Id]) end end
                if cp._svH~=cp.H or not cp._svC then
                    cp._svH=cp.H; cp._svC={}; local k=1
                    for x=1,50 do for y=1,50 do cp._svC[k]=hsv(cp.H,x*0.02,1-y*0.02); k=k+1 end end
                end
                local si=1
                for x=1,50 do for y=1,50 do self:D("oc_sv"..si,"Square",{Filled=true,Color=cp._svC[si],ZIndex=51,Position=v2(svX+(x-1)*4,svY+(y-1)*4),Size=v2(4,4)}); si=si+1 end end
                if not cp._huC then cp._huC={}; for i=1,svSz do cp._huC[i]=hsv(1-i/svSz,1,1) end end
                for i=1,svSz do self:D("oc_hu"..i,"Square",{Filled=true,Color=cp._huC[i],ZIndex=51,Position=v2(huX,svY+(i-1)),Size=v2(barW,1)}) end
                local csX,csY=svX+cp.S*svSz,svY+(1-cp.V)*svSz
                self:D("oc_curo","Circle",{Filled=false,Color=SHADOW,Thickness=2,Radius=4,NumSides=16,ZIndex=53,Position=v2(csX,csY)})
                self:D("oc_cur","Circle",{Filled=false,Color=FONT,Thickness=1,Radius=3,NumSides=16,ZIndex=54,Position=v2(csX,csY)})
                local hcY=svY+(1-cp.H)*svSz
                self:D("oc_hco","Square",{Filled=true,Color=SHADOW,ZIndex=52,Position=v2(huX-1,hcY-2),Size=v2(barW+2,4)})
                self:D("oc_hcur","Square",{Filled=true,Color=FONT,ZIndex=53,Position=v2(huX,hcY-1),Size=v2(barW,2)})
                infoY=svY+svSz+gap; cp._bgW=bgW; cp._bgH=bgH
            end
            local cur=Color3.fromHSV(cp.H,cp.S,cp.V)
            local cr,cg,cb=floor(cur.R*255+0.5),floor(cur.G*255+0.5),floor(cur.B*255+0.5)
            local hex=format("#%02X%02X%02X",cr,cg,cb)
            local rgbStr=format("%d, %d, %d",cr,cg,cb)
            local rowW=(cp._bgW or 212)-12; local gap2=8; local bw=floor((rowW-gap2)/2); local rX=svX+bw+gap2
            local copied=cp._copyTick and(ct-cp._copyTick<0.7)
            local lHov=inB(svX,infoY,bw,20); local rHov=inB(rX,infoY,bw,20)
            local lCop=copied and cp._copyWhich==1; local rCop=copied and cp._copyWhich==2
            self:RR("oc_hbg",svX,infoY,bw,20,R2,MAIN,51)
            self:D("oc_hbo","Square",{Filled=false,Color=lCop and ACCENT or(lHov and FONT50 or OUTLINE),Thickness=1,ZIndex=51,Position=v2(svX,infoY),Size=v2(bw,20)})
            self:D("oc_hx","Text",{Text=lCop and"Copied!"or hex,Size=14,Font=FNT_ID,Color=FONT,ZIndex=52,Position=v2(svX+8,infoY+3)})
            if lHov and I.Click then pcall(setclipboard,hex); cp._copyTick=ct; cp._copyWhich=1; blk=true end
            self:RR("oc_rb",rX,infoY,bw,20,R2,MAIN,51)
            self:D("oc_rbo","Square",{Filled=false,Color=rCop and ACCENT or(rHov and FONT50 or OUTLINE),Thickness=1,ZIndex=51,Position=v2(rX,infoY),Size=v2(bw,20)})
            self:D("oc_rx","Text",{Text=rCop and"Copied!"or rgbStr,Size=14,Font=FNT_ID,Color=FONT,ZIndex=52,Position=v2(rX+8,infoY+3)})
            if rHov and I.Click then pcall(setclipboard,rgbStr); cp._copyTick=ct; cp._copyWhich=2; blk=true end
            if S.ActiveCP and I.Down and inB(cpX,cpY,cp._bgW or 0,cp._bgH or 0) then blk=true end
        end

        local rzX,rzY=px+sx-RESIZE_ZONE,py+sy-RESIZE_ZONE; local inRz=inB(rzX,rzY,RESIZE_ZONE,RESIZE_ZONE)
        if I.Click and inRz and not S.Drag and not blk then S.Resize=true; S.ResizeAnchor=v2(mx,my); S.ResizeBase=v2(sx,sy); self:_CloseOverlays() end
        if not I.Down then S.Resize=false end
        if S.Resize then local mxW,mxH=1600,1000; pcall(function() local vp=workspace.CurrentCamera.ViewportSize; mxW=vp.X-64; mxH=vp.Y-64 end)
            W.Size=v2(clamp(S.ResizeBase.X+(mx-S.ResizeAnchor.X),MIN_W,mxW),clamp(S.ResizeBase.Y+(my-S.ResizeAnchor.Y),MIN_H,mxH)); W.SideW=clamp(ceil(W.Size.X*0.3),MIN_SIDE,W.Size.X-MIN_CONTENT); sx=W.Size.X; sy=W.Size.Y end

        if not S.Resize and not blk then
            local _sbX,_sbY,_sbW,_sbH=px+W.SideW+8,py+10,sx-W.SideW-56,28
            local inSearch=inB(_sbX,_sbY,_sbW,_sbH)
            if I.Click and not S.Drag and inB(px,py,sx,W.HdrH) and not inRz and not inSearch then S.Drag=true; S.DragOff=v2(mx-px,my-py) end
            if not I.Down then S.Drag=false end
        end
        if S.Drag then W.Pos=v2(mx-S.DragOff.X,my-S.DragOff.Y); px=W.Pos.X; py=W.Pos.Y; W._autoCenter=false end

        self:RR("w_dk",px-1,py-1,sx+2,sy+2,gRp,SHADOW,18); self:RR("w_ol",px,py,sx,sy,gR,OUTLINE,19); self:RR("w_bg",px+1,py+1,sx-2,sy-2,gRm,BG_DK,20)
        if W.BgImage then
            self:D("w_bgimg","Image",{Data=W.BgImage,Size=v2(sx-2,sy-2),Transparency=W.BgImageTr,ZIndex=20,Position=v2(px+1,py+1)})
        else self:D("w_bgimg","Image",{Visible=false}) end
        self:D("w_side","Square",{Filled=true,Color=BG,ZIndex=21,Position=v2(px+1,py+W.HdrH+1),Size=v2(W.SideW-1,sy-W.HdrH-W.BotH-2)})
        self:D("w_cont","Square",{Filled=true,Color=BG_LT,ZIndex=21,Position=v2(px+W.SideW+1,py+W.HdrH+1),Size=v2(sx-W.SideW-2,sy-W.HdrH-W.BotH-2)})
        self:D("w_mask_top","Square",{Filled=true,Color=BG,ZIndex=35,Position=v2(px+W.SideW+1,py+1),Size=v2(sx-W.SideW-2,W.HdrH-1)})
        self:D("w_mask_bot","Square",{Filled=true,Color=BOT,ZIndex=35,Position=v2(px+1,py+sy-W.BotH),Size=v2(sx-2,W.BotH-1)})
        self:D("w_mask_ctop","Square",{Filled=true,Color=BG_LT,ZIndex=35,Position=v2(px+W.SideW+1,py+W.HdrH+1),Size=v2(sx-W.SideW-2,COL_PAD)})
        self:D("w_mask_cbot","Square",{Filled=true,Color=BG_LT,ZIndex=35,Position=v2(px+W.SideW+1,py+sy-W.BotH-COL_PAD-2),Size=v2(sx-W.SideW-2,COL_PAD+1)})
        self:D("w_ssep","Square",{Filled=true,Color=OUTLINE,ZIndex=36,Position=v2(px+W.SideW,py+1),Size=v2(1,sy-W.BotH-2)})
        self:D("w_hsep","Square",{Filled=true,Color=OUTLINE,ZIndex=36,Position=v2(px+1,py+W.HdrH),Size=v2(sx-2,1)})
        self:D("w_bsep","Square",{Filled=true,Color=OUTLINE,ZIndex=36,Position=v2(px+1,py+sy-W.BotH-1),Size=v2(sx-2,1)})
        self:D("w_bot","Square",{Filled=true,Color=BOT,ZIndex=21,Position=v2(px+1,py+sy-W.BotH),Size=v2(sx-2,W.BotH-1)})
        local titleCenterX=px+W.SideW/2
        local hasIcon=W._titleIcon
        local tiSz=hasIcon and 26 or 0
        local titlePad=12
        local titleAvail=W.SideW-titlePad*2-(hasIcon and(tiSz+4) or 0)
        local titleDisp=truncFit(W.Title,20,titleAvail)
        local titleW=tw(titleDisp,20)
        local groupW=titleW+(hasIcon and(tiSz+4) or 0)
        local groupStart=titleCenterX-groupW/2
        if hasIcon then self:D("w_icon","Image",{Data=W._titleIcon,ZIndex=37,Size=v2(tiSz,tiSz),Position=v2(groupStart,py+(W.HdrH-tiSz)/2)}) end
        self:D("w_tit","Text",{Text=titleDisp,Size=20,Font=FNT_ID,Color=FONT,ZIndex=37,Position=v2(groupStart+(hasIcon and(tiSz+4) or 0),py+15)})
        local botY=py+sy-W.BotH
        if W.Sub~="" then self:D("w_sub","Text",{Text=W.Sub,Size=14,Font=FNT_ID,Color=FONT50,Center=true,ZIndex=37,Position=v2(px+sx/2,botY+8)}) end
        if my>=botY-1 and my<=py+sy and mx>=px and mx<=px+sx then blk=true end
        if not W._rzIcon then W._rzIcon=fetchIcon("move-diagonal-2") end
        local rzd=W._rzIcon and IconCache[W._rzIcon]
        if rzd and rzd~="fetching" and rzd~=false then self:D("w_rzi","Image",{Data=rzd,ZIndex=37,Size=v2(16,16),Transparency=0.4,Position=v2(px+sx-20,py+sy-18)})
        else self:D("w_rzi","Image",{Visible=false}) end

        if not W._mvIcon then W._mvIcon=fetchIcon("move") end
        local mvd=W._mvIcon and IconCache[W._mvIcon]
        if mvd and mvd~="fetching" and mvd~=false then self:D("w_mvi","Image",{Data=mvd,ZIndex=37,Size=v2(28,28),Transparency=0.1,Position=v2(px+sx-40,py+10)})
        else self:D("w_mvi","Image",{Visible=false}) end

        local sbX=px+W.SideW+8; local sbY=py+10; local sbW=sx-W.SideW-56; local sbH=28
        local sbHov=not blk and inB(sbX,sbY,sbW,sbH)
        local sbR=8
        self:RR("sb_ol",sbX,sbY,sbW,sbH,sbR,S.SearchFocused and ACCENT or OUTLINE,36)
        self:RR("sb_bg",sbX+1,sbY+1,sbW-2,sbH-2,sbR-1,MAIN,37)
        self:D("sb_ic","Circle",{Filled=false,Color=FONT50,Thickness=1.5,Radius=5,NumSides=12,ZIndex=38,Position=v2(sbX+16,sbY+12)})
        self:D("sb_il","Line",{Color=FONT50,Thickness=1.5,ZIndex=38,From=v2(sbX+20,sbY+16),To=v2(sbX+24,sbY+20)})
        local sTxt=S.SearchText or""
        local sMaxW=sbW-38
        local sDisp,sCol
        if sTxt=="" and not S.SearchFocused then sDisp=truncFit("Search...",14,sMaxW); sCol=FONT50
        elseif S.SearchFocused then sDisp=tailFit(sTxt,14,sMaxW-8)..(floor(ct*2)%2==0 and"|"or""); sCol=FONT
        else sDisp=truncFit(sTxt,14,sMaxW); sCol=FONT end
        self:D("sb_tx","Text",{Text=sDisp,Size=14,Font=FNT_ID,Color=sCol,ZIndex=38,Position=v2(sbX+32,sbY+6)})
        if sbHov and I.Click and not blk and not S.SearchFocused then S.SearchFocused=true; blk=true end
        if S.SearchFocused and I.Click and not sbHov then S.SearchFocused=false end

        local _searchTokens={}
        local _searchTypes={}
        local _TY_MAP=self._TY_MAP
        if S.SearchText and S.SearchText~="" then
            for w in gmatch(lower(S.SearchText),"%S+") do
                local tp=match(w,"^type:(.+)")
                if tp and _TY_MAP[tp] then _searchTypes[#_searchTypes+1]=_TY_MAP[tp]
                elseif tp then _searchTypes[#_searchTypes+1]=tp
                else _searchTokens[#_searchTokens+1]=w end
            end
        end
        local _hasSearch=#_searchTokens>0 or #_searchTypes>0
        local function _matchTxt(txt)
            if #_searchTokens==0 then return true end
            txt=lower(txt or"")
            for _,tok in ipairs(_searchTokens) do
                if not find(txt,tok,1,true) then return false end
            end
            return true
        end
        local function _matchType(ty)
            if #_searchTypes==0 then return true end
            for _,t in ipairs(_searchTypes) do if t==ty then return true end end
            return false
        end
        local function _countTabMatches(t)
            if not _hasSearch or t.Visible==false then return 0 end
            local n=0
            local function scan(els) for _,e in ipairs(els) do
                if e.Visible==false then
                elseif e.Ty=="DepBox" or e.Ty=="DepGB" then scan(e.Els)
                elseif _matchType(e.Ty) and _matchTxt(e.Tx or"") then n=n+1 end
            end end
            for _,g in ipairs(t.LG) do
                if g.Visible~=false then
                    if g.IsTB then for _,st in ipairs(g.SubTabs) do scan(st.Els) end
                    else scan(g.Els) end
                end
            end
            for _,g in ipairs(t.RG) do
                if g.Visible~=false then
                    if g.IsTB then for _,st in ipairs(g.SubTabs) do scan(st.Els) end
                    else scan(g.Els) end
                end
            end
            return n
        end
        local aTab=nil
        local T_ICON=22
        local tabTextX=42
        local tabTextMaxW=W.SideW-tabTextX-12
        local sideTop=py+W.HdrH+1; local sideH=sy-W.HdrH-W.BotH-2

        local ty=sideTop
        for ti,tab in ipairs(self.Tabs) do
            if tab.Visible==false then
                self:D("tb"..ti,"Square",{Visible=false})
                self:D("ti"..ti,"Image",{Visible=false}); self:D("tis"..ti,"Circle",{Visible=false}); self:HideFailIcon("tif"..ti)
                for li=1,5 do self:D("tt"..ti.."_"..li,"Text",{Visible=false}) end
            else
            local txtW=tw(tab.Name,16)
            local lines={tab.Name}
            if txtW>tabTextMaxW then
                lines={}
                local words={}; for w in gmatch(tab.Name,"%S+") do words[#words+1]=w end
                local curLine=""
                for _,w in ipairs(words) do
                    local testLine=curLine==""and w or(curLine.." "..w)
                    if tw(testLine,16)>tabTextMaxW and curLine~="" then lines[#lines+1]=curLine; curLine=w
                    else curLine=testLine end
                end
                if curLine~="" then lines[#lines+1]=curLine end
            end
            local tabH=max(40,18+#lines*18)
            local fullH=tabH
            local sideBot=sideTop+sideH
            if ty+tabH>sideBot then tabH=max(0,sideBot-ty) end
            local isA=(self.ActiveTab==tab.Name)
            if isA then aTab=tab end
            if tabH<=0 then
                self:D("tb"..ti,"Square",{Visible=false}); self:D("ti"..ti,"Image",{Visible=false}); self:D("tis"..ti,"Circle",{Visible=false}); self:HideFailIcon("tif"..ti)
                for li=1,5 do self:D("tt"..ti.."_"..li,"Text",{Visible=false}) end
                ty=ty+fullH
            else

            local hov=not blk and inB(px+1,ty,W.SideW-2,tabH)
            if hov and I.Click and not isA then self.ActiveTab=tab.Name; self:_CloseOverlays() end

            local bgCol=BG; if isA then bgCol=MAIN elseif hov then bgCol=COL.HOV20 end
            self:D("tb"..ti,"Square",{Filled=true,Color=bgCol,ZIndex=22,Position=v2(px+1,ty),Size=v2(W.SideW-1,tabH)})

            if tab._iconURL then
                local idata=IconCache[tab._iconURL]
                local icoX,icoY=px+12,ty+(fullH-T_ICON)/2
                if idata and idata~="fetching" and idata~=false then
                    self:D("ti"..ti,"Image",{Data=idata,ZIndex=23,Size=v2(T_ICON,T_ICON),Position=v2(icoX,icoY),Transparency=isA and 1 or 0.4})
                    self:D("tis"..ti,"Circle",{Visible=false})
                    self:HideFailIcon("tif"..ti)
                elseif idata=="fetching" then
                    self:D("ti"..ti,"Image",{Visible=false})
                    self:HideFailIcon("tif"..ti)
                    local ang=(ct*4)%(math.pi*2); local cx,cy=icoX+T_ICON/2,icoY+T_ICON/2
                    self:D("tis"..ti,"Circle",{Filled=false,Color=ACCENT,Thickness=2,Radius=T_ICON/2-2,NumSides=8,ZIndex=23,Transparency=0.5,Position=v2(cx+cos(ang)*2,cy+sin(ang)*2)})
                else
                    self:D("ti"..ti,"Image",{Visible=false})
                    self:D("tis"..ti,"Circle",{Visible=false})
                    self:DrawFailIcon("tif"..ti,icoX,icoY,T_ICON,23)
                end
            end

            local txtCol=FONT50; if isA then txtCol=FONT elseif hov then txtCol=FONT40 end
            local textStartY=ty+(fullH-#lines*18)/2+1
            for li,line in ipairs(lines) do
                self:D("tt"..ti.."_"..li,"Text",{Text=line,Size=16,Font=FNT_ID,Color=txtCol,ZIndex=23,Position=v2(px+tabTextX,textStartY+(li-1)*18)})
            end
            for li=#lines+1,5 do self:D("tt"..ti.."_"..li,"Text",{Visible=false}) end

            if _hasSearch then
                if tab._mcTxt~=S.SearchText then tab._mcTxt=S.SearchText; tab._mc=_countTabMatches(tab) end
                local mc=tab._mc
                if mc>0 then
                    local badgeTx=tostring(mc); local badgeH=16
                    local badgeW=max(badgeH,tw(badgeTx,12)+10)
                    local badgeX=px+W.SideW-badgeW-10; local badgeY=ty+(tabH-badgeH)/2
                    self:Pill("tbmo"..ti,badgeX,badgeY,badgeW,badgeH,ACCENT,24)
                    self:Pill("tbm"..ti,badgeX+1,badgeY+1,badgeW-2,badgeH-2,MAIN,25)
                    self:D("tbmt"..ti,"Text",{Text=badgeTx,Size=12,Font=FNT_ID,Color=ACCENT,Center=true,ZIndex=26,Position=v2(badgeX+badgeW/2,badgeY+8)})
                else
                    self:D("tbmo"..ti.."_l","Circle",{Visible=false}); self:D("tbmo"..ti.."_r","Circle",{Visible=false}); self:D("tbmo"..ti.."_c","Square",{Visible=false})
                    self:D("tbm"..ti.."_l","Circle",{Visible=false}); self:D("tbm"..ti.."_r","Circle",{Visible=false}); self:D("tbm"..ti.."_c","Square",{Visible=false})
                    self:D("tbmt"..ti,"Text",{Visible=false})
                end
            else
                self:D("tbmo"..ti.."_l","Circle",{Visible=false}); self:D("tbmo"..ti.."_r","Circle",{Visible=false}); self:D("tbmo"..ti.."_c","Square",{Visible=false})
                self:D("tbm"..ti.."_l","Circle",{Visible=false}); self:D("tbm"..ti.."_r","Circle",{Visible=false}); self:D("tbm"..ti.."_c","Square",{Visible=false})
                self:D("tbmt"..ti,"Text",{Visible=false})
            end

            ty=ty+fullH
            end
            end
        end

        if aTab then
            local cX=px+W.SideW+1+COL_PAD; local cY=py+W.HdrH+1+COL_PAD; local cW=sx-W.SideW-2-COL_PAD*2; local colW=floor((cW-COL_GAP)/2)
            local cAvailH=max(1,sy-W.HdrH-W.BotH-2-COL_PAD*2)
            aTab._scroll=aTab._scroll or 0

            local function elMatches(el)
                if not _hasSearch then return true end
                if el.Ty=="DepBox" or el.Ty=="DepGB" then
                    for _,sub in ipairs(el.Els) do if elMatches(sub) then return true end end
                    return false
                end
                return _matchType(el.Ty) and _matchTxt(el.Tx or"")
            end

            local function gbMatches(g)
                if #_searchTokens==0 and #_searchTypes==0 then return true end
                if g.IsTB then
                    for _,st in ipairs(g.SubTabs) do for _,e in ipairs(st.Els) do if elMatches(e) then return true end end end
                else
                    for _,e in ipairs(g.Els) do if elMatches(e) then return true end end
                end
                return false
            end
            local function searchGbH(g)
                if not _hasSearch then return gbH(g) end
                local h=GB_PAD*2; local vis=0
                local els=g.Els
                for _,el in ipairs(els) do
                    if el.Visible~=false and elMatches(el) then
                        local eh=elH(el); if eh>0 then if vis>0 then h=h+GB_SPACE end; h=h+eh; vis=vis+1 end
                    end
                end
                if vis==0 then h=h+20 end
                return GB_HDR+1+h
            end

            local function checkTooltip(el,hovering)
                if hovering and el.Tooltip and not el.Disabled then nextTooltip=el.Tooltip
                elseif hovering and el.DisabledTooltip and el.Disabled then nextTooltip=el.DisabledTooltip end
            end

            local renderEls
            renderEls=function(els,eX,eY,eW,gid)
                local visIdx=0
                for ei,el in ipairs(els) do
                    if el.Visible==false then
                    elseif _hasSearch and not elMatches(el) then
                    elseif el.Ty=="DepBox" or el.Ty=="DepGB" then
                        if el:_checkDeps() then
                            if visIdx>0 then eY=eY+GB_SPACE end
                            local depH=elH(el)
                            local depCullBot=cY+cAvailH+COL_PAD+W.BotH*0.875
                            local depPrev=S._noDraw
                            if not depPrev and(eY>depCullBot or eY+depH<=cY) then S._noDraw=true end
                            if el.Ty=="DepGB" then
                                if not S._noDraw then
                                    local visTop=max(eY,cY); local visBot=min(eY+depH,depCullBot); local visH=visBot-visTop
                                    if visH>0 then self:RR("dg_"..gid..ei,eX-GB_PAD+3,visTop,eW+GB_PAD*2-6,visH,R2,COL.DEP18,25)
                                    else self:HideRR("dg_"..gid..ei) end
                                else self:HideRR("dg_"..gid..ei) end
                                eY=renderEls(el.Els,eX,eY+GB_PAD,eW,gid.."d"..ei)+GB_PAD
                            else
                                eY=renderEls(el.Els,eX,eY,eW,gid.."d"..ei)
                            end
                            S._noDraw=depPrev
                            visIdx=visIdx+1
                        end
                    else
                        if visIdx>0 then eY=eY+GB_SPACE end
                        visIdx=visIdx+1
                    local eid=el.Id or(gid..ei)
                    local prevNoDraw=S._noDraw
                    local elemH=elH(el)
                    local cullBot=cY+cAvailH+COL_PAD+W.BotH*0.875
                    local splitCull=el.Ty=="Inp" or el.Ty=="DD" or el.Ty=="Sld" or el.Ty=="RSld" or el.Ty=="MC" or el.Custom
                    if not prevNoDraw then
                        if splitCull then
                            if eY>cullBot or eY+elemH<=cY then S._noDraw=true end
                        else
                            if eY+elemH>cullBot or eY+elemH<=cY then S._noDraw=true end
                        end
                    end

                        if el.Ty=="Lbl" then
                            local laX=eX+eW
                            if el.CPs then for ci=#el.CPs,1,-1 do local cp=el.CPs[ci]
                                laX=laX-18; cp._rx=laX-px; cp._ry=eY-py
                                local cpHov=not blk and inB(laX,eY,18,18)
                                self:RR("cpo_"..cp.Id,laX,eY,18,18,R2,OUTLINE,25)
                                self:RR("cp_"..cp.Id,laX+1,eY+1,16,16,R2inner,self.Flags[cp.Id],26)
                                if cpHov and I.Click and not blk then local h,s,v=r2h(self.Flags[cp.Id]); if S.ActiveCP and S.ActiveCP.Id==cp.Id then S.ActiveCP=nil else S.ActiveCP={Id=cp.Id,Ref=cp,H=h,S=s,V=v} end; blk=true end
                                laX=laX-6
                            end end
                            if el.KP then local kd=Keybinds[el.KP.Id]; local kn=((kd and kd.Name) or"").._kbModeSfx(kd); local kW=max(tw(kn,14)+9,18)
                                laX=laX-kW; local listening=S.KBListen==el.KP.Id
                                self:RR("kpo_"..el.KP.Id,laX,eY,kW,18,R2,OUTLINE,25)
                                self:RR("kp_"..el.KP.Id,laX+1,eY+1,kW-2,16,R2inner,MAIN,26)
                                self:D("kpt_"..el.KP.Id,"Text",{Text=listening and".." or kn,Size=14,Font=FNT_ID,Color=listening and ACCENT or FONT50,Center=true,ZIndex=27,Position=v2(laX+kW/2,eY+9)})
                                local kpHov=not blk and inB(laX,eY,kW,18)
                                if kpHov and I.Click and not(kd and kd.NoBind) then S.KBListen=el.KP.Id; blk=true end
                                if kpHov and I.RClick then _kbRClick(kd); blk=true end
                            end
                            local _lblW=laX-2-eX
                            el._lastW=_lblW
                            if el.Tooltip then local lbH=el.Wrap and max(1,#(wrapLinesCached(el,el.Tx or"",el.Sz or 14,_lblW) or{}))*18 or 18; checkTooltip(el,not blk and inB(eX,eY,_lblW,lbH)) end
                            if el.Wrap then
                                local lns=wrapLinesCached(el,el.Tx or"",el.Sz or 14,_lblW)
                                for li=1,#lns do self:D("e_lt"..eid.."_"..li,"Text",{Text=lns[li],Size=el.Sz or 14,Font=FNT_ID,Color=el.Col or FONT,ZIndex=26,Position=v2(eX,eY+1+(li-1)*18)}) end
                                for li=#lns+1,15 do self:D("e_lt"..eid.."_"..li,"Text",{Visible=false}) end
                                self:D("e_lt"..eid,"Text",{Visible=false})
                                eY=eY+#lns*18
                            else
                                self:D("e_lt"..eid,"Text",{Text=truncFit(el.Tx,el.Sz or 14,_lblW),Size=el.Sz or 14,Font=FNT_ID,Color=el.Col or FONT,ZIndex=26,Position=v2(eX,eY+1)})
                                for li=1,15 do self:D("e_lt"..eid.."_"..li,"Text",{Visible=false}) end
                                eY=eY+18
                            end

                        elseif el.Ty=="Div" then
                            eY=eY+(el.MarginTop or 0)
                            if el.Tx and el.Tx~="" then
                                local txt=el.Tx; local txW=tw(txt,13); local sidePad=6
                                local cX=eX+eW/2; local lineY=eY+7
                                local leftW=max(0,(eW-txW)/2-sidePad)
                                local rightX=eX+eW-leftW
                                self:D("e_dlA"..eid,"Square",{Filled=true,Color=OUTLINE,ZIndex=26,Position=v2(eX,lineY),Size=v2(leftW,1)})
                                self:D("e_dlB"..eid,"Square",{Filled=true,Color=OUTLINE,ZIndex=26,Position=v2(rightX,lineY),Size=v2(leftW,1)})
                                self:D("e_dtx"..eid,"Text",{Text=txt,Size=13,Font=FNT_ID,Color=FONT50,Center=true,ZIndex=27,Position=v2(cX,eY+7)})
                                self:D("e_db"..eid,"Square",{Visible=false})
                                self:D("e_do"..eid,"Square",{Visible=false})
                                eY=eY+16
                            else
                                self:D("e_db"..eid,"Square",{Filled=true,Color=MAIN,ZIndex=26,Position=v2(eX,eY+2),Size=v2(eW,2)})
                                self:D("e_do"..eid,"Square",{Filled=false,Color=OUTLINE,Thickness=1,ZIndex=26,Position=v2(eX,eY+2),Size=v2(eW,2)})
                                self:D("e_dlA"..eid,"Square",{Visible=false})
                                self:D("e_dlB"..eid,"Square",{Visible=false})
                                self:D("e_dtx"..eid,"Text",{Visible=false})
                                eY=eY+6
                            end
                            eY=eY+(el.MarginBottom or 0)

                        elseif el.Ty=="Btn" then
                            local numBtns=1+#el.Subs; local btnGap=9
                            local btnW=numBtns>1 and floor((eW-btnGap*(numBtns-1))/numBtns) or eW

                            for bi=0,numBtns-1 do
                                local btn=bi==0 and el or el.Subs[bi]
                                local bx=eX+bi*(btnW+btnGap)
                                local hov=not blk and inB(bx,eY,btnW,21)
                                if bi==0 then checkTooltip(btn,hov) end
                                local disabled=btn.Disabled
                                local locked=btn._locked
                                if not btn._hovT then btn._hovT=0 end
                                local hovTarget=hov and 1 or 0
                                local btnNow=_tick; local btnDt=btnNow-(btn._lastTick or btnNow); btn._lastTick=btnNow
                                btn._hovT=btn._hovT+(hovTarget-btn._hovT)*min(btnDt*10,1)

                                if hov and I.Click and not disabled and not locked then
                                    if btn.DblClick and not btn._confirming then
                                        btn._confirming=true; btn._confirmTick=ct
                                    elseif btn.DblClick and btn._confirming then
                                        btn._confirming=false; if btn.Cb then btn.Cb() end
                                    else
                                        if btn.Cb then btn.Cb() end
                                    end
                                end
                                if btn._confirming and ct-btn._confirmTick>1 then btn._confirming=false end

                                local bgCol=disabled and COL.HOV20 or MAIN
                                local txtCol=eFONT
                                local txtAlpha=disabled and 0.8 or(0.4-(btn._hovT*0.4))
                                local strokeAlpha=disabled and 0.5 or 0
                                if btn.Risky then txtCol=COL.RISKY end
                                if btn._confirming then txtCol=ACCENT; txtAlpha=0 end
                                local dispTxt=btn._confirming and"Are you sure?" or btn.Tx

                                self:RR("e_bo"..eid..bi,bx,eY,btnW,21,R2,OUTLINE,25)
                                self:RR("e_bb"..eid..bi,bx+1,eY+1,btnW-2,19,R2inner,bgCol,26)
                                local imgData=btn.Img and IconCache[btn.Img]
                                local hasImg=imgData and imgData~="fetching" and imgData~=false
                                local needsSlot=btn.Img
                                local sz=btn.ImgSz or 14
                                local phid="e_bph"..eid..bi
                                local function drawPh(ix,iy)
                                    self:DrawFailIcon(phid,ix,iy,sz,27)
                                    self:D("e_bi"..eid..bi,"Image",{Visible=false})
                                end
                                if hasImg and btn.ImgOnly then
                                    self:D("e_bi"..eid..bi,"Image",{Data=imgData,Size=v2(sz,sz),Transparency=1-txtAlpha,Color=btn.ImgCol or txtCol,ZIndex=27,Position=v2(bx+btnW/2-sz/2,eY+(21-sz)/2)})
                                    self:HideFailIcon(phid)
                                    self:D("e_bt"..eid..bi,"Text",{Visible=false})
                                elseif needsSlot and btn.ImgOnly then
                                    drawPh(bx+btnW/2-sz/2,eY+(21-sz)/2)
                                    self:D("e_bt"..eid..bi,"Text",{Visible=false})
                                elseif needsSlot then
                                    local tw2=tw(dispTxt,14)
                                    local gap=4
                                    local groupW=sz+gap+tw2
                                    local gX=bx+(btnW-groupW)/2
                                    local iy=eY+(21-sz)/2
                                    if btn.ImgPos=="Right" then
                                        self:D("e_bt"..eid..bi,"Text",{Text=dispTxt,Size=14,Font=FNT_ID,Color=txtCol,Transparency=1-txtAlpha,ZIndex=27,Position=v2(gX,eY+3)})
                                        if hasImg then
                                            self:D("e_bi"..eid..bi,"Image",{Data=imgData,Size=v2(sz,sz),Transparency=1-txtAlpha,Color=btn.ImgCol or txtCol,ZIndex=27,Position=v2(gX+tw2+gap,iy)})
                                            self:HideFailIcon(phid)
                                        else drawPh(gX+tw2+gap,iy) end
                                    else
                                        if hasImg then
                                            self:D("e_bi"..eid..bi,"Image",{Data=imgData,Size=v2(sz,sz),Transparency=1-txtAlpha,Color=btn.ImgCol or txtCol,ZIndex=27,Position=v2(gX,iy)})
                                            self:HideFailIcon(phid)
                                        else drawPh(gX,iy) end
                                        self:D("e_bt"..eid..bi,"Text",{Text=dispTxt,Size=14,Font=FNT_ID,Color=txtCol,Transparency=1-txtAlpha,ZIndex=27,Position=v2(gX+sz+gap,eY+3)})
                                    end
                                else
                                    self:D("e_bt"..eid..bi,"Text",{Text=dispTxt,Size=14,Font=FNT_ID,Color=txtCol,Transparency=1-txtAlpha,Center=true,ZIndex=27,Position=v2(bx+btnW/2,eY+10)})
                                    self:D("e_bi"..eid..bi,"Image",{Visible=false})
                                    self:HideFailIcon(phid)
                                end
                            end
                            eY=eY+21

                        elseif el.Ty=="Tgl" then
                            if el.Value==nil then el.Value=self.Flags[el.Id] end
                            local on=el.Value; local dis=el.Disabled
                            local hasHoldKb=false
                            if el.KP and Keybinds[el.KP.Id] and Keybinds[el.KP.Id].Mode=="Hold" then hasHoldKb=true end
                            local swW,swH=32,18; local swX=eX+eW-swW
                            local addonLeft=swX-6
                            if el.CPs then addonLeft=addonLeft-#el.CPs*24 end
                            if el.KP then local kbd=Keybinds[el.KP.Id]; local kbn=((kbd and kbd.Name) or"none").._kbModeSfx(kbd); addonLeft=addonLeft-max(tw(kbn,14)+9,18)-6 end
                            local labelW=max(0,addonLeft-eX)
                            local hovRaw=not blk and(inB(eX,eY,labelW,swH) or inB(swX,eY,swW,swH))
                            local hov=hovRaw and not dis
                            checkTooltip(el,hovRaw)
                            if hov and I.Click then
                                if el.Risky and not on then
                                    if el._riskyConfirm and ct-el._riskyTick<1 then
                                        el.Value=true; on=true; el._riskyConfirm=false
                                        if not hasHoldKb then self.Flags[el.Id]=true; if el.Cb then el.Cb(true) end end
                                    else el._riskyConfirm=true; el._riskyTick=ct end
                                else
                                    el.Value=not on; on=el.Value
                                    if not hasHoldKb then self.Flags[el.Id]=on; if el.Cb then el.Cb(on) end
                                    elseif not on then
                                        if self.Flags[el.Id] then self.Flags[el.Id]=false; if el.Cb then el.Cb(false) end end
                                    end
                                    if el.Risky then el._riskyConfirm=false end
                                end
                                blk=true
                            end
                            if not el._ballT then el._ballT=on and 1 or 0 end
                            local targetT=on and 1 or 0
                            local ballNow=_tick; local ballDt=ballNow-(el._lastTick or ballNow); el._lastTick=ballNow
                            el._ballT=el._ballT+(targetT-el._ballT)*min(ballDt*12,1)

                            local addonX=swX-6
                            if el.CPs then for ci=#el.CPs,1,-1 do local cp=el.CPs[ci]
                                addonX=addonX-18; cp._rx=addonX-px; cp._ry=eY-py
                                local cpHov=not blk and inB(addonX,eY,18,18)
                                self:RR("cpo_"..cp.Id,addonX,eY,18,18,R2,OUTLINE,25)
                                self:RR("cp_"..cp.Id,addonX+1,eY+1,16,16,R2inner,self.Flags[cp.Id],26)
                                if cpHov and I.Click and not blk then local h,s,v=r2h(self.Flags[cp.Id]); if S.ActiveCP and S.ActiveCP.Id==cp.Id then S.ActiveCP=nil else S.ActiveCP={Id=cp.Id,Ref=cp,H=h,S=s,V=v} end; blk=true end
                                addonX=addonX-6
                            end end
                            if el.KP then local kpId=el.KP.Id; local kd=self.Keybinds[kpId]; local kn=((kd and kd.Name) or"none").._kbModeSfx(kd); local kW=max(tw(kn,14)+9,18)
                                addonX=addonX-kW; local listening=S.KBListen==kpId
                                local kbActive=false
                                if kd and on then
                                    local mOk=true
                                    if kd.Mods then for mc in pairs(kd.Mods) do if not(I.Keys[mc] and I.Keys[mc].h) then mOk=false; break end end end
                                    if kd.Key then
                                        local k=I.Keys[kd.Key]
                                        if kd.Mode=="Hold" then kbActive=k and k.h and mOk
                                        else kbActive=mOk end
                                    end
                                end
                                local kpCol=kbActive and ACCENT or OUTLINE
                                self:RR("kpo_"..kpId,addonX,eY,kW,18,R2,kpCol,25)
                                self:RR("kp_"..kpId,addonX+1,eY+1,kW-2,16,R2inner,kbActive and ACCENT or MAIN,26)
                                self:D("kpt_"..kpId,"Text",{Text=listening and".." or kn,Size=14,Font=FNT_ID,Color=listening and ACCENT or(kbActive and FONT or FONT50),Center=true,ZIndex=27,Position=v2(addonX+kW/2,eY+9)})
                                local kpHov=not blk and inB(addonX,eY,kW,18)
                                if kpHov and I.Click and not(kd and kd.NoBind) then S.KBListen=kpId; blk=true end
                                if kpHov and I.RClick then _kbRClick(kd); blk=true end
                                addonX=addonX-6
                            end

                            if el._riskyConfirm and ct-el._riskyTick>1 then el._riskyConfirm=false end
                            local txtAlpha=dis and 0.2 or(on and 1 or 0.6)
                            local txtCol=el.Risky and COL.RISKY or eFONT
                            local dispTxt=el._riskyConfirm and"Are you sure?" or el.Tx
                            if el._riskyConfirm then txtCol=ACCENT; txtAlpha=1 end
                            dispTxt=truncFit(dispTxt,14,addonX-2-eX)
                            self:D("e_tt"..eid,"Text",{Text=dispTxt,Size=14,Font=FNT_ID,Color=txtCol,Transparency=txtAlpha,ZIndex=26,Position=v2(eX,eY+2)})

                            self:Pill("e_tso"..eid,swX,eY,swW,swH,on and ACCENT or OUTLINE,26)
                            self:Pill("e_ts"..eid,swX+1,eY+1,swW-2,swH-2,on and ACCENT or MAIN,27)

                            local ballCol=dis and FONT50 or FONT
                            local ballOff=swX+3+6; local ballOn=swX+swW-3-6
                            local ballX=ballOff+(ballOn-ballOff)*el._ballT
                            self:D("e_tb"..eid,"Circle",{Filled=true,Color=ballCol,Radius=6,NumSides=16,ZIndex=28,Position=v2(ballX,eY+9)})
                            eY=eY+18

                        elseif el.Ty=="Chk" then
                            local on=self.Flags[el.Id]; local dis=el.Disabled
                            local chkAddonL=eX+eW
                            if el.CPs then chkAddonL=chkAddonL-#el.CPs*24 end
                            if el.KP then local kbd=Keybinds[el.KP.Id]; local kbn=((kbd and kbd.Name) or"none").._kbModeSfx(kbd); chkAddonL=chkAddonL-max(tw(kbn,14)+9,18) end
                            local chkHitW=max(18,chkAddonL-eX-6)
                            local hovRaw=not blk and inB(eX,eY,chkHitW,18)
                            local hov=hovRaw and not dis
                            checkTooltip(el,hovRaw)
                            if hov and I.Click then
                                if el.Risky and not on then
                                    if el._riskyConfirm and ct-el._riskyTick<1 then
                                        self.Flags[el.Id]=true; on=true; el.Value=true; el._riskyConfirm=false; if el.Cb then el.Cb(true) end
                                    else el._riskyConfirm=true; el._riskyTick=ct end
                                else
                                    self.Flags[el.Id]=not on; on=self.Flags[el.Id]; el.Value=on; if el.Cb then el.Cb(on) end
                                    if el.Risky then el._riskyConfirm=false end
                                end
                                blk=true
                            end

                            local chkBg=on and ACCENT or(dis and COL.HOV20 or MAIN)
                            self:RR("e_co"..eid,eX,eY,18,18,R2,on and ACCENT or OUTLINE,25)
                            self:RR("e_cb"..eid,eX+1,eY+1,16,16,R2inner,chkBg,26)

                            local chkTr=dis and 0.2 or 1
                            self:D("e_c1"..eid,"Line",{Thickness=2,Color=FONT,Transparency=chkTr,ZIndex=27,Visible=on,From=v2(eX+4,eY+9),To=v2(eX+7,eY+13)})
                            self:D("e_c2"..eid,"Line",{Thickness=2,Color=FONT,Transparency=chkTr,ZIndex=27,Visible=on,From=v2(eX+7,eY+13),To=v2(eX+14,eY+5)})

                            local addonX2=eX+eW
                            if el.CPs then for ci=#el.CPs,1,-1 do local cp=el.CPs[ci]
                                addonX2=addonX2-18; cp._rx=addonX2-px; cp._ry=eY-py
                                local cpHov=not blk and inB(addonX2,eY,18,18)
                                self:RR("cpo_"..cp.Id,addonX2,eY,18,18,R2,OUTLINE,25)
                                self:RR("cp_"..cp.Id,addonX2+1,eY+1,16,16,R2inner,self.Flags[cp.Id],26)
                                if cpHov and I.Click and not blk then local h,s,v=r2h(self.Flags[cp.Id]); if S.ActiveCP and S.ActiveCP.Id==cp.Id then S.ActiveCP=nil else S.ActiveCP={Id=cp.Id,Ref=cp,H=h,S=s,V=v} end; blk=true end
                                addonX2=addonX2-6
                            end end
                            if el.KP then local kd=Keybinds[el.KP.Id]; local kn=((kd and kd.Name) or"none").._kbModeSfx(kd); local kW=max(tw(kn,14)+9,18)
                                addonX2=addonX2-kW; local listening=S.KBListen==el.KP.Id
                                self:RR("kpo_"..el.KP.Id,addonX2,eY,kW,18,R2,OUTLINE,25)
                                self:RR("kp_"..el.KP.Id,addonX2+1,eY+1,kW-2,16,R2inner,MAIN,26)
                                self:D("kpt_"..el.KP.Id,"Text",{Text=listening and".." or kn,Size=14,Font=FNT_ID,Color=listening and ACCENT or FONT50,Center=true,ZIndex=27,Position=v2(addonX2+kW/2,eY+9)})
                                local kpHov=not blk and inB(addonX2,eY,kW,18)
                                if kpHov and I.Click and not(kd and kd.NoBind) then S.KBListen=el.KP.Id; blk=true end
                                if kpHov and I.RClick then _kbRClick(kd); blk=true end
                            end

                            if el._riskyConfirm and ct-el._riskyTick>1 then el._riskyConfirm=false end
                            local txtAlpha2=dis and 0.2 or(on and 1 or 0.6)
                            local txtCol2=el.Risky and COL.RISKY or eFONT
                            local dispTxt2=el._riskyConfirm and"Are you sure?" or el.Tx
                            if el._riskyConfirm then txtCol2=ACCENT; txtAlpha2=1 end
                            dispTxt2=truncFit(dispTxt2,14,addonX2-2-(eX+26))
                            self:D("e_ct"..eid,"Text",{Text=dispTxt2,Size=14,Font=FNT_ID,Color=txtCol2,Transparency=txtAlpha2,ZIndex=26,Position=v2(eX+26,eY+2)})
                            eY=eY+18

                        elseif el.Ty=="Sld" then
                            local val=self.Flags[el.Id] or el.Mn or 0; local dis=el.Disabled
                            local barH=15; local barY=el.Compact and eY or eY+18
                            local labelHide=prevNoDraw or el.Compact or(eY+14>cullBot) or(eY+14<=cY)
                            local barHide=prevNoDraw or(barY+barH>cullBot) or(barY+barH<=cY)
                            if not el.Compact then
                                S._noDraw=labelHide
                                self:D("e_st"..eid,"Text",{Text=truncFit(el.Tx,14,eW-2),Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,ZIndex=26,Position=v2(eX,eY)})
                            end
                            S._noDraw=barHide
                            self:RR("e_so"..eid,eX,barY,eW,barH,R2,OUTLINE,25)
                            self:RR("e_sb"..eid,eX+1,barY+1,eW-2,barH-2,R2inner,MAIN,26)
                            local sldRng=el.Mx-el.Mn; local targetFr=sldRng>0 and clamp((val-el.Mn)/sldRng,0,1) or 0
                            local sldNow=_tick; local sldDt=sldNow-(el._lastTick2 or sldNow); el._lastTick2=sldNow
                            el._smoothFill=el._smoothFill+(targetFr-el._smoothFill)*min(sldDt*12,1)
                            if abs(el._smoothFill-targetFr)<0.0005 then el._smoothFill=targetFr end
                            local smoothVal=el.Mn+el._smoothFill*(el.Mx-el.Mn)
                            local fillW=el._smoothFill*(eW-2)
                            local fillCol=dis and OUTLINE or ACCENT
                            if fillW>=1 then self:RR("e_sf"..eid,eX+1,barY+1,fillW,barH-2,R2inner,fillCol,27)
                            else self:HideRR("e_sf"..eid) end
                            local dispVal
                            if el.Fmt then dispVal=tostring(el.Fmt(el,smoothVal))
                            elseif el.Compact then dispVal=el.Tx..": "..el.Pf..(el.Rnd>0 and format("%."..el.Rnd.."f",smoothVal) or tostring(floor(smoothVal+0.5)))..el.Sf
                            elseif el.HideMax then dispVal=el.Pf..(el.Rnd>0 and format("%."..el.Rnd.."f",smoothVal) or tostring(floor(smoothVal+0.5)))..el.Sf
                            else local fmtV=el.Rnd>0 and format("%."..el.Rnd.."f",smoothVal) or tostring(floor(smoothVal+0.5))
                                dispVal=el.Pf..fmtV..el.Sf.."/"..el.Pf..tostring(el.Mx)..el.Sf end
                            self:D("e_sv"..eid,"Text",{Text=dispVal,Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,Center=true,ZIndex=28,Position=v2(eX+eW/2,barY+6)})
                            local sldHov=not blk and inB(eX,barY-4,eW,barH+8)
                            checkTooltip(el,sldHov)
                            if not dis and sldHov and I.Click and not S.ActiveSlider then S.ActiveSlider=el end
                            if S.ActiveSlider==el then
                                if I.Down then
                                    local scale=eW>0 and clamp((mx-eX)/eW,0,1) or 0
                                    local rv=el.Mn+((el.Mx-el.Mn)*scale)
                                    local nv; if el.Rnd>0 then local m=pow(10,el.Rnd); nv=floor(rv*m+0.5)/m else nv=floor(rv+0.5) end
                                    nv=clamp(nv,el.Mn,el.Mx)
                                    if self.Flags[el.Id]~=nv then self.Flags[el.Id]=nv; if el.Cb then el.Cb(nv) end end
                                else S.ActiveSlider=nil end end
                            eY=eY+(el.Compact and 15 or 33)

                        elseif el.Ty=="RSld" then
                            local val=self.Flags[el.Id]; if type(val)~="table" then val={Min=el.Mn,Max=el.Mx}; self.Flags[el.Id]=val end
                            local dis=el.Disabled; local barH=15; local barY=eY+18
                            local labelHide=prevNoDraw or(eY+14>cullBot) or(eY+14<=cY)
                            local barHide=prevNoDraw or(barY+barH>cullBot) or(barY+barH<=cY)
                            S._noDraw=labelHide
                            self:D("e_rst"..eid,"Text",{Text=truncFit(el.Tx,14,eW-2),Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,ZIndex=26,Position=v2(eX,eY)})
                            S._noDraw=barHide
                            self:RR("e_rso"..eid,eX,barY,eW,barH,R2,OUTLINE,25)
                            self:RR("e_rsb"..eid,eX+1,barY+1,eW-2,barH-2,R2inner,MAIN,26)
                            local rng=el.Mx-el.Mn
                            local minFr=rng>0 and(val.Min-el.Mn)/rng or 0
                            local maxFr=rng>0 and(val.Max-el.Mn)/rng or 1
                            local minX=eX+1+minFr*(eW-2)
                            local maxX=eX+1+maxFr*(eW-2)
                            local fillCol=dis and OUTLINE or ACCENT
                            if maxX-minX>=1 then self:RR("e_rsf"..eid,minX,barY+1,maxX-minX,barH-2,R2inner,fillCol,27)
                            else self:HideRR("e_rsf"..eid) end
                            local function fmt(v) return el.Pf..(el.Rnd>0 and format("%."..el.Rnd.."f",v) or tostring(floor(v)))..el.Sf end
                            local dispVal=fmt(val.Min).." - "..fmt(val.Max)
                            self:D("e_rsv"..eid,"Text",{Text=dispVal,Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,Center=true,ZIndex=28,Position=v2(eX+eW/2,barY+6)})
                            self:D("e_rsk1"..eid,"Square",{Filled=true,Color=FONT,ZIndex=29,Position=v2(minX-1,barY-2),Size=v2(3,barH+4)})
                            self:D("e_rsk2"..eid,"Square",{Filled=true,Color=FONT,ZIndex=29,Position=v2(maxX-1,barY-2),Size=v2(3,barH+4)})
                            local sldHov=not blk and inB(eX,barY-4,eW,barH+8)
                            checkTooltip(el,sldHov)
                            if not dis and sldHov and I.Click and not S.ActiveSlider then
                                S.ActiveSlider=el
                                if abs(minX-maxX)<2 then el._drag=(mx>=minX) and"Max" or"Min"
                                else el._drag=abs(mx-minX)<=abs(mx-maxX) and"Min" or"Max" end
                            end
                            if S.ActiveSlider==el then
                                if I.Down then
                                    local scale=eW>0 and clamp((mx-eX)/eW,0,1) or 0
                                    local rv=el.Mn+((el.Mx-el.Mn)*scale)
                                    local nv; if el.Rnd>0 then local m=pow(10,el.Rnd); nv=floor(rv*m+0.5)/m else nv=floor(rv+0.5) end
                                    nv=clamp(nv,el.Mn,el.Mx)
                                    if el._drag=="Min" then
                                        if nv>val.Max then nv=val.Max end
                                        if val.Min~=nv then val.Min=nv; if el.Cb then el.Cb(val.Min,val.Max) end end
                                    else
                                        if nv<val.Min then nv=val.Min end
                                        if val.Max~=nv then val.Max=nv; if el.Cb then el.Cb(val.Min,val.Max) end end
                                    end
                                else S.ActiveSlider=nil; el._drag=nil end
                            end
                            eY=eY+33

                        elseif el.Ty=="DD" then
                            local dis=el.Disabled or #el.Opts==0; local hasTx=el.Tx and el.Tx~=""
                            local dispY=hasTx and eY+18 or eY
                            local labelHide=prevNoDraw or not hasTx or(eY+14>cullBot) or(eY+14<=cY)
                            local boxHide=prevNoDraw or(dispY+21>cullBot) or(dispY+21<=cY)
                            local isOpen=S.ActiveDD and S.ActiveDD==el
                            el._rx=eX-px; el._ry=dispY+21-py+2; el._rw=eW
                            if hasTx then
                                S._noDraw=labelHide
                                self:D("e_dt"..eid,"Text",{Text=truncFit(el.Tx,14,eW-2),Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,ZIndex=26,Position=v2(eX,eY)})
                            end
                            S._noDraw=boxHide
                            local hovRaw=not blk and inB(eX,dispY,eW,21)
                            local hov=hovRaw and not dis
                            checkTooltip(el,hovRaw)
                            self:RR("e_do"..eid,eX,dispY,eW,21,R2,OUTLINE,25)
                            self:RR("e_db"..eid,eX+1,dispY+1,eW-2,19,R2inner,MAIN,26)
                            local disp="---"
                            if el.Multi then
                                local parts={}; local val=self.Flags[el.Id]
                                if type(val)=="table" then for _,v in ipairs(el.Opts) do if val[v] then parts[#parts+1]=el.FmtDisp and el.FmtDisp(v) or v end end end
                                if #parts>0 then disp=concat(parts,", ") end
                            else
                                local v=self.Flags[el.Id]; if v~=nil then disp=el.FmtDisp and el.FmtDisp(v) or tostring(v) end
                            end
                            local selImg,hasImgSlot=nil,false
                            if not el.Multi and el.OptImgs then
                                local v=self.Flags[el.Id]
                                if v and el.OptImgs[v] then
                                    hasImgSlot=true
                                    local d2=IconCache[el.OptImgs[v]]
                                    if d2 and d2~="fetching" and d2~=false then selImg=d2 end
                                end
                            end
                            disp=truncFit(disp,14,(selImg or hasImgSlot) and(eW-40) or(eW-24))
                            local dispF=(not el.Multi and el.OptFonts and el.OptFonts[self.Flags[el.Id]]) or FNT_ID
                            if selImg then
                                self:D("e_dxi"..eid,"Image",{Data=selImg,Size=v2(14,14),Transparency=dis and 0.2 or 1,Color=dis and FONT50 or FONT,ZIndex=27,Position=v2(eX+6,dispY+3)})
                                self:HideFailIcon("e_dxph"..eid)
                                self:D("e_dx"..eid,"Text",{Text=disp,Size=14,Font=dispF,Color=dis and FONT50 or FONT,Transparency=dis and 0.2 or 1,ZIndex=27,Position=v2(eX+24,dispY+2)})
                            elseif hasImgSlot then
                                self:D("e_dxi"..eid,"Image",{Visible=false})
                                self:DrawFailIcon("e_dxph"..eid,eX+6,dispY+3,14,27)
                                self:D("e_dx"..eid,"Text",{Text=disp,Size=14,Font=dispF,Color=dis and FONT50 or FONT,Transparency=dis and 0.2 or 1,ZIndex=27,Position=v2(eX+24,dispY+2)})
                            else
                                self:D("e_dxi"..eid,"Image",{Visible=false})
                                self:HideFailIcon("e_dxph"..eid)
                                self:D("e_dx"..eid,"Text",{Text=disp,Size=14,Font=dispF,Color=dis and FONT50 or FONT,Transparency=dis and 0.2 or 1,ZIndex=27,Position=v2(eX+8,dispY+2)})
                            end
                            local arTr=isOpen and 1 or 0.5
                            if isOpen then self:D("e_da"..eid,"Text",{Text="^",Size=12,Font=FNT_ID,Color=FONT,Transparency=arTr,ZIndex=27,Position=v2(eX+eW-14,dispY+6)})
                            else self:D("e_da"..eid,"Text",{Text="v",Size=12,Font=FNT_ID,Color=FONT,Transparency=arTr,ZIndex=27,Position=v2(eX+eW-14,dispY+3)}) end
                            if hov and I.Click and not blk then
                                if isOpen then S.ActiveDD=nil else S.ActiveDD=el end; blk=true end
                            eY=eY+(hasTx and 39 or 21)

                        elseif el.Ty=="Inp" then
                            local dis=el.Disabled; local hasTx=el.Tx and el.Tx~=""
                            local boxY=hasTx and eY+18 or eY
                            local labelHide=prevNoDraw or not hasTx or(eY+14>cullBot) or(eY+14<=cY)
                            local boxHide=prevNoDraw or(boxY+21>cullBot) or(boxY+21<=cY)
                            el._x=eX; el._y=boxY; el._w=eW; el._h=21
                            local foc=S.FocusInput==el
                            local hovRaw=not blk and inB(eX,boxY,eW,21)
                            local hov=hovRaw and not dis
                            checkTooltip(el,hovRaw)
                            if hasTx then
                                S._noDraw=labelHide
                                self:D("e_it"..eid,"Text",{Text=truncFit(el.Tx,14,eW-2),Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,ZIndex=26,Position=v2(eX,eY)})
                            end
                            S._noDraw=boxHide
                            self:RR("e_io"..eid,eX,boxY,eW,21,R2,foc and ACCENT or OUTLINE,25)
                            self:RR("e_ib"..eid,eX+1,boxY+1,eW-2,19,R2inner,MAIN,26)
                            local val=self.Flags[el.Id] or""
                            local maxW=eW-14
                            local disp,txtCol
                            if val=="" and not foc then disp=truncFit(el.PH,14,maxW); txtCol=FONT50
                            elseif foc then disp=tailFit(val,14,maxW-8)..(floor(ct*2)%2==0 and"|"or""); txtCol=FONT
                            else disp=truncFit(val,14,maxW); txtCol=FONT end
                            self:D("e_ix"..eid,"Text",{Text=disp,Size=14,Font=FNT_ID,Color=txtCol,Transparency=dis and 0.2 or 1,ZIndex=27,Position=v2(eX+8,boxY+4)})
                            if hov and I.Click and not foc and not blk then
                                S.FocusInput=el; el._pre=self.Flags[el.Id]
                                if el.ClearOnFocus then self.Flags[el.Id]="" end
                            end
                            eY=eY+(hasTx and 39 or 21)

                        elseif el.Ty=="Lbl" then
                            el._lastW=eW-2
                            if el.Wrap then
                                local lns=wrapLinesCached(el,el.Tx or"",el.Sz or 14,eW-2)
                                for li=1,#lns do self:D("e_lt"..eid.."_"..li,"Text",{Text=lns[li],Size=el.Sz or 14,Font=FNT_ID,Color=el.Col or FONT,ZIndex=26,Position=v2(eX,eY+1+(li-1)*18)}) end
                                for li=#lns+1,15 do self:D("e_lt"..eid.."_"..li,"Text",{Visible=false}) end
                                self:D("e_lt"..eid,"Text",{Visible=false})
                                eY=eY+#lns*18
                            else
                                self:D("e_lt"..eid,"Text",{Text=truncFit(el.Tx,el.Sz or 14,eW-2),Size=el.Sz or 14,Font=FNT_ID,Color=el.Col or FONT,ZIndex=26,Position=v2(eX,eY+1)})
                                for li=1,15 do self:D("e_lt"..eid.."_"..li,"Text",{Visible=false}) end
                                eY=eY+18
                            end

                        elseif el.Ty=="Div" then
                            self:D("e_dl"..eid,"Square",{Filled=true,Color=MAIN,ZIndex=26,Position=v2(eX,eY+2),Size=v2(eW,2)})
                            self:D("e_do2"..eid,"Square",{Filled=false,Color=OUTLINE,Thickness=1,ZIndex=26,Position=v2(eX,eY+2),Size=v2(eW,2)})
                            eY=eY+6

                        elseif el.Ty=="CP" then
                            local cpSz=18; local cpX=eX+eW-cpSz
                            el._rx=cpX+cpSz+4-px; el._ry=eY-py
                            local hov=not blk and inB(cpX,eY,cpSz,cpSz)
                            self:D("e_pt"..eid,"Text",{Text=truncFit(el.Tx,14,cpX-4-eX),Size=14,Font=FNT_ID,Color=FONT,ZIndex=26,Position=v2(eX,eY+2)})
                            self:RR("e_ps"..eid,cpX,eY,cpSz,cpSz,R2,self.Flags[el.Id],26)
                            self:D("e_po"..eid,"Square",{Filled=false,Color=OUTLINE,Thickness=1,ZIndex=26,Position=v2(cpX,eY),Size=v2(cpSz,cpSz)})
                            if hov and I.Click and not blk then
                                local h,s,v=r2h(self.Flags[el.Id])
                                if S.ActiveCP and S.ActiveCP.Ref==el then S.ActiveCP=nil
                                else S.ActiveCP={Id=el.Id,Ref=el,H=h,S=s,V=v} end; blk=true end
                            eY=eY+18

                        elseif el.Ty=="KB" then
                            local kd=Keybinds[el.Id]; local kbName=(kd.Name or"none").._kbModeSfx(kd)
                            local kbW=max(tw(kbName,14)+9,18); local kbX=eX+eW-kbW; local listening=S.KBListen==el.Id
                            local hov=not blk and inB(kbX,eY,kbW,18)
                            self:D("e_kt"..eid,"Text",{Text=truncFit(el.Tx,14,kbX-4-eX),Size=14,Font=FNT_ID,Color=FONT,ZIndex=26,Position=v2(eX,eY+2)})
                            self:RR("e_kb"..eid,kbX,eY,kbW,18,R2,MAIN,26)
                            self:D("e_ko"..eid,"Square",{Filled=false,Color=OUTLINE,Thickness=1,ZIndex=26,Position=v2(kbX,eY),Size=v2(kbW,18)})
                            self:D("e_kx"..eid,"Text",{Text=listening and".." or kbName,Size=14,Font=FNT_ID,Color=listening and ACCENT or FONT50,Center=true,ZIndex=27,Position=v2(kbX+kbW/2,eY+2)})
                            if hov and I.Click and not kd.NoBind then S.KBListen=el.Id; blk=true end
                            if hov and I.RClick then _kbRClick(kd); blk=true end
                            eY=eY+18
                        elseif el.Ty=="Img" then
                            local iw=(el.Sz and el.Sz.X) or eW
                            local ih=(el.Sz and el.Sz.Y) or el.Height or 100
                            local ix=eX+floor((eW-iw)/2)
                            local hovI=not blk and inB(ix,eY,iw,ih)
                            checkTooltip(el,hovI)
                            local data=el.Image and IconCache[el.Image]
                            if data and data~="fetching" then
                                self:D("e_img"..eid,"Image",{Data=data,Size=v2(iw,ih),Transparency=el.Tr or 1,ZIndex=26,Position=v2(ix,eY),Color=el.Col or FONT})
                                self:D("e_imgp"..eid,"Square",{Visible=false})
                            else
                                self:RR("e_imgp"..eid,ix,eY,iw,ih,R2,MAIN,26)
                                self:D("e_img"..eid,"Image",{Visible=false})
                            end
                            eY=eY+ih
                        elseif el.Ty=="MC" then
                            local dis=el.Disabled; local hasTx=el.Tx and el.Tx~=""
                            local rowY0=hasTx and eY+18 or eY
                            local gap=4; local n=#el.Opts; local wrap=self.Flags.MCWrap~=false
                            local rows={}; local cur={}; local used=0
                            for i=1,n do
                                local opt=el.Opts[i]
                                local natW=(opt.Img and 18 or 0)+tw(opt.Name or"",14)+12
                                local needed=natW+(#cur>0 and gap or 0)
                                if wrap and #cur>0 and used+needed>eW then rows[#rows+1]=cur; cur={}; used=0; needed=natW end
                                cur[#cur+1]=i; used=used+needed
                            end
                            if #cur>0 then rows[#rows+1]=cur end
                            if #rows==0 then rows={{}} end
                            el._mcRows=#rows
                            if hasTx then
                                S._noDraw=prevNoDraw or(eY+14>cullBot) or(eY+14<=cY)
                                self:D("e_mct"..eid,"Text",{Text=truncFit(el.Tx,14,eW-2),Size=14,Font=FNT_ID,Color=FONT,Transparency=dis and 0.2 or 1,ZIndex=26,Position=v2(eX,eY)})
                            end
                            for rIdx,row in ipairs(rows) do
                                local rowY=rowY0+(rIdx-1)*(21+gap)
                                S._noDraw=prevNoDraw or(rowY+21>cullBot) or(rowY+21<=cY)
                                local rn=#row; local segW=rn>0 and floor((eW-gap*(rn-1))/rn) or eW
                                for slot=1,rn do
                                    local i=row[slot]; local opt=el.Opts[i]
                                    local sx2=eX+(slot-1)*(segW+gap)
                                    local flag=Library.Flags[el.Id]
                                    local on=el.Multi and (type(flag)=="table" and flag[opt.Name]) or (flag==opt.Name)
                                    local hov=not blk and not dis and inB(sx2,rowY,segW,21)
                                    if hov and I.Click then
                                        if el.Multi then
                                            local t=Library.Flags[el.Id]; if type(t)~="table" then t={} end
                                            if t[opt.Name] then t[opt.Name]=nil else t[opt.Name]=true end
                                            Library.Flags[el.Id]=t; if el.Cb then el.Cb(t) end
                                        else
                                            Library.Flags[el.Id]=opt.Name; if el.Cb then el.Cb(opt.Name) end
                                        end
                                    end
                                    if hov and opt.Tooltip then nextTooltip=opt.Tooltip end
                                    local olCol=on and ACCENT or OUTLINE
                                    local bgCol=on and ACCENT or(hov and COL.HOV22 or MAIN)
                                    local txCol=dis and FONT50 or FONT
                                    local txAlpha=dis and 0.4 or 1
                                    self:RR("e_mco"..eid..i,sx2,rowY,segW,21,R2,olCol,25)
                                    self:RR("e_mcb"..eid..i,sx2+1,rowY+1,segW-2,19,R2inner,bgCol,26)
                                    local imgData=opt.Img and IconCache[opt.Img]
                                    local hasImg=imgData and imgData~="fetching" and imgData~=false
                                    local needsSlot=opt.Img
                                    if needsSlot then
                                        local sz=14
                                        local tw2=tw(opt.Name,14)
                                        local groupW=sz+4+tw2
                                        local gX=sx2+(segW-groupW)/2
                                        if hasImg then
                                            self:D("e_mci"..eid..i,"Image",{Data=imgData,Size=v2(sz,sz),Transparency=txAlpha,Color=txCol,ZIndex=27,Position=v2(gX,rowY+(21-sz)/2)})
                                            self:HideFailIcon("e_mcph"..eid..i)
                                        else
                                            self:D("e_mci"..eid..i,"Image",{Visible=false})
                                            self:DrawFailIcon("e_mcph"..eid..i,gX,rowY+(21-sz)/2,sz,27)
                                        end
                                        self:D("e_mcx"..eid..i,"Text",{Text=opt.Name,Size=14,Font=FNT_ID,Color=txCol,Transparency=txAlpha,ZIndex=27,Position=v2(gX+sz+4,rowY+3)})
                                    else
                                        self:D("e_mci"..eid..i,"Image",{Visible=false})
                                        self:HideFailIcon("e_mcph"..eid..i)
                                        self:D("e_mcx"..eid..i,"Text",{Text=opt.Name,Size=14,Font=FNT_ID,Color=txCol,Transparency=txAlpha,Center=true,ZIndex=27,Position=v2(sx2+segW/2,rowY+10)})
                                    end
                                end
                            end
                            eY=eY+(hasTx and 18 or 0)+#rows*21+(#rows-1)*gap
                        elseif el.Custom and el._reg and el._reg.Draw then
                            local h=elH(el)
                            local clipH=min(h,max(0,cullBot-eY))
                            S._nextTooltip=nil
                            if clipH>0 then pcall(el._reg.Draw,Library,el,eid,eX,eY,eW,clipH,blk) end
                            if S._nextTooltip then nextTooltip=S._nextTooltip; S._nextTooltip=nil end
                            eY=eY+h
                        end
                    S._noDraw=prevNoDraw
                    end
                end
                return eY
            end

            local function colH(groups)
                local h=0
                for _,g in ipairs(groups) do
                    if g.Visible==false or not gbMatches(g) then
                    elseif g.IsTB then h=h+tbH(g)+GB_GAP
                    else h=h+searchGbH(g)+GB_GAP end
                end
                return h
            end
            local totalH=max(colH(aTab.LG),colH(aTab.RG))
            local maxScroll=max(0,totalH-cAvailH)
            if self.Flags.ScrollbarAccountance and maxScroll>0 then cW=cW-7; colW=floor((cW-COL_GAP)/2) end
            if aTab._scroll>maxScroll then aTab._scroll=maxScroll end
            if aTab._scroll<0 then aTab._scroll=0 end
            local sOff=aTab._scroll

            local function renderCol(groups,colX,side)
                local curY=cY-sOff
                for gi,g in ipairs(groups) do
                    local gid=aTab.Name..side..gi
                    if g.Visible==false or not gbMatches(g) then
                    elseif g.IsTB then
                        local tH=tbH(g); local tbid=gid.."tb"
                        local visTop=max(curY,cY); local visBot=min(curY+tH,cY+cAvailH); local visH=visBot-visTop
                        if visH>0 then
                            self:RR("gb_dk"..gid,colX-1,visTop-1,colW+2,visH+2,gRp,SHADOW,22)
                            self:RR("gb_ol"..gid,colX,visTop,colW,visH,gR,OUTLINE,23)
                            self:RR("gb_bg"..gid,colX+1,visTop+1,colW-2,visH-2,gR2,BG,24)
                            if _hasSearch then
                                if not g._preSearchSub then g._preSearchSub=g.ActiveSub end
                                local curHas=false
                                for _,st in ipairs(g.SubTabs) do if st.Name==g.ActiveSub then for _,e in ipairs(st.Els) do if elMatches(e) then curHas=true; break end end; break end end
                                if not curHas then for _,st in ipairs(g.SubTabs) do for _,e in ipairs(st.Els) do if elMatches(e) then g.ActiveSub=st.Name; curHas=true; break end end; if curHas then break end end end
                            elseif g._preSearchSub then
                                g.ActiveSub=g._preSearchSub; g._preSearchSub=nil
                            end
                            local numSubs=#g.SubTabs; local subBtnW=numSubs>0 and floor((colW-2)/numSubs) or colW-2
                            for si,st in ipairs(g.SubTabs) do
                                local bx=colX+1+((si-1)*subBtnW); local isSubAct=(g.ActiveSub==st.Name)
                                local subHov=not blk and inB(bx,curY+1,subBtnW,TB_BTN_H)
                                if subHov then blk=true end
                                if subHov and I.Click and not isSubAct then g.ActiveSub=st.Name end
                                local subBg=isSubAct and BG or MAIN
                                if subHov and not isSubAct then subBg=COL.HOV22 end
                                local _ph=S._noDraw; if curY+1+TB_BTN_H<cY-2 or curY+1>cY+cAvailH+2 then S._noDraw=true end
                                self:D("tb_b"..tbid..si,"Square",{Filled=true,Color=subBg,ZIndex=25,Position=v2(bx,curY+1),Size=v2(subBtnW,TB_BTN_H-1)})
                                if not isSubAct then self:D("tb_s"..tbid..si,"Square",{Filled=true,Color=OUTLINE,ZIndex=25,Position=v2(bx,curY+TB_BTN_H),Size=v2(subBtnW,1)})
                                else self:D("tb_s"..tbid..si,"Square",{Visible=false}) end
                                self:D("tb_t"..tbid..si,"Text",{Text=st.Name,Size=15,Font=FNT_ID,Color=isSubAct and FONT or FONT50,Center=true,ZIndex=26,Position=v2(bx+subBtnW/2,curY+12)})
                                S._noDraw=_ph
                            end
                            for _,st in ipairs(g.SubTabs) do if st.Name==g.ActiveSub then
                                renderEls(st.Els,colX+1+GB_PAD,curY+TB_BTN_H+1+GB_PAD,colW-2-GB_PAD*2,gid.."s")
                            end end
                        end
                        curY=curY+tH+GB_GAP
                    else
                        local gHt=searchGbH(g)
                        local visTop=max(curY,cY); local visBot=min(curY+gHt,cY+cAvailH); local visH=visBot-visTop
                        if visH>0 then
                            self:RR("gb_dk"..gid,colX-1,visTop-1,colW+2,visH+2,gRp,SHADOW,22)
                            self:RR("gb_ol"..gid,colX,visTop,colW,visH,gR,OUTLINE,23)
                            self:RR("gb_bg"..gid,colX+1,visTop+1,colW-2,visH-2,gR2,BG,24)
                            if curY+GB_HDR>=cY and curY+1<=cY+cAvailH then
                                self:D("gb_hdr"..gid,"Square",{Filled=true,Color=BG,ZIndex=25,Position=v2(colX+1,curY+1),Size=v2(colW-2,GB_HDR-1)})
                                self:D("gb_sep"..gid,"Square",{Filled=true,Color=OUTLINE,ZIndex=25,Position=v2(colX+1,curY+GB_HDR),Size=v2(colW-2,1)})
                                self:D("gb_txt"..gid,"Text",{Text=truncFit(g.Name,15,colW-24),Size=15,Font=FNT_ID,Color=FONT,ZIndex=26,Position=v2(colX+12,curY+10)})
                            else
                                self:D("gb_hdr"..gid,"Square",{Visible=false})
                                self:D("gb_sep"..gid,"Square",{Visible=false})
                                self:D("gb_txt"..gid,"Text",{Visible=false})
                            end
                            renderEls(g.Els,colX+1+GB_PAD,curY+GB_HDR+1+GB_PAD,colW-2-GB_PAD*2,gid)
                        end
                        curY=curY+gHt+GB_GAP
                    end
                end
            end
            renderCol(aTab.LG,cX,"L"); renderCol(aTab.RG,cX+colW+COL_GAP,"R")

            if maxScroll>0 then
                local sbBarW=7; local sbBarPad=4
                local sbBarX=px+sx-sbBarW-sbBarPad
                local sbBarY=py+W.HdrH+1+sbBarPad
                local sbBarH=cAvailH+COL_PAD*2-sbBarPad*2
                local thumbH=max(20,floor((cAvailH/totalH)*sbBarH))
                local thumbY=sbBarY+floor((sOff/maxScroll)*(sbBarH-thumbH))
                local thumbHov=not blk and inB(sbBarX,thumbY,sbBarW,thumbH)
                local thumbCol=S._scrollDrag and COL.SBT90 or(thumbHov and COL.SBT75 or COL.SBT55)
                self:RR("w_sbtrk",sbBarX,sbBarY,sbBarW,sbBarH,3,COL.DD18,30)
                self:RR("w_sbthm",sbBarX+1,thumbY,sbBarW-2,thumbH,3,thumbCol,31)
                if thumbHov and I.Click and not blk then
                    S._scrollDrag=true; S._scrollDragOff=I.MY-thumbY; blk=true
                end
                if S._scrollDrag then
                    if not I.Down then S._scrollDrag=false
                    else
                        local newY=I.MY-S._scrollDragOff
                        local trackRange=sbBarH-thumbH
                        if trackRange>0 then aTab._scroll=clamp(((newY-sbBarY)/trackRange)*maxScroll,0,maxScroll) end
                    end
                end
                if not S.FocusInput and not S.KBListen and not S.SearchFocused then
                    if I.Keys[0x21] and I.Keys[0x21].c then aTab._scroll=clamp(aTab._scroll-cAvailH*0.9,0,maxScroll) end
                    if I.Keys[0x22] and I.Keys[0x22].c then aTab._scroll=clamp(aTab._scroll+cAvailH*0.9,0,maxScroll) end
                end
            else
                self:HideRR("w_sbtrk"); self:HideRR("w_sbthm")
            end
        end
    end

    local _w=self.Window; if _w then local _p,_s=_w.Pos,_w.Size; if I.MY>=_p.Y+_s.Y-_w.BotH-1 and I.MY<=_p.Y+_s.Y and I.MX>=_p.X and I.MX<=_p.X+_s.X then nextTooltip=nil end end
    if nextTooltip and nextTooltip~=S.HoverTooltip then S.HoverStart=_tick end
    S.HoverTooltip=nextTooltip
    if S.HoverTooltip then
        local tpTxt=S.HoverTooltip
        local tpW=#tpTxt*(13*0.46)+12; local tpH=22
        local tpX=I.MX+12; local tpY=I.MY+12
        pcall(function()
            local vp=workspace.CurrentCamera.ViewportSize
            if tpX+tpW>vp.X then tpX=I.MX-tpW-4 end
            if tpY+tpH>vp.Y then tpY=I.MY-tpH-4 end
        end)
        local BG_TP,OL_TP,FNT_TP=COL.BG_TP,COL.OL_TP,COL.FNT_TP
        self:RR("tp_dk",tpX-1,tpY-1,tpW+2,tpH+2,3,COL.SHADOW,98)
        self:RR("tp_ol",tpX,tpY,tpW,tpH,2,OL_TP,99)
        self:RR("tp_bg",tpX+1,tpY+1,tpW-2,tpH-2,1,BG_TP,100)
        self:D("tp_tx","Text",{Text=tpTxt,Size=13,Font=FNT_ID,Color=FNT_TP,ZIndex=101,Position=v2(tpX+8,tpY+4)})
    else
        self:HideRR("tp_dk"); self:HideRR("tp_ol"); self:HideRR("tp_bg")
        self:D("tp_tx","Text",{Visible=false})
    end

    local vpX=1200; pcall(function() vpX=workspace.CurrentCamera.ViewportSize.X end)
    local ct2=_tick; local nY=10
    local N_W=280; local N_R=4
    local N_BG,N_OL,N_SH=COL.N_BG,COL.N_OL,COL.SHADOW
    local N_ACC,N_FNT=COL.N_ACC,COL.N_FNT
    local N_DESC=COL.N_DESC

    for ni=#self.Notifications,1,-1 do
        local n=self.Notifications[ni]; local elapsed=ct2-n.St
        local descSz=n.Title and 13 or 14
        local descLines=wrapLinesCached(n,n.Desc or"",descSz,N_W-24)
        local extraLines=max(0,#descLines-1)
        local nH=(n.Title and 58 or 42)+extraLines*16
        local showBar=not n.Persist and(type(n.Time)=="number" or n.Steps)

        local notifDt=ct2-(n._lastTk or ct2); n._lastTk=ct2
        if not n.Destroyed and not n.Persist and not n.Steps and type(n.Time)=="number" and elapsed>n.Time then n.Destroyed=true end
        if not n.Destroyed and n._destroyAt and ct2>=n._destroyAt then n.Destroyed=true end
        local tgt=n.Destroyed and 0 or 1
        n.Alpha=(n.Alpha or 0)+(tgt-(n.Alpha or 0))*clamp(notifDt*14,0,1)
        if n.Destroyed and n.Alpha<=0.02 then
            for _,sfx in ipairs({"_sh","_ol","_bg","_ac","_tt","_ds","_tb","_tf"}) do
                local d=self.Drawings["n"..ni..sfx]; if d then d.O.Visible=false end
                self:HideRR("n"..ni..sfx)
            end
            for li=1,10 do local d=self.Drawings["n"..ni.."_ds"..li]; if d then d.O.Visible=false end end
            remove(self.Notifications,ni); n=nil
        end
        if n then
            local a=n.Alpha
            local nX=vpX-N_W-12

            self:RR("n"..ni.."_sh",nX+2,nY+2,N_W,nH,N_R,N_SH,57,0.4*a)
            self:RR("n"..ni.."_ol",nX,nY,N_W,nH,N_R,N_OL,58,a)
            self:RR("n"..ni.."_bg",nX+1,nY+1,N_W-2,nH-2,max(N_R-1,0),N_BG,59,a)
            self:RR("n"..ni.."_ac",nX+1,nY+3,3,nH-6,1,n.Color or N_ACC,60,a)
            local tX=nX+14
            local descBaseY=n.Title and(nY+30) or(nY+13)
            local descCol=n.Title and N_DESC or N_FNT
            if n.Title then
                self:D("n"..ni.."_tt","Text",{Text=n.Title,Size=15,Font=FNT_ID,Color=N_FNT,Transparency=a,ZIndex=61,Position=v2(tX,nY+10)})
            else
                self:D("n"..ni.."_tt","Text",{Visible=false})
            end
            for li=1,#descLines do
                self:D("n"..ni.."_ds"..li,"Text",{Text=descLines[li],Size=descSz,Font=FNT_ID,Color=descCol,Transparency=a,ZIndex=61,Position=v2(tX,descBaseY+(li-1)*16)})
            end
            for li=#descLines+1,10 do self:D("n"..ni.."_ds"..li,"Text",{Visible=false}) end
            self:D("n"..ni.."_ds","Text",{Visible=false})

            if showBar then
                local barH2=4; local barPad=10
                local barY=nY+nH-barH2-6
                local barX=nX+barPad; local barW=N_W-barPad*2
                local frac=0
                if n.Steps then frac=clamp(n._step/n.Steps,0,1)
                elseif type(n.Time)=="number" and n.Time>0 then frac=clamp(1-elapsed/n.Time,0,1) end
                self:RR("n"..ni.."_tb",barX,barY,barW,barH2,2,COL.N_TB,61,a)
                local fillW=frac*barW
                if fillW>=1 then self:RR("n"..ni.."_tf",barX,barY,fillW,barH2,2,n.Color or N_ACC,62,a)
                else self:HideRR("n"..ni.."_tf") end
            else
                self:HideRR("n"..ni.."_tb"); self:HideRR("n"..ni.."_tf")
            end

            nY=nY+(nH+8)*a
        end
    end

    if self.ActiveDialog then
        local d=self.ActiveDialog; local dt5=_tick-(d._lastTk or _tick); d._lastTk=_tick
        local k=min(dt5*16,1)
        if d.Alive then
            d.Alpha=d.Alpha+(1-d.Alpha)*k
            d.Scale=d.Scale+(1-d.Scale)*k
        else
            d.Alpha=d.Alpha+(0-d.Alpha)*k
            d.Scale=d.Scale+(0.92-d.Scale)*k
            if d.Alpha<=0.02 then
                for _,sfx in ipairs({"dlg_ov","dlg_ol","dlg_bg","dlg_dk","dlg_sh","dlg_sh2","dlg_sh3","dlg_sep","dlg_t","dlg_d"}) do
                    local dr=self.Drawings[sfx]; if dr then dr.O.Visible=false end
                    self:HideRR(sfx)
                end
                for bi,_ in ipairs(d.Btns) do
                    for _,sfx in ipairs({"dlg_bo","dlg_bb","dlg_bp","dlg_bt"}) do
                        local dr=self.Drawings[sfx..bi]; if dr then dr.O.Visible=false end
                        self:HideRR(sfx..bi)
                    end
                end
                self.ActiveDialog=nil
            end
        end

        if self.ActiveDialog then
            local a=d.Alpha
            local dW=440; local padding=20; local titleH=24; local descGap=12
            local descLines=max(1,ceil(#d.Desc/60))
            local descH=descLines*18
            local btnH=32; local footerPadTop=16; local footerH=(#d.Btns>0) and(footerPadTop+btnH) or 0
            local elsH=0; local _elGap=6
            for _,el in ipairs(d.Els or{}) do
                if el.Visible~=false then
                    local eh=0
                    if el.Ty=="Lbl" then eh=18
                    elseif el.Ty=="Div" then eh=6
                    elseif el.Ty=="Inp" then eh=(el.Tx and el.Tx~="") and 39 or 21
                    elseif el.Ty=="Tgl" or el.Ty=="Chk" then eh=18 end
                    if eh>0 then if elsH>0 then elsH=elsH+_elGap end; elsH=elsH+eh end
                end
            end
            local elsTopGap=elsH>0 and 14 or 0
            local dH=padding+titleH+descGap+descH+elsTopGap+elsH+padding+footerH

            local vpX2,vpY2=1200,800; pcall(function() local vp=workspace.CurrentCamera.ViewportSize; vpX2=vp.X; vpY2=vp.Y end)
            self:D("dlg_ov","Square",{Filled=true,Color=COL.SHADOW,Transparency=0.5*a,ZIndex=90,Position=v2(0,0),Size=v2(vpX2,vpY2)})

            local W2=self.Window
            local winCX=W2 and(W2.Pos.X+W2.Size.X/2) or vpX2/2
            local winCY=W2 and(W2.Pos.Y+W2.Size.Y/2) or vpY2/2

            if d._justOpened and not I.Down then d._justOpened=false end
            if d.OutsideDismiss and d.Alive and I.Click and not d._justOpened then
                local dcX=winCX-dW/2; local dcY=winCY-dH/2
                if not inB(dcX,dcY,dW,dH) then d.Alive=false; d._dismissTick=_tick end
            end

            local sdW=dW*d.Scale; local sdH=dH*d.Scale
            local dX=winCX-sdW/2; local dY=winCY-sdH/2
            local R_D=6
            local BG_D,BG2_D=COL.BG_D,COL.BG2_D
            local OL_D,OL2_D=COL.OL_D,COL.OL2_D
            local SH_D,MAIN_D=COL.SHADOW,COL.MAIN_D
            local FNT_D,DESC_D=COL.FNT_D,COL.DESC_D

            self:HideRR("dlg_sh3"); self:HideRR("dlg_sh2"); self:HideRR("dlg_sh")
            self:RR("dlg_dk",dX-1,dY-1,sdW+2,sdH+2,R_D+1,SH_D,91,a)
            self:RR("dlg_ol",dX,dY,sdW,sdH,R_D,OL_D,92,a)
            self:RR("dlg_bg",dX+1,dY+1,sdW-2,sdH-2,max(R_D-1,0),BG_D,93,a)

            self:D("dlg_t","Text",{Text=d.Title,Size=20,Font=FNT_ID,Color=FNT_D,Transparency=a,ZIndex=94,Position=v2(dX+padding,dY+padding)})
            self:D("dlg_d","Text",{Text=d.Desc,Size=14,Font=FNT_ID,Color=DESC_D,Transparency=a,ZIndex=94,Position=v2(dX+padding,dY+padding+titleH+descGap)})

            local _elsY=dY+padding+titleH+descGap+descH+elsTopGap
            local _elsX=dX+padding; local _elsW=sdW-padding*2
            for ei,el in ipairs(d.Els or{}) do
                if el.Visible==false then
                elseif el.Ty=="Lbl" then
                    self:D("dlg_el_lbl"..ei,"Text",{Text=el.Tx or"",Size=el.Sz or 14,Font=FNT_ID,Color=el.Col or FNT_D,Transparency=a,ZIndex=94,Position=v2(_elsX,_elsY+1)})
                    _elsY=_elsY+18+_elGap
                elseif el.Ty=="Div" then
                    self:D("dlg_el_div"..ei,"Square",{Filled=true,Color=OL_D,Transparency=a,ZIndex=94,Position=v2(_elsX,_elsY+2),Size=v2(_elsW,2)})
                    _elsY=_elsY+6+_elGap
                elseif el.Ty=="Inp" then
                    local hasTx=el.Tx and el.Tx~=""
                    local boxY=hasTx and _elsY+18 or _elsY
                    el._x=_elsX; el._y=boxY; el._w=_elsW; el._h=21
                    local foc=S.FocusInput==el
                    local hov=inB(_elsX,boxY,_elsW,21)
                    if hasTx then self:D("dlg_el_it"..ei,"Text",{Text=el.Tx,Size=14,Font=FNT_ID,Color=FNT_D,Transparency=a,ZIndex=94,Position=v2(_elsX,_elsY)}) end
                    self:RR("dlg_el_io"..ei,_elsX,boxY,_elsW,21,4,foc and ACCENT or OL_D,94,a)
                    self:RR("dlg_el_ib"..ei,_elsX+1,boxY+1,_elsW-2,19,3,MAIN_D,95,a)
                    local val=self.Flags[el.Id] or""
                    local maxW=_elsW-14
                    local disp,txtCol
                    if val=="" and not foc then disp=truncFit(el.PH or"",14,maxW); txtCol=DESC_D
                    elseif foc then disp=tailFit(val,14,maxW-8)..(floor(_tick*2)%2==0 and"|"or""); txtCol=FNT_D
                    else disp=truncFit(val,14,maxW); txtCol=FNT_D end
                    self:D("dlg_el_ix"..ei,"Text",{Text=disp,Size=14,Font=FNT_ID,Color=txtCol,Transparency=a,ZIndex=96,Position=v2(_elsX+8,boxY+4)})
                    if hov and I.Click and not foc then
                        S.FocusInput=el; el._pre=self.Flags[el.Id]
                        if el.ClearOnFocus then self.Flags[el.Id]="" end
                    end
                    _elsY=_elsY+(hasTx and 39 or 21)+_elGap
                elseif el.Ty=="Tgl" or el.Ty=="Chk" then
                    local on=el.Value
                    local hov=inB(_elsX,_elsY,_elsW,18)
                    if hov and I.Click then
                        el.Value=not on; on=el.Value
                        self.Flags[el.Id]=on
                        if el.Cb then el.Cb(on) end
                    end
                    if el.Ty=="Tgl" then
                        local swW,swH=32,18; local swX=_elsX+_elsW-swW
                        self:Pill("dlg_el_tso"..ei,swX,_elsY,swW,swH,on and ACCENT or OL_D,94,a)
                        self:Pill("dlg_el_ts"..ei,swX+1,_elsY+1,swW-2,swH-2,on and ACCENT or MAIN_D,95,a)
                        local ballX=on and(swX+swW-3-6) or(swX+3+6)
                        self:D("dlg_el_tb"..ei,"Circle",{Filled=true,Color=FNT_D,Radius=6,NumSides=16,Transparency=a,ZIndex=96,Position=v2(ballX,_elsY+9)})
                        self:D("dlg_el_tt"..ei,"Text",{Text=el.Tx or"",Size=14,Font=FNT_ID,Color=FNT_D,Transparency=(on and 1 or 0.6)*a,ZIndex=94,Position=v2(_elsX,_elsY+2)})
                    else
                        self:RR("dlg_el_co"..ei,_elsX,_elsY,18,18,4,on and ACCENT or OL_D,94,a)
                        self:RR("dlg_el_cb"..ei,_elsX+1,_elsY+1,16,16,3,on and ACCENT or MAIN_D,95,a)
                        if on then
                            self:D("dlg_el_c1"..ei,"Line",{Thickness=2,Color=FNT_D,Transparency=a,ZIndex=96,From=v2(_elsX+4,_elsY+9),To=v2(_elsX+7,_elsY+13)})
                            self:D("dlg_el_c2"..ei,"Line",{Thickness=2,Color=FNT_D,Transparency=a,ZIndex=96,From=v2(_elsX+7,_elsY+13),To=v2(_elsX+14,_elsY+5)})
                        else
                            self:D("dlg_el_c1"..ei,"Line",{Visible=false})
                            self:D("dlg_el_c2"..ei,"Line",{Visible=false})
                        end
                        self:D("dlg_el_ct"..ei,"Text",{Text=el.Tx or"",Size=14,Font=FNT_ID,Color=FNT_D,Transparency=(on and 1 or 0.6)*a,ZIndex=94,Position=v2(_elsX+26,_elsY+2)})
                    end
                    _elsY=_elsY+18+_elGap
                end
            end

            if #d.Btns>0 then
                self:D("dlg_sep","Square",{Filled=true,Color=OL_D,Transparency=a,ZIndex=94,Position=v2(dX+1,dY+sdH-footerH-4),Size=v2(sdW-2,1)})
            else self:D("dlg_sep","Square",{Visible=false}) end

            local btnY=dY+sdH-padding-btnH+8
            local btnX=dX+sdW-padding
            local dlgTick=_tick
            for bi=#d.Btns,1,-1 do
                local btn=d.Btns[bi]
                local waitLocked=btn.WaitTime>0 and(dlgTick-btn._startTick<btn.WaitTime)
                local dis=btn.Disabled or waitLocked
                local btnTitle=btn.Title
                if waitLocked then local rem=ceil(btn.WaitTime-(dlgTick-btn._startTick)); btnTitle=btnTitle.." ("..rem.."s)" end
                local btnW2=max(tw(btnTitle,14)+36,90)
                btnX=btnX-btnW2
                local bHov=not dis and inB(btnX,btnY,btnW2,btnH)
                local bgC,txC,olC
                if btn.Variant=="Primary" then bgC=COL.DLG_PRI; txC=FNT_D; olC=COL.DLG_PRI_OL
                elseif btn.Variant=="Destructive" then bgC=COL.DLG_DEL; txC=FNT_D; olC=COL.DLG_DEL_OL
                elseif btn.Variant=="Ghost" then bgC=BG2_D; txC=FNT_D; olC=OL_D
                else bgC=MAIN_D; txC=FNT_D; olC=OL2_D end
                if bHov then local r=min(bgC.R*255+20,255); local g=min(bgC.G*255+20,255); local b=min(bgC.B*255+20,255); bgC=rgb(r,g,b) end
                local alpha=(dis and 0.4 or 1)*a
                self:RR("dlg_bo"..bi,btnX,btnY,btnW2,btnH,4,olC,93,alpha)
                self:RR("dlg_bb"..bi,btnX+1,btnY+1,btnW2-2,btnH-2,3,bgC,94,alpha)
                if waitLocked then
                    local prog=clamp((dlgTick-btn._startTick)/btn.WaitTime,0,1)
                    local fillW=floor(prog*(btnW2-2))
                    if fillW>=1 then self:D("dlg_bp"..bi,"Square",{Filled=true,Color=bgC,Transparency=0.6*a,ZIndex=94,Position=v2(btnX+1,btnY+1),Size=v2(fillW,btnH-2)})
                    else self:D("dlg_bp"..bi,"Square",{Visible=false}) end
                else self:D("dlg_bp"..bi,"Square",{Visible=false}) end
                self:D("dlg_bt"..bi,"Text",{Text=btnTitle,Size=14,Font=FNT_ID,Color=txC,Transparency=alpha,Center=true,ZIndex=95,Position=v2(btnX+btnW2/2,btnY+16)})

                if bHov and I.Click and not dis and d.Alive then
                    if btn.Callback then btn.Callback(d._interface) end
                    if d.AutoDismiss then d.Alive=false; d._dismissTick=_tick end
                end
                btnX=btnX-10
            end
        end
    end

    if self.Flags.Watermark then
        local title=(self.Window and self.Window.Title) or"obsidian"
        local pingV=0; pcall(function() if GetPingValue then pingV=floor(GetPingValue()) end end)
        local hh,mm=0,0; pcall(function() local t=os.date("*t"); hh=t.hour; mm=t.min end)
        local timeStr=format("%02d:%02d",hh,mm)
        local fS=14; local wmH=28; local padX=12; local sepGap=12
        local segs={title}
        if pingV>0 then segs[#segs+1]=pingV.."ms" end
        segs[#segs+1]=timeStr
        local segW={}; local total=0
        for i,sg in ipairs(segs) do local w=tw(sg,fS); segW[i]=w; total=total+w end
        total=total+(#segs-1)*sepGap
        local wmW=ceil(total+padX*2+6)
        local wmX=S.WMPos.X; local wmY=S.WMPos.Y
        if S.Open and I.Down and not S.WMDrag and inB(wmX,wmY,wmW,wmH) then S.WMDrag=true; S.WMDragOff=v2(I.MX-wmX,I.MY-wmY) end
        if not I.Down then S.WMDrag=false end
        if S.WMDrag then S.WMPos=v2(floor(I.MX-S.WMDragOff.X),floor(I.MY-S.WMDragOff.Y)); wmX=S.WMPos.X; wmY=S.WMPos.Y end
        self:RR("wm_dk",wmX-1,wmY-1,wmW+2,wmH+2,5,COL.SHADOW,84)
        self:RR("wm_ol",wmX,wmY,wmW,wmH,4,COL.OUTLINE,85)
        self:RR("wm_bg",wmX+1,wmY+1,wmW-2,wmH-2,3,COL.BG,86)
        self:D("wm_acc","Square",{Filled=true,Color=COL.ACCENT,ZIndex=87,Position=v2(wmX+2,wmY+2),Size=v2(3,wmH-4)})
        local curX=wmX+padX+4
        for i,sg in ipairs(segs) do
            local col=(i==1) and COL.FONT or COL.FONT50
            self:D("wm_t"..i,"Text",{Text=sg,Size=fS,Font=FNT_ID,Color=col,ZIndex=87,Position=v2(curX,wmY+7)})
            curX=curX+segW[i]
            if i<#segs then
                self:D("wm_s"..i,"Square",{Filled=true,Color=COL.OUTLINE,ZIndex=87,Position=v2(curX+sepGap/2-1,wmY+7),Size=v2(1,wmH-14)})
                curX=curX+sepGap
            else self:D("wm_s"..i,"Square",{Visible=false}) end
        end
        for i=#segs+1,6 do self:D("wm_t"..i,"Text",{Visible=false}); self:D("wm_v"..i,"Text",{Visible=false}); self:D("wm_s"..i,"Square",{Visible=false}) end
    end

    for di=#self.DraggableLabels,1,-1 do
        local dl=self.DraggableLabels[di]; local did="dl"..dl._id
        if not dl._alive then
            self:HideRR(did.."dk"); self:HideRR(did.."ol"); self:HideRR(did.."bg")
            self:D(did.."acc","Square",{Visible=false}); self:D(did.."tt","Text",{Visible=false}); self:D(did.."tx","Text",{Visible=false})
            remove(self.DraggableLabels,di)
        elseif dl.Visible then
            local fS=13; local padX=10; local padY=6
            local hasTitle=dl.Title and dl.Title~=""
            local hasText=dl.Text and dl.Text~=""
            local titleW=hasTitle and tw(dl.Title,fS) or 0
            local textW=hasText and tw(dl.Text,fS) or 0
            local contentW=max(titleW,textW)
            local dlW=max(80,ceil(contentW+padX*2))
            local dlH=padY*2+(hasTitle and 16 or 0)+(hasText and 16 or 0)
            if hasTitle and hasText then dlH=dlH+2 end
            local dlX,dlY=dl.Pos.X,dl.Pos.Y
            if S.Open and I.Click and not S.DraggingLabel and inB(dlX,dlY,dlW,dlH) then dl._drag=true; dl._dragOff=v2(I.MX-dlX,I.MY-dlY); S.DraggingLabel=dl end
            if not I.Down then dl._drag=false; if S.DraggingLabel==dl then S.DraggingLabel=nil end end
            if dl._drag then dl.Pos=v2(floor(I.MX-dl._dragOff.X),floor(I.MY-dl._dragOff.Y)); dlX=dl.Pos.X; dlY=dl.Pos.Y end
            self:RR(did.."dk",dlX-1,dlY-1,dlW+2,dlH+2,5,COL.SHADOW,84)
            self:RR(did.."ol",dlX,dlY,dlW,dlH,4,COL.OUTLINE,85)
            self:RR(did.."bg",dlX+1,dlY+1,dlW-2,dlH-2,3,COL.BG,86)
            self:D(did.."acc","Square",{Filled=true,Color=dl.Color or COL.ACCENT,ZIndex=87,Position=v2(dlX+2,dlY+2),Size=v2(3,dlH-4)})
            local curY2=dlY+padY
            if hasTitle then
                self:D(did.."tt","Text",{Text=dl.Title,Size=fS,Font=FNT_ID,Color=COL.FONT,ZIndex=87,Position=v2(dlX+padX+4,curY2)})
                curY2=curY2+16+(hasText and 2 or 0)
            else self:D(did.."tt","Text",{Visible=false}) end
            if hasText then
                self:D(did.."tx","Text",{Text=dl.Text,Size=fS,Font=FNT_ID,Color=COL.FONT50,ZIndex=87,Position=v2(dlX+padX+4,curY2)})
            else self:D(did.."tx","Text",{Visible=false}) end
        else
            self:HideRR(did.."dk"); self:HideRR(did.."ol"); self:HideRR(did.."bg")
            self:D(did.."acc","Square",{Visible=false}); self:D(did.."tt","Text",{Visible=false}); self:D(did.."tx","Text",{Visible=false})
        end
    end

    if self.Flags.Crosshair then
        local cx,cy=I.MX,I.MY
        local sz=self.Flags.CrosshairSize or 10
        local gp=self.Flags.CrosshairGap or 4
        local th=self.Flags.CrosshairThickness or 1
        local col=self.Flags.CrosshairColor or COL.FONT
        local outline=self.Flags.CrosshairOutline
        local shape=self.Flags.CrosshairShape or"Cross"
        local olCol=COL.SHADOW; local olTh=th+2
        local doRot=self.Flags.CrosshairRotation
        local rpm=self.Flags.CrosshairRotationSpeed or 90
        local xhNow=_tick
        if not S._xhAngle then S._xhAngle=0; S._xhLastTick=xhNow end
        local xhDt=xhNow-S._xhLastTick; S._xhLastTick=xhNow
        if doRot then S._xhAngle=S._xhAngle+(rpm*6)*xhDt else S._xhAngle=0 end
        local rad6=rad(S._xhAngle)
        local cs,sn=cos(rad6),sin(rad6)
        local function rot(px,py) local dx,dy=px-cx,py-cy; return cx+dx*cs-dy*sn,cy+dx*sn+dy*cs end
        for i=1,4 do self:D("xh_l"..i,"Line",{Visible=false}); self:D("xh_lo"..i,"Line",{Visible=false}) end
        self:D("xh_d","Circle",{Visible=false}); self:D("xh_do","Circle",{Visible=false})
        self:D("xh_c","Circle",{Visible=false}); self:D("xh_co","Circle",{Visible=false})
        if shape=="Cross" or shape=="Plus" or shape=="T" then
            local lines={}
            if shape=="Cross" then
                lines={{cx-gp-sz,cy,cx-gp,cy},{cx+gp,cy,cx+gp+sz,cy},{cx,cy-gp-sz,cx,cy-gp},{cx,cy+gp,cx,cy+gp+sz}}
            elseif shape=="Plus" then
                lines={{cx-sz,cy,cx-gp,cy},{cx+gp,cy,cx+sz,cy},{cx,cy-sz,cx,cy-gp},{cx,cy+gp,cx,cy+sz}}
            elseif shape=="T" then
                lines={{cx-gp-sz,cy,cx-gp,cy},{cx+gp,cy,cx+gp+sz,cy},{cx,cy+gp,cx,cy+gp+sz}}
            end
            for i,L in ipairs(lines) do
                local x1,y1=rot(L[1],L[2]); local x2,y2=rot(L[3],L[4])
                if outline then self:D("xh_lo"..i,"Line",{Visible=true,Color=olCol,Thickness=olTh,ZIndex=200,From=v2(x1,y1),To=v2(x2,y2)}) end
                self:D("xh_l"..i,"Line",{Visible=true,Color=col,Thickness=th,ZIndex=201,From=v2(x1,y1),To=v2(x2,y2)})
            end
        elseif shape=="Dot" then
            if outline then self:D("xh_do","Circle",{Visible=true,Filled=true,Color=olCol,Radius=sz+1,NumSides=20,ZIndex=200,Position=v2(cx,cy)}) end
            self:D("xh_d","Circle",{Visible=true,Filled=true,Color=col,Radius=sz,NumSides=20,ZIndex=201,Position=v2(cx,cy)})
        elseif shape=="Circle" then
            if outline then self:D("xh_co","Circle",{Visible=true,Filled=false,Color=olCol,Thickness=th+2,Radius=sz+1,NumSides=24,ZIndex=200,Position=v2(cx,cy)}) end
            self:D("xh_c","Circle",{Visible=true,Filled=false,Color=col,Thickness=th,Radius=sz,NumSides=24,ZIndex=201,Position=v2(cx,cy)})
        end
    else
        for i=1,4 do self:D("xh_l"..i,"Line",{Visible=false}); self:D("xh_lo"..i,"Line",{Visible=false}) end
        self:D("xh_d","Circle",{Visible=false}); self:D("xh_do","Circle",{Visible=false})
        self:D("xh_c","Circle",{Visible=false}); self:D("xh_co","Circle",{Visible=false})
    end

    if self.Flags.KeybindMenuOpen then
        local entries={}
        local menuKeyName=VK[S.ToggleKey] or"None"
        entries[#entries+1]={Name="Menu",Key=menuKeyName,On=S.Open,IsMenu=true}
        for id,kb in pairs(Keybinds) do
            if not kb.NoUI and kb.Key then
                local pid=kb.ParentId or id
                local nm=(Toggles[pid] and Toggles[pid].Tx) or kb.EN or id
                entries[#entries+1]={Name=nm,Key=kb.Name or"?",On=type(Flags[pid])=="boolean" and Flags[pid],kb=kb}
            end
        end
        sort(entries,function(a,b) if a.IsMenu then return true elseif b.IsMenu then return false end; return a.Name<b.Name end)

        local function _entryKTx(e)
            local s="["..e.Key.."]"
            if e.kb and e.kb.Modes and #e.kb.Modes>1 and e.kb._modeShownTick and _tick-e.kb._modeShownTick<=5 then
                s=s.." ["..(e.kb.Mode and sub(e.kb.Mode,1,1) or"T").."]"
            end
            return s
        end
        local hdrH=22; local rowH=16; local padX=10; local padY=6; local fS=13
        local IBG,IMAIN,IOL,IFNT=COL.BG,COL.MAIN,COL.OUTLINE,COL.FONT
        local IDIM,IACC=COL.FONT50,COL.ACCENT
        local nameMax,keyMax=0,0
        for _,e in ipairs(entries) do
            local nw=tw(e.Name,fS); if nw>nameMax then nameMax=nw end
            local kw=tw(_entryKTx(e),fS); if kw>keyMax then keyMax=kw end
        end
        local titleW=tw("Keybinds",fS)
        local contentW=max(titleW,nameMax+keyMax+18)
        local iW=max(160,ceil(contentW+padX*2))
        local iH=hdrH+padY+(#entries*rowH)+padY
        if not S.IndPos then
            local vpy=800; pcall(function() vpy=workspace.CurrentCamera.ViewportSize.Y end)
            S.IndPos=v2(20,floor((vpy-iH)/2))
        end
        local iX,iY=S.IndPos.X,S.IndPos.Y
        if S.Open and I.Down and not S.IndDrag and inB(iX,iY,iW,hdrH) then S.IndDrag=true; S.IndDragOff=v2(I.MX-iX,I.MY-iY) end
        if not I.Down then S.IndDrag=false end
        if S.IndDrag then S.IndPos=v2(floor(I.MX-S.IndDragOff.X),floor(I.MY-S.IndDragOff.Y)); iX=S.IndPos.X; iY=S.IndPos.Y end
        self:RR("ind_dk",iX-1,iY-1,iW+2,iH+2,5,COL.SHADOW,85)
        self:RR("ind_ol",iX,iY,iW,iH,4,IOL,86)
        self:RR("ind_bg",iX+1,iY+1,iW-2,iH-2,3,IBG,87)
        self:D("ind_acc","Square",{Filled=true,Color=IACC,ZIndex=88,Position=v2(iX+1,iY+1),Size=v2(iW-2,2)})
        self:D("ind_t","Text",{Text="Keybinds",Size=fS,Font=FNT_ID,Color=IFNT,Center=true,ZIndex=89,Position=v2(iX+iW/2,iY+13)})
        self:D("ind_s","Square",{Filled=true,Color=IOL,ZIndex=88,Position=v2(iX+padX,iY+hdrH),Size=v2(iW-padX*2,1)})
        for i=1,40 do local e=entries[i]
            if e then
                local ey=iY+hdrH+padY+((i-1)*rowH)
                local nameCol=e.On and IFNT or IDIM
                local keyCol=e.On and IFNT or IDIM
                self:D("ind_n"..i,"Text",{Text=e.Name,Size=fS,Font=FNT_ID,Color=nameCol,ZIndex=89,Position=v2(iX+padX,ey)})
                local kTx=_entryKTx(e)
                self:D("ind_k"..i,"Text",{Text=kTx,Size=fS,Font=FNT_ID,Color=keyCol,ZIndex=89,Position=v2(iX+iW-padX-tw(kTx,fS),ey)})
            else
                self:D("ind_n"..i,"Text",{Visible=false}); self:D("ind_k"..i,"Text",{Visible=false})
            end
        end
        self:D("ind_e","Text",{Visible=false})
    end

    local _gcTk=self.State.Tick; for _,c in pairs(self.Drawings) do if c.Tk~=_gcTk and c.P.Visible then c.O.Visible=false; c.P.Visible=false end end
    I.Prev=I.Down; I.RPrev=I.RDown
    self:_FireHook("Step",self)
end

function Library:CreateLoading(cfg)
    cfg=cfg or{}
    local L={
        Title=cfg.Title or"mspaint",
        Icon=cfg.Icon,_iconData=nil,
        Message="",Description="",
        Step=cfg.CurrentStep or 0,Total=cfg.TotalSteps or 10,
        W=cfg.WindowWidth or 450,H=cfg.WindowHeight or 275,
        CR=self.Window and self.Window.CR or 4,
        Alive=true,Angle=0,
        TweenTime=cfg.LoadingIconTweenTime or 1,
        SmoothStep=0,
    }
    if cfg.LoadingIcon then pcall(function() L._loadIcon=game:HttpGet(cfg.LoadingIcon) end) end
    L.Pos=v2(100,100)
    pcall(function() local vp=workspace.CurrentCamera.ViewportSize; L.Pos=v2(floor((vp.X-L.W)/2),floor((vp.Y-L.H)/2)) end)
    self._loading=L
    self.State.Open=false

    local LI={}
    function LI:SetMessage(t) L.Message=t end
    function LI:SetDescription(t) L.Description=t end
    function LI:SetCurrentStep(n) L.Step=n end
    function LI:SetTotalSteps(n) L.Total=n end
    function LI:Destroy() L.Alive=false; Library._loading=nil; for _,c in pairs(Library.Drawings) do if c.P.Visible then c.O.Visible=false; c.P.Visible=false end end; Library.State.Open=true end
    function LI:Continue() self:Destroy() end
    return LI
end

function Library:_StepLoading()
    local L=self._loading; if not L or not L.Alive then return end
    local S,I=self.State,self.Input; S.Tick=S.Tick+1
    local mx,my=50,50; I.MX=mx; I.MY=my; _imx=mx; _imy=my
    I.Down=input.is_mouse_down(1); I.Click=I.Down and not I.Prev
    local BG,BG_DK,MAIN=COL.BG,COL.BG_DK,COL.MAIN
    local OL,ACC,FNT=COL.OUTLINE,COL.ACCENT,COL.FONT
    local FNT50,SHADOW=COL.FONT50,COL.SHADOW
    local R=L.CR; local R2=max(floor(R/2),0); local R2inner=max(R2-1,0)
    pcall(function() local vp=workspace.CurrentCamera.ViewportSize; if vp.X>0 and vp.Y>0 then L.Pos=v2(floor((vp.X-L.W)/2),floor((vp.Y-L.H)/2)) end end)
    local px,py,w,h=L.Pos.X,L.Pos.Y,L.W,L.H; local ct=os.clock()

    self:RR("ld_dk",px-1,py-1,w+2,h+2,R+1,SHADOW,58)
    self:RR("ld_ol",px,py,w,h,R,OL,59)
    self:RR("ld_bg",px+1,py+1,w-2,h-2,max(R-1,0),BG_DK,60)

    self:D("ld_hsep","Square",{Filled=true,Color=OL,ZIndex=61,Position=v2(px+1,py+48),Size=v2(w-2,1)})
    self:D("ld_tit","Text",{Text=L.Title,Size=20,Font=FNT_ID,Color=FNT,ZIndex=62,Position=v2(px+16,py+14)})

    local cx,cy=px+w/2,py+48+(h-48-80)/2+20
    local iconR=22; local numSegs=24; local arcLen=18
    local now=os.clock(); local dt=now-(L.LastTick or now); L.LastTick=now
    if L.TweenTime>0 then L.Angle=(L.Angle+dt*(360/L.TweenTime))%360 end
    for i=1,numSegs do
        local a1=rad(L.Angle+(i-1)*(360/numSegs))
        local a2=rad(L.Angle+i*(360/numSegs))
        local x1,y1=cx+cos(a1)*iconR,cy+sin(a1)*iconR
        local x2,y2=cx+cos(a2)*iconR,cy+sin(a2)*iconR
        self:D("ld_bg2"..i,"Line",{Color=OL,Thickness=2.5,ZIndex=61,From=v2(x1,y1),To=v2(x2,y2)})
    end
    for i=1,numSegs do
        local a1=rad(L.Angle+(i-1)*(360/numSegs))
        local a2=rad(L.Angle+i*(360/numSegs))
        local x1,y1=cx+cos(a1)*iconR,cy+sin(a1)*iconR
        local x2,y2=cx+cos(a2)*iconR,cy+sin(a2)*iconR
        local alpha=0
        if i<=arcLen then alpha=(i/arcLen) end
        if alpha>0.02 then
            self:D("ld_seg"..i,"Line",{Color=ACC,Thickness=2.5,ZIndex=62,Transparency=alpha,From=v2(x1,y1),To=v2(x2,y2)})
        else
            self:D("ld_seg"..i,"Line",{Visible=false})
        end
    end

    local msgY=cy+iconR+30
    self:D("ld_msg","Text",{Text=L.Message,Size=16,Font=FNT_ID,Color=FNT,Center=true,ZIndex=62,Position=v2(px+w/2,msgY)})
    self:D("ld_desc","Text",{Text=L.Description,Size=13,Font=FNT_ID,Color=FNT50,Center=true,ZIndex=62,Position=v2(px+w/2,msgY+22)})

    local target=L.Total>0 and clamp(L.Step/L.Total,0,1) or 0
    L.SmoothStep=L.SmoothStep+(target-L.SmoothStep)*clamp(dt*8,0,1)
    if abs(L.SmoothStep-target)<0.002 then L.SmoothStep=target end
    local barPad=30; local barH=8; local barY=py+h-30; local barW=w-barPad*2
    self:RR("ld_pbb",px+barPad,barY,barW,barH,R2,MAIN,61)
    self:D("ld_pbo","Square",{Filled=false,Color=OL,Thickness=1,ZIndex=61,Position=v2(px+barPad,barY),Size=v2(barW,barH)})
    local fillW=max(L.SmoothStep*(barW-2),0)
    if fillW>1 then self:RR("ld_pbf",px+barPad+1,barY+1,fillW,barH-2,R2inner,ACC,62) else self:RR("ld_pbf",px+barPad+1,barY+1,1,barH-2,0,ACC,62) end
    self:D("ld_stp","Text",{Text=tostring(L.Step).."/"..tostring(L.Total),Size=13,Font=FNT_ID,Color=FNT50,Center=true,ZIndex=62,Position=v2(px+w/2,barY-14)})

    for _,c in pairs(self.Drawings) do if c.Tk~=S.Tick and c.P.Visible then c.O.Visible=false; c.P.Visible=false end end
    I.Prev=I.Down
end

function Library:Notify(info)
    if type(info)=="string" then info={Description=info} end
    info=info or{}
    local defaultTitle=self.Window and self.Window.Title or nil
    local n={
        Title=info.Title~=nil and info.Title or defaultTitle,
        Desc=info.Description or"",
        Time=info.Time or info.Duration or 5,
        Steps=info.Steps,
        Persist=info.Persist,
        Color=info.Color,
        St=os.clock(),
        Destroyed=false,
        _step=0,
    }
    local NI={}
    function NI:ChangeTitle(t) n.Title=t end
    function NI:ChangeDescription(t) n.Desc=t end
    function NI:ChangeStep(s) n._step=clamp(s,0,n.Steps or 1) end
    function NI:Destroy() n.Destroyed=true; n._destroyTick=os.clock() end
    function NI:DestroyAfter(t) n._destroyAt=os.clock()+t end
    self.Notifications[#self.Notifications+1]=n
    return NI
end
function Library:SetWatermark(v) v=v and true or false; self.Flags.Watermark=v; if self.Toggles.Watermark then self.Toggles.Watermark.Value=v end end
function Library:OnUnload(fn) self._onUnload=self._onUnload or{}; self._onUnload[#self._onUnload+1]=fn end
function Library:SetFont(n) FNT_ID=tonumber(n) or 5; self.Font=FNT_ID end
function Library:AddDraggableLabel(cfg)
    cfg=cfg or{}
    local dl={
        Id=cfg.Id,Title=cfg.Title,Text=cfg.Text or"",
        Pos=cfg.Position or v2(20,60),
        Visible=cfg.Visible~=false,
        Color=cfg.Color,
        _drag=false,_dragOff=v2(0,0),
        _id=#self.DraggableLabels+1,
        _alive=true,
    }
    self.DraggableLabels[#self.DraggableLabels+1]=dl
    local DI={}
    function DI:SetTitle(t) dl.Title=t end
    function DI:SetText(t) dl.Text=t end
    function DI:SetPosition(p) dl.Pos=p end
    function DI:GetPosition() return dl.Pos end
    function DI:SetVisible(v) dl.Visible=v end
    function DI:IsVisible() return dl.Visible end
    function DI:Destroy() dl._alive=false end
    return DI
end

function Library:_ThemeFolder()
    pcall(makefolder,"ObsidianLib")
    pcall(makefolder,"ObsidianLib/themes")
    return "ObsidianLib/themes"
end
function Library:SetTheme(t)
    if not self.Theme then self.Theme={} end
    if t.BackgroundColor then local b=t.BackgroundColor
        COL.BG=b; COL.BG_DK=shade(b,-2); COL.BG_LT=shade(b,2)
        COL.HOV20=shade(b,5); COL.HOV22=shade(b,7); COL.BOT=shade(b,8)
        COL.DD18=shade(b,3); COL.DEP18=shade(b,3)
        COL.BG_TP=shade(b,5); COL.N_BG=shade(b,5)
        COL.BG_D=shade(b,3); COL.BG2_D=shade(b,7)
        COL.N_TB=shade(b,-3)
        self.Theme.BackgroundColor=b
    end
    if t.MainColor then local m=t.MainColor
        COL.MAIN=m; COL.MAIN_D=shade(m,7)
        self.Theme.MainColor=m
    end
    if t.AccentColor then local a=t.AccentColor
        COL.ACCENT=a; COL.N_ACC=a; COL.DLG_PRI=a; COL.DLG_PRI_OL=shade(a,-30)
        self.Theme.AccentColor=a
    end
    if t.OutlineColor then local o=t.OutlineColor
        COL.OUTLINE=o; COL.OL_D=shade(o,5); COL.OL2_D=shade(o,15)
        COL.OL_TP=shade(o,5); COL.N_OL=shade(o,5)
        self.Theme.OutlineColor=o
    end
    if t.FontColor then local f=t.FontColor
        COL.FONT=f; COL.FONT50=scale(f,0.5); COL.FONT40=scale(f,0.6)
        COL.FNT_D=f; COL.FNT_TP=f; COL.N_FNT=f
        self.Theme.FontColor=f
    end
end
function Library:GetTheme() return self.Theme end
function Library:SaveTheme(name)
    local f=self:_ThemeFolder()
    local data={}
    for k,v in pairs(self.Theme or{}) do
        if typeof(v)=="Color3" then
            data[k]=format("%02x%02x%02x",floor(v.R*255),floor(v.G*255),floor(v.B*255))
        end
    end
    local ok,j=pcall(function() return HttpService:JSONEncode(data) end)
    if ok then pcall(writefile,f.."/"..name..".json",j); return true end
    return false
end
function Library:LoadTheme(name)
    local f=self:_ThemeFolder()
    local ok,raw=pcall(readfile,f.."/"..name..".json")
    if not ok or not raw then return false end
    local ok2,data=pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(data)~="table" then return false end
    local theme={}
    for k,v in pairs(data) do
        if type(v)=="string" and #v==6 then
            local r=tonumber(v:sub(1,2),16); local g=tonumber(v:sub(3,4),16); local b=tonumber(v:sub(5,6),16)
            if r and g and b then theme[k]=rgb(r,g,b) end
        end
    end
    self:SetTheme(theme)
    return true
end
function Library:DeleteTheme(name)
    local f=self:_ThemeFolder()
    pcall(delfile,f.."/"..name..".json")
end
function Library:ListThemes()
    local f=self:_ThemeFolder()
    local out={}
    local ok,files=pcall(listfiles,f)
    if ok and files then for _,fp in ipairs(files) do
        local n=match(fp,"([^/\\]+)%.json$")
        if n then out[#out+1]=n end
    end end
    return out
end

function Library:Dialog(info)
    info=info or{}
    local d={
        Title=info.Title or"Dialog",
        Desc=info.Description or"Description",
        AutoDismiss=info.AutoDismiss~=false,
        OutsideDismiss=info.OutsideClickDismiss~=false,
        Buttons=info.FooterButtons or{},
        Alive=true,
        Scale=0.92,
        Alpha=0,
        StartTick=os.clock(),
        _justOpened=true,
    }
    local btns={}
    for k,b in pairs(d.Buttons) do
        btns[#btns+1]={
            Id=k, Title=b.Title or k, Variant=b.Variant or"Primary",
            Order=b.Order or 0, WaitTime=b.WaitTime or 0, Callback=b.Callback,
            Disabled=false, _startTick=os.clock()
        }
    end
    table.sort(btns,function(a,b) return(a.Order or 0)<(b.Order or 0) end)
    d.Btns=btns
    self.ActiveDialog=d
    local dummyTab={LG={},RG={},Name="_dlg"}
    local DI=self:_BuildGroup(dummyTab,"L","")
    d.Els=DI.Els
    function DI:SetTitle(t) d.Title=t end
    function DI:SetDescription(t) d.Desc=t end
    function DI:Dismiss() d.Alive=false; d._dismissTick=os.clock() end
    function DI:SetButtonDisabled(id,disabled) for _,b in ipairs(d.Btns) do if b.Id==id then b.Disabled=disabled; break end end end
    function DI:AddFooterButton(id,cfg) cfg=cfg or{}
        for i,b in ipairs(d.Btns) do if b.Id==id then remove(d.Btns,i); break end end
        d.Btns[#d.Btns+1]={Id=id,Title=cfg.Title or id,Variant=cfg.Variant or"Primary",Order=cfg.Order or 0,WaitTime=cfg.WaitTime or 0,Callback=cfg.Callback,Disabled=cfg.Disabled==true,_startTick=os.clock()}
        table.sort(d.Btns,function(a,b) return(a.Order or 0)<(b.Order or 0) end)
    end
    function DI:RemoveFooterButton(id)
        for i,b in ipairs(d.Btns) do if b.Id==id then remove(d.Btns,i); return end end
    end
    function DI:SetButtonOrder(id,order)
        for _,b in ipairs(d.Btns) do if b.Id==id then b.Order=order; break end end
        table.sort(d.Btns,function(a,b) return(a.Order or 0)<(b.Order or 0) end)
    end
    function DI:SetButtonWaitTime(id,t) for _,b in ipairs(d.Btns) do if b.Id==id then b.WaitTime=t; b._startTick=os.clock(); break end end end
    function DI:SetButtonTitle(id,t) for _,b in ipairs(d.Btns) do if b.Id==id then b.Title=t; break end end end
    function DI:GetValue(id) return Library.Flags[id] end
    d._interface=DI
    return DI
end

function Library:_BuildSettingsTab()
    if not self._WI or self._settingsBuilt then return end
    self._settingsBuilt=true
    local Settings=self._WI:AddTab("UI Settings","settings")
    local Menu=Settings:AddLeftGroupbox("Menu")
    Menu:AddToggle("KeybindMenuOpen",{Text="Open Keybind Menu",Default=false})
    Menu:AddToggle("Watermark",{Text="Show Watermark",Default=false})
    Menu:AddToggle("ColorWheel",{Text="Color Wheel",Default=true,Tooltip="Replace colorpickers with the color wheel"})
    Menu:AddToggle("InputClickThrough",{Text="Input Click-Through",Default=true,Tooltip="Clicking off a text box also activates whatever you clicked"})
    Menu:AddDropdown("BorderStyle",{Text="Border Style",Values={"Smooth","Sharp"},Default="Smooth"})
    Menu:AddToggle("ScrollbarAccountance",{Text="Scrollbar Accountance",Default=true})
    Menu:AddToggle("MCWrap",{Text="Multi Choice Wrap",Default=true,Tooltip="Wrap multiple-choice rows when items don't fit"})
    local fontMap={["UI"]=0,["System"]=1,["SystemBold"]=2,["Minecraft"]=4,["Monospace"]=5,["Pixel"]=7,["Fortnite"]=8}
    local fontDD=Menu:AddDropdown("UIFont",{Text="UI Font",Values={"UI","System","SystemBold","Minecraft","Monospace","Pixel","Fortnite"},Default="Monospace",Callback=function(v) self:SetFont(fontMap[v] or 5) end})
    fontDD.OptFonts=fontMap   -- per-option font preview, font picker only
    Menu:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind",{Default=VK[self.State.ToggleKey] or"Delete",Text="Menu Toggle",NoUI=true})
    Menu:AddDivider()
    Menu:AddButton({Text="Unload",Risky=true,DoubleClick=true,Tooltip="Fully unloads the UI. Double-click to confirm.",Func=function() self._unload=true end})
    local Cfg=Settings:AddRightGroupbox("Configuration")
    Cfg:AddInput("ConfigName",{Text="Config name",Placeholder="config name..."})
    Cfg:AddDropdown("ConfigList",{Text="Config list",Values=self:ListConfigs(),AllowNull=true})
    Cfg:AddDivider()
    Cfg:AddButton({Text="Create config",Func=function()
        local nm=self.Flags.ConfigName; if not nm or nm=="" then self:Notify("Please enter a config name"); return end
        if self:SaveConfig(nm) then self:Notify("Created config: "..nm); if self.Options.ConfigList then self.Options.ConfigList.Opts=self:ListConfigs() end
        else self:Notify("Failed to save config") end
    end})
    Cfg:AddButton({Text="Load config",Func=function()
        local nm=self.Flags.ConfigList; if not nm then self:Notify("Select a config first"); return end
        if self:LoadConfig(nm) then self:Notify("Loaded config: "..nm) else self:Notify("Failed to load config") end
    end})
    Cfg:AddButton({Text="Overwrite config",Risky=true,DoubleClick=true,Func=function()
        local nm=self.Flags.ConfigList; if not nm then self:Notify("Select a config first"); return end
        if self:SaveConfig(nm) then self:Notify("Overwrote config: "..nm) end
    end})
    Cfg:AddButton({Text="Delete config",Func=function()
        local nm=self.Flags.ConfigList; if not nm then self:Notify("Select a config first"); return end
        self:DeleteConfig(nm); self:Notify("Deleted config: "..nm)
        if self.Options.ConfigList then self.Options.ConfigList.Opts=self:ListConfigs() end
        self.Flags.ConfigList=nil
    end})
    Cfg:AddButton({Text="Refresh list",Func=function()
        if self.Options.ConfigList then self.Options.ConfigList.Opts=self:ListConfigs() end
        self:Notify("Refreshed config list")
    end})
    Cfg:AddButton({Text="Set as autoload",Func=function()
        local nm=self.Flags.ConfigList; if not nm then self:Notify("Select a config first"); return end
        self:SetAutoload(nm); self:Notify("Set autoload: "..nm)
        if self.Options.AutoloadLabel then self.Options.AutoloadLabel:SetText("Current autoload: "..nm) end
    end})
    Cfg:AddButton({Text="Reset autoload",Func=function()
        self:ResetAutoload(); self:Notify("Reset autoload")
        if self.Options.AutoloadLabel then self.Options.AutoloadLabel:SetText("Current autoload: none") end
    end})
    Cfg:AddLabel({Text="Current autoload: "..(self:GetAutoload() or"none"),Idx="AutoloadLabel"})

    if not self.Theme then self.Theme={BackgroundColor=rgb(15,15,15),MainColor=rgb(25,25,25),AccentColor=rgb(125,85,255),OutlineColor=rgb(40,40,40),FontColor=rgb(255,255,255)} end
    local Theme=Settings:AddRightGroupbox("Theme")
    Theme:AddColorPicker("ThemeBG",{Default=self.Theme.BackgroundColor,Text="Background",Callback=function(c) self:SetTheme({BackgroundColor=c}) end})
    Theme:AddColorPicker("ThemeMain",{Default=self.Theme.MainColor,Text="Main",Callback=function(c) self:SetTheme({MainColor=c}) end})
    Theme:AddColorPicker("ThemeAccent",{Default=self.Theme.AccentColor,Text="Accent",Callback=function(c) self:SetTheme({AccentColor=c}) end})
    Theme:AddColorPicker("ThemeOutline",{Default=self.Theme.OutlineColor,Text="Outline",Callback=function(c) self:SetTheme({OutlineColor=c}) end})
    Theme:AddColorPicker("ThemeFont",{Default=self.Theme.FontColor,Text="Font",Callback=function(c) self:SetTheme({FontColor=c}) end})
    Theme:AddDivider()
    Theme:AddInput("ThemeName",{Text="Theme name",Placeholder="theme name..."})
    Theme:AddDropdown("ThemeList",{Text="Theme list",Values=self:ListThemes(),AllowNull=true})
    Theme:AddButton({Text="Save theme",Func=function()
        local n=self.Flags.ThemeName; if not n or n=="" then self:Notify("Please enter a theme name"); return end
        if self:SaveTheme(n) then
            self:Notify("Saved theme: "..n)
            if self.Options.ThemeList then self.Options.ThemeList.Opts=self:ListThemes() end
        end
    end})
    Theme:AddButton({Text="Load theme",Func=function()
        local n=self.Flags.ThemeList; if not n then self:Notify("Select a theme first"); return end
        if self:LoadTheme(n) then
            self:Notify("Loaded theme: "..n)
            if self.Theme.BackgroundColor then self.Flags.ThemeBG=self.Theme.BackgroundColor end
            if self.Theme.MainColor then self.Flags.ThemeMain=self.Theme.MainColor end
            if self.Theme.AccentColor then self.Flags.ThemeAccent=self.Theme.AccentColor end
            if self.Theme.OutlineColor then self.Flags.ThemeOutline=self.Theme.OutlineColor end
            if self.Theme.FontColor then self.Flags.ThemeFont=self.Theme.FontColor end
        else self:Notify("Failed to load theme") end
    end})
    Theme:AddButton({Text="Delete theme",Func=function()
        local n=self.Flags.ThemeList; if not n then return end
        self:DeleteTheme(n); self:Notify("Deleted theme: "..n)
        if self.Options.ThemeList then self.Options.ThemeList.Opts=self:ListThemes() end
        self.Flags.ThemeList=nil
    end})
    Theme:AddButton({Text="Reset theme",Risky=true,DoubleClick=true,Func=function()
        local def={BackgroundColor=rgb(15,15,15),MainColor=rgb(25,25,25),AccentColor=rgb(125,85,255),OutlineColor=rgb(40,40,40),FontColor=rgb(255,255,255)}
        self:SetTheme(def)
        self.Flags.ThemeBG=def.BackgroundColor
        self.Flags.ThemeMain=def.MainColor
        self.Flags.ThemeAccent=def.AccentColor
        self.Flags.ThemeOutline=def.OutlineColor
        self.Flags.ThemeFont=def.FontColor
        self:Notify("Theme reset to default")
    end})

    local Cross=Settings:AddLeftGroupbox("Crosshair")
    Cross:AddToggle("Crosshair",{Text="Enable Crosshair",Default=false})
    Cross:AddDropdown("CrosshairShape",{Text="Shape",Values={"Cross","Plus","T","Dot","Circle"},Default="Cross"})
    Cross:AddSlider("CrosshairSize",{Text="Size",Default=10,Min=1,Max=40,Rounding=0})
    Cross:AddSlider("CrosshairGap",{Text="Gap",Default=4,Min=0,Max=20,Rounding=0})
    Cross:AddSlider("CrosshairThickness",{Text="Thickness",Default=1,Min=1,Max=6,Rounding=0})
    Cross:AddToggle("CrosshairOutline",{Text="Outline",Default=true}):AddColorPicker("CrosshairColor",{Default=Color3.fromRGB(255,255,255),Text="Color"})
    Cross:AddToggle("CrosshairRotation",{Text="Rotation",Default=false})
    local rotDep=Cross:AddDependencyBox()
    rotDep:AddSlider("CrosshairRotationSpeed",{Text="Rotation Speed",Default=90,Min=-360,Max=360,Rounding=0,Suffix=" rpm"})
    rotDep:SetupDependencies({{self.Toggles["CrosshairRotation"],true}})
end
function Library:Init() self._R=true
    if self.Window then self.Window._rzIcon=fetchIcon("move-diagonal-2"); self.Window._mvIcon=fetchIcon("move") end
    fetchIcon("wheel_ring")
    for _,a in pairs(self.Addons) do if a.Init then pcall(a.Init,self) end end
    self:_BuildSettingsTab()
    self:_BuildAddonTab()
    self:LoadAutoloadConfig()
    if self.Keybinds.MenuKeybind and self.Keybinds.MenuKeybind.Key then self.State.ToggleKey=self.Keybinds.MenuKeybind.Key end
    task.spawn(function()
        while self._R do
            if self._unload then self:Destroy(); break end
            if self._loading and self._loading.Alive then self:_StepLoading()
            else
                local alive=false; pcall(function() local p=Players.LocalPlayer; alive=(p and p:IsDescendantOf(game)) or false end)
                if not alive then self:Destroy(); break end
                self:Step()
            end
            task.wait(0)
        end
    end); return self end
function Library:Destroy() self:_FireHook("Destroy",self); if self._onUnload then for _,fn in ipairs(self._onUnload) do pcall(fn) end end; self._R=false; self._inputBlocked=false; pcall(setrobloxinput,true); for _,c in pairs(self.Drawings) do pcall(function() c.O:Remove() end) end; self.Drawings={} end

pcall(function() local old=_G.ObsidianLib; if old then old._R=false; if old.Destroy then old:Destroy() end end end)
_G.ObsidianLib = Library
