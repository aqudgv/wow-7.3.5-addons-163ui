local base_char,keywords=191,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
  function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[SLASH_URL1="/url"
SlashCmdList["URL"]=�(e,t)
�#e<1 �
e="http://www.baidu.com/"
� � e:find("http")�
e="http://"..e
�
Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器")
ThreeDimensionsCode_Send("innerbrowser",e)
�
SLASH_BAIDU1="/baidu"
SLASH_BAIDU2="/百度"
SlashCmdList["BAIDU"]=�(e,t)
Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器")
ThreeDimensionsCode_Send("innerbrowser","http://www.baidu.com/s?wd="..e)
�
hooksecurefunc("AutoCompleteEditBox_OnEnterPressed",�()
� e=ChatEdit_ChooseBoxForSend()
� � e:IsVisible()�
�
�
� e=e:GetText()
�)
SLASH_OPEN1="/open"
SlashCmdList["OPEN"]=�(e,t)
Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器")
ThreeDimensionsCode_Send("openurl",e)
�
� QuestLogPopupDetailFrame �
� e=CreateFrame("Button","BaiduQuest",QuestLogPopupDetailFrame,"UIPanelButtonTemplate")
e:SetWidth(90)
e:SetHeight(21)
e:SetText("百度一下")
e:SetPoint("TOPLEFT",53,0)
e:SetScript("OnClick",�()
� e=GetQuestLogSelection()
� e<1 �
�
�
Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器")
� e=GetQuestLogTitle(e)
ThreeDimensionsCode_Send("innerbrowser","http://www.baidu.com/s?wd=wow任务+"..e)
�)
�
� QuestMapFrame � QuestMapFrame.DetailsFrame �
� e=CreateFrame("Button","BaiduQuestMap",QuestMapFrame.DetailsFrame,"UIPanelButtonTemplate")
e:SetWidth(90)
e:SetHeight(21)
e:SetText("百度一下")
e:SetPoint("LEFT",QuestMapFrame.DetailsFrame.BackButton,"RIGHT",30,0)
e:SetScript("OnClick",�()
� e=QuestMapFrame.DetailsFrame.questID
� e=e � GetQuestLogIndexByID(e)
� � e � e<1 �
�
�
Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器")
� e=GetQuestLogTitle(e)
ThreeDimensionsCode_Send("innerbrowser","http://www.baidu.com/s?wd=wow任务+"..e)
�)
�
� e=CreateFrame("Button","BaiduItem",ItemRefTooltip,"UIPanelButtonTemplate")
e:SetText("百度一下")
e.Text:SetFont(ChatFontNormal:GetFont(),12,"")
e:SetWidth(60)
e:SetHeight(18)
e:SetPoint("TOPRIGHT",ItemRefTooltip,"BOTTOMRIGHT",-1,0)
� � o(t)
� t,e � pairs({t:GetRegions()})�
� e:GetObjectType()=="FontString"�
� e:GetText()
�
�
�
e:SetScript("OnClick",�(e)
� t=ItemRefTooltip:GetItem()
� a=""
� t �
a="物品"
�
� e=o(ItemRefTooltip)
� e �
t=e:match("^|T.+|t (.+)$")� e
�
�
Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器")
ThreeDimensionsCode_Send("innerbrowser","http://www.baidu.com/s?wd=wow"..a.."+"..t)
�)
]===], '@../!!!163UI.3dcodecmd!!!/buildinbrowser.lua'))()