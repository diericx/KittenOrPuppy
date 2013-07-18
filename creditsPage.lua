local M = {}

function M.new()
	local group = display.newGroup()

	local bg = display.newImage(group, "Images/bg.png", 0, 0)
	bg:rotate(0)
	bg.x = cw/2
	bg.y = ch/2

	--local backBtn = displayNewButton(group, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", 20, 10, false, 1, nil, "menu", "Back", "DimitriSwank", 40, nil, nil)	
	local backBtn = displayNewButton(group, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", 20, 10, false, 1, nil, "menu", "Back", 240, 240, 240, "DimitriSwank", 40, nil, nil)


	local people = {
		{name="jerrroen"},
		{name="Lawrence"},
		{name="London looks"},
		{name="CarbonNYC"},
		{name="NeilGHamilton"},
		{name="cygnus921"},
		{name="You As A Machine"},

		{name="Dwilliams851"},
		{name="bowler1996p"},
		{name="halfrain"},
		{name="odonata98"},
		{name="Joe Shlabotnik"},
		{name="Eksley"},
		--{name="You As A Machine"},

	}


--	local text = display.newText( "We would like to thank the following Flickr users for providing the images used in this game under the Creative Commons Attribution License:", 20, 100, cw, 300, "Mensch", 38 )
	local text = display.newMultiLineText  
        {
        text = "We would like to thank the following Flickr users for providing the images used in this game under the Creative Commons Attribution License:",
        width = cw,                  --OPTIONAL        Defailt : nil 
        left = 0,top = cw+200,             --OPTIONAL        Default : left = 0,top=0
        font = "Mensch",     --OPTIONAL        Default : native.systemFont
        fontSize = 38,                --OPTIONAL        Default : 14
        color = {173,173,255},              --OPTIONAL        Default : {0,0,0}
        align = "center"              --OPTIONAL   Possible : "left"/"right"/"center"
        }
    text.x = cw/2
    text.y = ch/2 - 280
--	text:setTextColor(173, 173, 255)
	group:insert(text)

	for i = 1, #people do 
		local personName = display.newText(group, people[i].name, 50, i*50 + 320, "Mensch", 30)
	end

	--local creditsBtn = displayNewButton(group, "Images/buttonUpSmall.png", "Images/buttonDownSmall.png", cw-200, 10, false, 1, nil, "credits", "credits", "DimitriSwank", 40, nil, nil)	

	--group:insert(leaderboardsBtnH)
	--director:changeScene("game")

	return group
end

return M