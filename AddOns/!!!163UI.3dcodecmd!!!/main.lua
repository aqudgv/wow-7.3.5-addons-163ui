local base_char,keywords=192,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
  function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[� e={
verbose=�,
info=�,
errro=�,
}
� � t(...)
� e.verbose � print("[verbose]",...)�
�
� � a(...)
� e.info � print("[verbose]",...)�
�
� � a(...)
� e.errro � print("[verbose]",...)�
�
� cmd3dcode_main_showlog(t,a)
� t==� � t="verbose"�
� a==� � a=� �
e[t]=a
�
�(LoggingChat())�
�
LoggingChat(1);
�
� e="3dcodecmd$Yin2"
� e="##########################\n"
.."# 这是由网易有爱自动创建的宏 #\n"
.."#                请勿删除 :)                   #\n"
.."##########################\n"
.."/run ThreeDimensionsCode_Savepipe_Yin()"
� e="3dcodecmd$Yang2"
� e="##########################\n"
.."# 这是由网易有爱自动创建的宏 #\n"
.."#                请勿删除 :)                   #\n"
.."##########################\n"
.."/run ThreeDimensionsCode_Savepipe_Yang()"
� � e(e,o,a)
� � GetMacroBody(e)�
CreateMacro(e,"INV_MISC_QUESTIONMARK",o,�)
t("create macro",e)
�
t("macro has already exists",e)
�
SetOverrideBindingMacro(ThreeDimensionsCode_Blackboard,�,a,e)
�
� i=0
� n=�
� e=GetNumAddOns()
� a=0
� e=1,GetNumAddOns()�
� o,o,o,t,o,o,o=GetAddOnInfo(e)
� t � � IsAddOnLoadOnDemand(e)�
a=a+1
�
�
� � o(t,a,e)
� e=CreateFrame("Button",a,UIParent,e)
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
e:SetScript("OnEnter",�()ChatFrame1Tab:GetScript("OnEnter")(ChatFrame1Tab)�)
e:SetScript("OnLeave",�()ChatFrame1Tab:GetScript("OnLeave")(ChatFrame1Tab)�)
� e
�
� � e(...)
�
� Toggle3DCodeCmdChatFrameBtnShown()
� � Cmd3DCode_Emoticon_ChatFrameButton � � Cmd3DCode_Screenshot_ChatFrameButton �
�
�
� e=�
� U1DB � U1DB.configs �
� U1DB.configs["!!!163ui!!!/displayScrshotEmoticonBtn"]=="_NIL"� U1DB.configs["!!!163ui!!!/displayScrshotEmoticonBtn"]==� �
e=�
�
�
� � e �
Cmd3DCode_Emoticon_ChatFrameButton:Hide()
Cmd3DCode_Screenshot_ChatFrameButton:Hide()
�
Cmd3DCode_Settings.em_locked=�
Cmd3DCode_Emoticon_ChatFrameButton:Show()
Cmd3DCode_Screenshot_ChatFrameButton:Show()
�
�
� � u()
� e=o("表","Cmd3DCode_Emoticon_ChatFrameButton","Cmd3DCode_Emoticon_ChatFrameButtonTemplate")
� t=o("图","Cmd3DCode_Screenshot_ChatFrameButton","Cmd3DCode_Screenshot_ChatFrameButtonTemplate")
Toggle3DCodeCmdChatFrameBtnShown()
CoreUIEnableTooltip(e,"自定义表情","导入你的专属表情包\n拖动改变位置\nCTRL+点击复位")
CoreUIEnableTooltip(t,"有爱截图","在游戏内截图并发送到聊天频道")
CoreUIMakeMovable(e)
e:SetScript("OnClick",�(e)
� IsControlKeyDown()�
Cmd3DCode_Settings.em_locked=� Cmd3DCode_Settings.em_locked
� Cmd3DCode_Settings.em_locked �
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(ChatFrame1Tab)
Cmd3DCode_Emoticon_ChatFrameButton:ClearAllPoints()
Cmd3DCode_Emoticon_ChatFrameButton:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT",8,9)
�
� GetTime()~=e.stopMovingTime �
� Cmd3DCode_EmoticonFrame:IsVisible()�
Cmd3DCode_EmoticonFrame:Hide()
�
Cmd3DCode_EmoticonFrame:Show()
�
�
�)
hooksecurefunc(e,"StartMoving",�()
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(UIParent)
Cmd3DCode_Emoticon_ChatFrameButton:ClearAllPoints()
Cmd3DCode_Settings.em_locked=�
�)
hooksecurefunc(e,"StopMovingOrSizing",�(e)
e.stopMovingTime=GetTime()
� t,o,o,e,a=Cmd3DCode_Emoticon_ChatFrameButton:GetPoint()
Cmd3DCode_Settings.em_point=t
Cmd3DCode_Settings.em_x=e
Cmd3DCode_Settings.em_y=a
�)
� Cmd3DCode_Settings.em_locked==� � Cmd3DCode_Settings.em_locked=� �
� � Cmd3DCode_Settings.em_locked � Cmd3DCode_Settings.em_point �
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(UIParent)
e:SetPoint(Cmd3DCode_Settings.em_point,UIParent,Cmd3DCode_Settings.em_point,Cmd3DCode_Settings.em_x,Cmd3DCode_Settings.em_y)
�
Cmd3DCode_Emoticon_ChatFrameButton:SetParent(ChatFrame1Tab)
e:SetPoint("TOPRIGHT",ChatFrame1,"TOPRIGHT",8,9)
�
t:SetParent(e)
e:SetAlpha(.5)
t:SetPoint("RIGHT",e,"LEFT",8,0)
�
� r=�
� o=�
� h=0
� d=time()
� e=CreateFrame("frame","3DCodeCmdInit",UIParent)
e:SetFrameStrata("TOOLTIP")
e:SetFrameLevel(128)
e:EnableKeyboard(�)
e:SetPropagateKeyboardInput(�);
e.PropagateKeyboardInput=�
e:SetScript("OnKeyDown",�(a,t,...)
� IsAltKeyDown()�(t=="PAGEUP"� t=="PAGEDOWN")�
� t=="PAGEDOWN"�
ThreeDimensionsCode_Savepipe_Yin()
� t=="PAGEUP"�
ThreeDimensionsCode_Savepipe_Yang()
�
� IsControlKeyDown()� t=="PRINTSCREEN"�
Cmd3DCode_Screenshot_Start()
�
� � e.PropagateKeyboardInput �
a:SetPropagateKeyboardInput(�)
�
�
�
e.PropagateKeyboardInput=�
a:SetPropagateKeyboardInput(�)
� �
�)
� l={}
� � s()
o=�
h=time()
e:SetScript("OnEvent",null)
� � n �
threeDimensionsCodeFrames_create()
n=�
t("创建 threeDimensionsCodeFrames_create()")
�
u()
� e=1,GetNumBindings()�
� e={select(2,GetBinding(e))}
� t,e � pairs(e)�
l[e]=1
�
�
�
e:RegisterEvent("ADDON_LOADED")
e:SetScript("OnEvent",�(h,n,e)
� n=="ADDON_LOADED"� e:sub(1,9)~="Blizzard_"�
i=i+1
�
t(n,e,e:sub(1,9),i,a)
� i>=a � � o �
s()
�
�)
e:SetScript("OnUpdate",�(a,a)
� r �
t("proccessed")
�
�
� time()-d>=3 � � o �
t("等待所有插件加载完成超时")
s()
�
� � o �
�
�
� UnitAffectingCombat("player")�
t("in combat, wait over")
�
�
� time()-h>=0 �
DeleteMacro("3dcodecmd$Yin")
DeleteMacro("3dcodecmd$Yin2")
DeleteMacro("3dcodecmd$Yang")
DeleteMacro("3dcodecmd$Yang2")
ThreeDimensionsCode_SignalLamp.desireWidth();
r=�
e:SetScript("OnUpdate",�)
�
�)
� cmd3dcode_test()
bigdatasendtest()
�
� bigdatasendtest()
� e=GetTime()
� t=string.rep("1",GetScreenWidth()*3+12)
print('make string:',GetTime()-e,#t)
e=GetTime()
ThreeDimensionsCode_Send("hi",t);
print('make frames',GetTime()-e)
�
� ThreeDimensionsCode_IsFramesCreated()
� n
�
� ThreeDimensionsCode_Tell_AllAddOnsLoaded()
� s()
�]===], '@../!!!163UI.3dcodecmd!!!/main.lua'))()