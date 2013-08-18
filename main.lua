local mime = require "mime"
json = require "json"
--widget = require "widget"
require "multiline_text"
scoredojo = require "scoredojo"
local onEnterFrame = false
local lastTime = system.getTimer()

--system.setIdleTimer( false ) -- change for nook

--other stuff
cw = display.contentWidth
ch = display.contentHeight

token = "50ce2269053f958e66c06486885d4a41"
baseLink = "https://scoredojo.com/api/v1/"

local attribution = {
	
	"jerrroen, Kitten Pic 1", 
	"Lawrence in Houston, Kitten Pic 2",
	"London looks, Kitten Pic 3",
	"CarbonNYC, Kitten Pic 4",
	"NeilGHamilton, Kitten Pic 5",
	"cygnus921, Kitten Pic 6",
	" You As A Machine, Kitten Pic 7",

	"Dwilliams851, Puppy Pic 1",
	"bowler1996p, Puppy Pic 2",
	"halfrain, Puppy Pic 3",
	"odonata98, Puppy Pic 3",
	"Joe Shlabotnik, Puppy Pic 4",
	"Eksley, Llama Pic 5"

}

	function findModel ()

		device = {

			name = system.getInfo("name"),
			model = system.getInfo("model"),

		}

		deviceModelName = ""

		if device.model == "BNTV200a" or device.model == "BNTV200" or device.model == "BNTV250" or device.model == "BNTV250a" then 
			deviceModelName = "Nook"
		elseif device.model == "BNTV400" or device.model == "BNTV600" then
			deviceModelName = "NookHD"
		elseif device.model == "A1428" or device.model == "A1429" or device.model == "A1442" then
			deviceModelName = "iPhone5"
		elseif device.model == "A1387" or device.model == "A1431" or device.model == "A1349" or device.model == "A1332" or device.model == "A1325" or device.model == "A1303" or device.model == "A1324" or device.model == "A1241" or device.model == "A1203" or device.model == "iPhone" then
			deviceModelName = "iPhoneBelow5"
		elseif device.model == "BNRV200" then
			deviceModelName = "Macbook"
		end
		return deviceModelName
	end
	print( "findModel: ", findModel())


	-- ask for feedback every once in a while
	-- feedback popup listener
	-- Handler that gets notified when the alert closes
	local function rate()
		local options =
		{
		   nookAppEAN = "2940147137871",
		   supportedAndroidStores = {"google", "nook" },
		}
		native.showPopup("rateApp", options)
	end

	function thanksPopListener( event )
	        if "clicked" == event.action then
	                local i = event.index
	                if 1 == i then -- No
	                	print("rate")
	                	native.cancelAlert(thanksAlert)
	                	timer.performWithDelay(200, rate, 1)
	                elseif 2 == i then -- Yes
	                	print("Remind me")
	                elseif 3 == i then -- Yes
	                	print("no thanks")
	                	local menuCount = Load("menuCount")
	                	menuCount.shouldDisplayPopup = false
	                	Save(menuCount, "menuCount")
	                end
	        end
	end

	doYouLoveAlert = 1
	function popupListener( event )
	        if "clicked" == event.action then
	                local i = event.index
	                if 1 == i then -- No
	                	local options =
						{
						   to = "admin@appdojo.com",
						   subject = "Give Us Feedback!",
						   body = ""
						}
						native.showPopup("mail", options)
						local menuCount  = Load("menuCount")
						menuCount.shouldDisplayPopup = false
						Save(menuCount, "menuCount")
	                        --system.openURL( "http://developer.anscamobile.com" )	                		
	                        -- Do nothing; dialog will simply dismiss
	                elseif 2 == i then -- Yes
	                	print("Rate")
	                	-- native.cancelAlert(doYouLoveAlert)
	                	local thanksTxt = "We are so happy to hear that you love Kitten or Puppy! It'd be really helpful if you rated us in the App Store."
	                	native.cancelAlert(doYouLoveAlert)
	                	timer.performWithDelay(200, function() 
	                		thanksAlert = native.showAlert( "Thank you!", thanksTxt, { "Rate Kitten or Puppy", "Remind Me Later", "No Thanks" }, thanksPopListener )
	                	end, 1)
	                	--thanksAlert = native.showAlert( "Thank you!", thanksTxt, { "Maybe later" }, thanksPopListener )
	                        -- Open URL if "Learn More" (the 2nd button) was clicked
	                end
	        end
	end

-- gameNetwork = require( "gameNetwork" )

-- CC_Access_Key = "874d15b4684aae2811308c25cf18c4c556ad5755"
-- CC_Secret_Key = "6109e4882fe07cb0abb510b6dd6a25653fa52eb6"

-- coronaCloud = require ( "corona-cloud-core" )
-- coronaCloud.init( CC_Access_Key, CC_Secret_Key )

-- local params = { accessKey = CC_Access_Key, secretKey = CC_Secret_Key, }
-- gameNetwork.init( "corona", params )

function setEnterFrame( listener )   
	onEnterFrame = listener
end

function enterFrame(event)	
	if onEnterFrame then
		onEnterFrame(event.time - lastTime)
	end
	lastTime = event.time
end
Runtime:addEventListener("enterFrame", enterFrame)

function Load( pathname )
	local data = nil
	local path = system.pathForFile( pathname..".dat", system.DocumentsDirectory  ) 
	local fileHandle = io.open( path, "r" )
	if fileHandle then
		data = json.decode( mime.unb64( fileHandle:read( "*a" ) ) or "" )
		io.close( fileHandle ) 
	end 
	return data 
end

function Save( data, pathname ) 
	local success = false 
	local path = system.pathForFile( pathname..".dat", system.DocumentsDirectory  ) 
	local fileHandle = io.open( path, "w" ) 
	if fileHandle and data then 
		local encodedData = mime.b64( json.encode(data) ) 
		fileHandle:write( encodedData ) 
		io.close( fileHandle ) 
		success = true
	end
	return success 
end

local audioData = Load("audioData")
if audioData then
else 
	local audioData = {toggle = "on"}
	Save(audioData, "audioData")
end

local shop = Load("shop")
if shop == nil then
	shop = {hearts=2}
	Save(shop, "shop")
else 

end


--check for ser info, if there create header
local userInfo = Load("userInfo", userInfo)
--server stuff
headers = {}
headers["Accept"] = "application/json"

if userInfo ~= nil and userInfo.authKey ~= nil then
	headers["Authorization"] = "Token token="..tostring(userInfo.authKey)
	print(userInfo.authKey, userInfo.username, userInfo.password)
end

director = {
    scene = 'main',
    changeScene = function (self, moduleName)
        if type(moduleName) == 'nil' or self.scene == moduleName then return end
        if self.clean and type(self.clean) == 'function' then self.clean() end
        if self.view then self.view:removeSelf() end
        if self.scene ~= 'main' and type(package.loaded[self.scene]) == 'table' then
            package.loaded[self.scene], self.view = nil
            collectgarbage('collect')
        end
        self.scene, self.view, self.clean = moduleName, require(moduleName).new()
    end
}

function displayNewButton(group, image, imageDown, x, y, shouldScale, scaleX, timeToScale, sceneToGoTo, text, tr, tg, tb, font, textSize, customFunction, id)
	local btnGroup = display.newGroup()
	group:insert(btnGroup)
	local newBtn = display.newImage(image, 0, 0 )
	if newBtn then
		newBtn.id = id
		btnGroup:insert(newBtn)
		--newBtn.x = x
		local overlayBtn
		local btnText
		newBtn.alpha = 1

		local btnText
		if text ~= nil then
			newBtn.text = btnText
			btnText = display.newText( text, newBtn.x, newBtn.y, font, textSize )
			btnText:setTextColor(tr,tg,tb)
			btnText.x, btnText.y = newBtn.x, newBtn.y + 7
			btnGroup:insert(btnText)
		end

		local function onNewBtnTouch (event)
			if event.phase == "began" then
				currentButtonDown = newBtn
				if shouldScale == true then
					transition.to(newBtn, {time=timeToScale, xScale = scaleX, yScale = scaleX})
					transition.to(btnText, {time=timeToScale, xScale = scaleX, yScale = scaleX})
				end
				if imageDown ~= nil then
					overlayBtn = display.newImage(btnGroup, imageDown, 0, 0)
					btnGroup:insert(overlayBtn)
					btnText:toFront()
					btnText.alpha = 0.5
				end
			elseif event.phase == "ended" then
				btnText.alpha = 1
				display.remove(overlayBtn)
				if customFunction then
					customFunction(btnGroup)
				end
				currentButtonDown = nil
				--if customFunction == nil then
					if shouldScale == true then
						transition.to(newBtn, {time=timeToScale, xScale = 1, yScale = 1, onComplete=function()transition.cancel(newBtn) if sceneToGoTo ~= nil then end end})
						transition.to(btnText, {time=timeToScale, xScale = 1, yScale = 1, onComplete=function()transition.cancel(newBtn) if sceneToGoTo ~= nil then end end})			
					elseif shouldScale == false then
						if sceneToGoTo ~= nil then 
							if overlayBtn then
								--btnGroup:removeSelf()
							end
							director:changeScene(sceneToGoTo, "crossfade")
						end
					end
				--end
			end
			return true
		end

		newBtn.cancel = function ()
			if overlayBtn then
				btnText.alpha = 1
				display.remove(overlayBtn)
				overlayBtn = nil
			end
			if shouldScale == true then
				transition.to(newBtn, {time=timeToScale, xScale = 1, yScale = 1})
				transition.to(btnText, {time=timeToScale, xScale = 1, yScale = 1})
			end
		end

		newBtn:addEventListener("touch", onNewBtnTouch)
		btnGroup.x = x
		btnGroup.y = y
		return btnGroup
	end
end

local function runtimeTouch (event)

		if event.phase == "moved" then
			if currentButtonDown then
				--- this is the 'onMouseOut' event
				currentButtonDown.cancel()
			end
		elseif event.phase == "ended" then
            --- all buttons should be 'up' becuse there are no touches
            if currentButtonDown then
           		currentButtonDown.cancel()
           	end
		end

end

Runtime:addEventListener("touch", runtimeTouch)


director:changeScene("menu") 

