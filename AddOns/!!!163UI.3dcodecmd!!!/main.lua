local base_char,keywords=192,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
  function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[Ì e={
verbose=Ç,
info=Ç,
errro=Ó,
}
Ì É t(...)
Ê e.verbose Ò print("[verbose]",...)Æ
Æ
Ì É a(...)
Ê e.info Ò print("[verbose]",...)Æ
Æ
Ì É a(...)
Ê e.errro Ò print("[verbose]",...)Æ
Æ
É cmd3dcode_main_showlog(t,a)
Ê t==Í Ò t="verbose"Æ
Ê a==Í Ò a=Ó Æ
e[t]=a
Æ
Ê(LoggingChat())Ò
Ä
LoggingChat(1);
Æ
Ì e="3dcodecmd$Yin2"
Ì e="##########################\n"
.."# è¿™æ˜¯ç”±ç½‘æ˜“æœ‰çˆ±è‡ªåŠ¨åˆ›å»ºçš„å® #\n"
.."#                è¯·å‹¿åˆ é™¤ :)                   #\n"
.."##########################\n"
.."/run ThreeDimensionsCode_Savepipe_Yin()"
Ì e="3dcodecmd$Yang2"
Ì e="##########################\n"
.."# è¿™æ˜¯ç”±ç½‘æ˜“æœ‰çˆ±è‡ªåŠ¨åˆ›å»ºçš„å® #\n"
.."#                è¯·å‹¿åˆ é™¤ :)                   #\n"
.."##########################\n"
.."/run ThreeDimensionsCode_Savepipe_Yang()"
Ì É e(e,o,a)
Ê Î GetMacroBody(e)Ò
CreateMacro(e,"INV_MISC_QUESTIONMARK",o,Í)
t("create macro",e)
Ä
t("macro has already exists",e)
Æ
SetOverrideBindingMacro(ThreeDimensionsCode_Blackboard,Ó,a,e)
Æ
Ì i=0
Ì n=Ç
Ì e=GetNumAddOns()
Ì a=0
È e=1,GetNumAddOns()Ã
Ì o,o,o,t,o,o,o=GetAddOnInfo(e)
Ê t Á Î IsAddOnLoadOnDemand(e)Ò
a=a+1
Æ
Æ
Ì É o(t,a,e)
Ì e=CreateFrame("Button",a,UIParent,e)
e:SetFrameStrata("DIALOG")
e.t=e:CreateTexture()
e.t:SetTexture("Interface\\Buttons\\UI-CheckBox-Up")
e.t:SetAllPoints(e)
e.fontstring=e:CreateFontString()
e.fontstring:SetFontObject(GameFontNormalSmall)
e.fontstring:SetText(t)
e.fontstring:SetAllPoints(e)
e:SetClampRectInsets(-10,-10,-10,10)
e:SetSize(31,31)
e:Show()
e:SetScript("OnEnter",É()ChatFrame1Tab:GetScript("OnEnter")(ChatFrame1Tab)Æ)
e:SetScript("OnLeave",É()ChatFrame1Tab:GetScript("OnLeave")(ChatFrame1Tab)Æ)
Ñ e
Æ
Ì É e(...)
Æ
É Toggle3DCodeCmdChatFrameBtnShown()
Ê Î Cmd3DCode_Emoticon_ChatFrameButton Ï Î Cmd3DCode_Screenshot_ChatFrameButton Ò
Ñ
Æ
Ì e=Ó
Ê U1DB Á U1DB.configs Ò
Ê U1DB.configs["!!!163ui!!!/displayScrshotEmoticonBtn"]=="_NIL"Ï U1DB.configs["!!!163ui!!!/displayScrshotEmoticonBtn"]==Ç Ò
e=Ç
Æ
Æ
Ê Î e Ò
Cmd3DCode_Emoticon_ChatFrameButton:Hide()
Cmd3DCode_Screenshot_ChatFrameButton:Hide()
Ä
Cmd3DCode_Settings.em_locked=Í
Cmd3DCode_Emoticon_ChatFrameButton:Show()
Cmd3DCode_Screenshot_ChatFrameButton:Show()
Æ
Æ
Ì É u()
Ì e=o("è¡¨","Cmd3DCode_Emoticon_ChatFrameButton","Cmd3DCode_Emoticon_ChatFrameButtonTemplate")
Ì t=o("å›¾","Cmd3DCode_Screenshot_ChatFrameButton","Cmd3DCode_Screenshot_ChatFrameButtonTemplate")
Toggle3DCodeCmdChatFrameBtnShown()
CoreUIEnableTooltip(e,"è‡ªå®šä¹‰è¡¨æƒ…","å¯¼å…¥ä½ çš„ä¸“å±žè¡¨æƒ…åŒ…\næ‹–åŠ¨æ”¹å˜ä½ç½®\nCTRL+ç‚¹å‡»å¤ä½")
CoreUIEnableTooltip(t,"æœ‰çˆ±æˆªå›¾","åœ¨æ¸¸æˆå†…æˆªå›¾å¹¶å‘é€åˆ°èŠå¤©é¢‘é“")
CoreUIMakeMovable(e)
e:SetScript("OnClick",É(e)
Ê IsControlKeyDown()Ò
Cmd3DCode_Settings.em_locked=Î Cmd3DCode_Settings.em_locked
Ê Cmd3DCode_Settings.em_locked Ò
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(ChatFrame1Tab)
Cmd3DCode_Emoticon_ChatFrameButton:ClearAllPoints()
Cmd3DCode_Emoticon_ChatFrameButton:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT",8,9)
Æ
Å GetTime()~=e.stopMovingTime Ò
Ê Cmd3DCode_EmoticonFrame:IsVisible()Ò
Cmd3DCode_EmoticonFrame:Hide()
Ä
Cmd3DCode_EmoticonFrame:Show()
Æ
Æ
Æ)
hooksecurefunc(e,"StartMoving",É()
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(UIParent)
Cmd3DCode_Emoticon_ChatFrameButton:ClearAllPoints()
Cmd3DCode_Settings.em_locked=Ç
Æ)
hooksecurefunc(e,"StopMovingOrSizing",É(e)
e.stopMovingTime=GetTime()
Ì t,o,o,e,a=Cmd3DCode_Emoticon_ChatFrameButton:GetPoint()
Cmd3DCode_Settings.em_point=t
Cmd3DCode_Settings.em_x=e
Cmd3DCode_Settings.em_y=a
Æ)
Ê Cmd3DCode_Settings.em_locked==Í Ò Cmd3DCode_Settings.em_locked=Ó Æ
Ê Î Cmd3DCode_Settings.em_locked Á Cmd3DCode_Settings.em_point Ò
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(UIParent)
e:SetPoint(Cmd3DCode_Settings.em_point,UIParent,Cmd3DCode_Settings.em_point,Cmd3DCode_Settings.em_x,Cmd3DCode_Settings.em_y)
Ä
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(ChatFrame1Tab)
e:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT",8,9)
Æ
t:SetParent(e)
e:SetAlpha(.5)
t:SetPoint("RIGHT",e,"LEFT",8,0)
Æ
Ì r=Ç
Ì o=Ç
Ì h=0
Ì d=time()
Ì e=CreateFrame("frame","3DCodeCmdInit",UIParent)
e:SetFrameStrata("TOOLTIP")
e:SetFrameLevel(128)
e:EnableKeyboard(Ó)
e:SetPropagateKeyboardInput(Ó);
e.PropagateKeyboardInput=Ó
e:SetScript("OnKeyDown",É(a,t,...)
Ê IsAltKeyDown()Á(t=="PAGEUP"Ï t=="PAGEDOWN")Ò
Ê t=="PAGEDOWN"Ò
ThreeDimensionsCode_Savepipe_Yin()
Å t=="PAGEUP"Ò
ThreeDimensionsCode_Savepipe_Yang()
Æ
Å IsControlKeyDown()Á t=="PRINTSCREEN"Ò
Cmd3DCode_Screenshot_Start()
Ä
Ê Î e.PropagateKeyboardInput Ò
a:SetPropagateKeyboardInput(Ó)
Æ
Ñ
Æ
e.PropagateKeyboardInput=Ç
a:SetPropagateKeyboardInput(Ç)
Ñ Ç
Æ)
Ì l={}
Ì É s()
o=Ó
h=time()
e:SetScript("OnEvent",null)
Ê Î n Ò
threeDimensionsCodeFrames_create()
n=Ó
t("åˆ›å»º threeDimensionsCodeFrames_create()")
Æ
u()
È e=1,GetNumBindings()Ã
Ì e={select(2,GetBinding(e))}
È t,e Ë pairs(e)Ã
l[e]=1
Æ
Æ
Æ
e:RegisterEvent("ADDON_LOADED")
e:SetScript("OnEvent",É(h,n,e)
Ê n=="ADDON_LOADED"Á e:sub(1,9)~="Blizzard_"Ò
i=i+1
Æ
t(n,e,e:sub(1,9),i,a)
Ê i>=a Á Î o Ò
s()
Æ
Æ)
e:SetScript("OnUpdate",É(a,a)
Ê r Ò
t("proccessed")
Ñ
Æ
Ê time()-d>=3 Á Î o Ò
t("ç­‰å¾…æ‰€æœ‰æ’ä»¶åŠ è½½å®Œæˆè¶…æ—¶")
s()
Æ
Ê Î o Ò
Ñ
Æ
Ê UnitAffectingCombat("player")Ò
t("in combat, wait over")
Ñ
Æ
Ê time()-h>=0 Ò
DeleteMacro("3dcodecmd$Yin")
DeleteMacro("3dcodecmd$Yin2")
DeleteMacro("3dcodecmd$Yang")
DeleteMacro("3dcodecmd$Yang2")
ThreeDimensionsCode_SignalLamp.desireWidth();
r=Ó
e:SetScript("OnUpdate",Í)
Æ
Æ)
É cmd3dcode_test()
bigdatasendtest()
Æ
É bigdatasendtest()
Ì e=GetTime()
Ì t=string.rep("1",GetScreenWidth()*3+12)
print('make string:',GetTime()-e,#t)
e=GetTime()
ThreeDimensionsCode_Send("hi",t);
print('make frames',GetTime()-e)
Æ
É ThreeDimensionsCode_IsFramesCreated()
Ñ n
Æ
É ThreeDimensionsCode_Tell_AllAddOnsLoaded()
Ñ s()
Æ]===], '@../!!!163UI.3dcodecmd!!!/main.lua'))()