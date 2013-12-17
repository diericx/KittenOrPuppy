local M = {}

function M.new()
	local widget = require( "widget" )

	local group = display.newGroup()
	local llamaDuckPics = display.newGroup()
	group:insert(llamaDuckPics)

	local reactSpeeds = {}
	local newImageTime = 55 --55
	local score = 0
	local lives = 3
	local newImageCooldown = 150 --150
	local gameOver = false
	local tooSlow = false
	local falseAnswer = false
	local oldRandomImage
	local llamaOrDuck
	local retryBtn
	local menuBtn
	local leaderBoardsBtn
	local llamaBtn
	local duckBtn
	local scoreText
	local yourFault
	local yourScoreTxt
	local darkener
	local enterframe
	local signInTxt
	local countdownToStart
	local heart1
	local heart2
	local heart3
	local audioData = Load("audioData")
	local dlc = Load("DLC", userInfo)

	-- scoredojo.refreshUserData("https://scoredojo.com/api/v1/", "536f2b4067689c1b1632f87e6a2ef31b")

	--chagne time according to device 
	local deviceModel = findModel()
	if deviceModel == "Nook" then
		newImageTime = 35
	end 
	print(findModel(), "$$#$#$#$#$#$#$#$#$#$#$#$#$#$#")

	--load audio
	-- local correctSound = audio.loadSound("correct.mp3")
	-- local wrongSound = audio.loadSound("wrong.mp3")
	-- local crowdSound = audio.loadSound("crowd.mp3")

	local function displayNewPic ()

		repeat 
			llamaOrDuck = math.random(1,2)
			newRandomImage = math.random(1, numberOfImages/2) 
			if llamaOrDuck == 1 then
					newRandomImage = newRandomImage + numberOfImages
			end
		until newRandomImage ~= randomImage

		randomImage = newRandomImage


		for i = 1, #picsTable do
			if picsTable[i].display == true then
				picsTable[i].display = false
			end
		end
		print(randomImage)
		picsTable[randomImage].display = true

		oldRandomImage = randomImage
	end
	displayNewPic()

	local function deathWithLife() 
		print("NEW IMAGE CD = ", newImageCooldown)
      	score = score - 50
      	if (score < 0) then
      		score = 0
      	end
      	scoreText.text = score
      	--add speed to table
      	local tablePos = #reactSpeeds + 1
      	reactSpeeds[tablePos] = newImageCooldown
      	--reset stuff
      	newImageCooldown = newImageTime
      	displayNewPic()

	end

	local function feedback ()
		print("FEEDBACK")
		local menuCount = Load("menuCount")
		-- if its not there, create one
		if menuCount == nil then
			menuCount = {count = 0, top = 5, shouldDisplayPopup = true}
			Save(menuCount, "menuCount")
		-- if it is there, add to it
		elseif menuCount.shouldDisplayPopup == true then
			if menuCount.count < menuCount.top then
				menuCount.count = menuCount.count + 1
				Save(menuCount, "menuCount")
			-- if it equals the top then display popup
			elseif menuCount.count == menuCount.top then
				menuCount.count = 0
				Save(menuCount, "menuCount")
				--display a popup
				-- Show alert with five buttons
				doYouLoveAlert = native.showAlert( "Do you love Kitten or Puppy?", "", { "No", "Yes" }, popupListener )
			end
		end
	end

	local function endGame ()
		feedback()
		if tooSlow == true then
			yourFault.text = "You were too slow!"
		elseif falseAnswer == true then
			yourFault.text = "Wrong answer!"
		end

		darkener.x = 0

		yourScoreTxt.x, yourScoreTxt.y = cw/2, ch/2-300

		scoreText.y = yourScoreTxt.y + 120
		scoreText:toFront()

		retryBtn.x, retryBtn.y = cw/2-150,  ch/2-100
		retryBtn:toFront()

		menuBtn.x, menuBtn.y = cw/2-150,  ch/2 + 50
		menuBtn:toFront()

		leaderBoardsBtn.x, leaderBoardsBtn.y = cw/2-150-26,  ch/2 + 200
		leaderBoardsBtn:toFront()

		llamaBtn.x, duckBtn.x = 100000, 100000
		gameOver = true

		local userInfo = Load("userInfo")
		if userInfo then
			print("SUBMITSCOOOOORE")
			local userInfo = Load("userInfo", userInfo)

			headers["Accept"] = "application/json"

			if userInfo ~= nil and userInfo.authKey ~= nil then
				headers["Authorization"] = "Token token="..tostring(userInfo.authKey)
			end
			scoredojo.submitHighscore (baseLink, "50ce2269053f958e66c06486885d4a41", 1, score)
		else 
			signInTxt.y = ch-50
		end

		setEnterFrame(nil)

	end

	local function restart()

		print("RESTART")
		darkener.x = 100000

		yourScoreTxt.x = 100000
		
		yourFault.text = ""

		scoreText.y = 100000

		retryBtn.x, retryBtn.y = cw/2-1000050,  ch/2-100

		menuBtn.x, menuBtn.y = cw/2-1000050,  ch/2 + 50

		leaderBoardsBtn.x, leaderBoardsBtn.y = cw/2-1500000-26,  ch/2 + 200

		llamaBtn.x, duckBtn.x = cw-600, cw-300

		signInTxt.y = ch-50000

		scoreText.x = cw/2
		scoreText.y = ch/2 - 450

		llamaBtn.x, duckBtn.x = 100000, 100000

		newImageCooldown = 180

		score = 0
		scoreText.text = score

		tooSlow = false
		falseAnswer = false 
		gameOver = false

		if (dlc.lives) then
  			display.remove(heart1)
      		display.remove(heart2)
      		display.remove(heart3)
      		lives = 3

			heart1 = display.newImage(group, "Images/heart.png", 0, 0)
			heart1.x, heart1.y = scoreText.x - heart1.width - 20, scoreText.y + heart1.height

			heart2 = display.newImage(group, "Images/heart.png", 0, 0)
			heart2.x, heart2.y = heart1.x + heart1.width + 20, heart1.y

			heart3 = display.newImage(group, "Images/heart.png", 0, 0)
			heart3.x, heart3.y = heart2.x + heart2.width + 20, heart2.y
		end

		countdownToStart()

		setEnterFrame(enterframe)	

	end

	local function onButtonEvent( objects )
		print(objects[1])
	   --local phase = event.phase
	   local target = objects[1]
	    --  if ( "began" == phase ) then
	   --elseif ( "ended" == phase ) then
	      print( target.id .. " released" )
	      if (target.id == "llama" and llamaOrDuck == 1) or (target.id == "duck" and llamaOrDuck == 2) then
	      		if audioData.toggle == "on" then
	      			media.playSound("wrong.mp3")
	      		end
	      		--audio.play(wrongSound)
	      		--audio.play(crowdSound)
		      	if (dlc.lives) then
	      			if (lives >= 0) then
	      				if (lives == 3) then
	      					lives = lives - 1
	      					deathWithLife()
							display.remove(heart3)
						elseif (lives == 2) then
							lives = lives - 1
							deathWithLife()
							display.remove(heart2)
						elseif (lives == 1) then
							lives = lives - 1
							display.remove(heart1)
							falseAnswer = true
							endGame()
						end
					end
				else
					falseAnswer = true
	      			endGame()
	      			setEnterFrame(nil)
	      		end
	      else
	      	if gameOver == false then
	      		if audioData.toggle == "on" then
	      			media.playSound("correct.mp3")
	      		end
	      		--add score according to speed
	      		--audio.play(correctSound)
		      	print("NEW IMAGE CD = ", newImageCooldown)
		      	--score = score + 1
		      	score = score + math.round( (newImageCooldown/2) * 10)
		      	--score = score + math.round((newImageCooldown / 60)*100)
		      	scoreText.text = score
		      	--add speed to table
		      	local tablePos = #reactSpeeds + 1
		      	reactSpeeds[tablePos] = newImageCooldown
		      	--reset stuff
		      	newImageCooldown = newImageTime
		      	displayNewPic()
		    end
	      end
	      if target.id == "retry" then
	      	director:changeScene("restart")
	      end
	   --end
	   return true
	end

	local function onRetryButtonEvent( event )
	   local phase = event.phase
	   local target = event.target
	      if ( "began" == phase ) then
	      --print( target.id .. " pressed" )
	      --target:setLabel( "Pressed" )  --set a new label
	   elseif ( "ended" == phase ) then
	      if target.id == "retry" then
	      		
	      	--director:changeScene("restart")
	      end
	      --target:setLabel( target.baseLabel )  --reset the label
	   end
	   return true
	end

	-- local llamaBtn = widget.newButton
	-- {
	--    left = 10,
	--    top = ch-100,
	--    label = "Llama",
	--    labelAlign = "center",
	--    font = "Arial",
	--    fontSize = 30,
	--    labelColor = { default = {0,0,0}, over = {200,200,200} },
	--    onEvent = onButtonEvent
	-- }
	-- llamaBtn.baseLabel = "Default"
	-- llamaBtn.id = "llama"
	-- group:insert(llamaBtn)

	--retryBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2-100050, ch/2-200000, false, 1, nil, nil, "Retry", "DimitriSwank", 60, restart, nil)	
	retryBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2 - 100050, cw/2-200000, false, 1, nil, nil, "Retry", 240, 240, 240, "DimitriSwank", 60, restart, nil)

	--menuBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2-100050, ch/2-200000, false, 1, nil, "menu", "Menu", "DimitriSwank", 60, nil, nil)	
	menuBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw/2 - 100050, cw/2-200000, false, 1, nil, "menu", "Menu", 240, 240, 240, "DimitriSwank", 60, nil, nil)

	--leaderBoardsBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2-100050, ch/2-200000, false, 1, nil, "leaderboards", "Highscores", "DimitriSwank", 55, nil, nil)	
	leaderBoardsBtn = displayNewButton(group, "Images/buttonUpMenu.png", "Images/buttonDownMenu.png", cw/2 - 100050, cw/2-200000, false, 1, nil, "leaderboards", "Highscores", 240, 240, 240, "DimitriSwank", 55, nil, nil)

	darkener = display.newRect(group, 100000,0,cw,ch)
	darkener:setFillColor(0,0,0)
	darkener.alpha = 0.5
	darkener:setReferencePoint(display.TopLeftReferencePoint)

	yourScoreTxt = display.newText(group, "Your Score:", 0, 0, "DimitriSwank", 80)
	yourScoreTxt.x, yourScoreTxt.y = cw/2, ch/2-30000
	yourScoreTxt:setTextColor(255, 255, 255)
	--yourScoreTxt:setReferencePoint(display.TopLeftReferencePoint)
	
	yourFault = display.newText(group, "", 0, 0, "DimitriSwank", 60)
	yourFault.x, yourFault.y = cw/2, ch/2-450
	yourFault:setTextColor(200, 0, 0)
	yourFault:setReferencePoint(display.TopLeftReferencePoint)
	
	scoreText = display.newText(score, 0, 0, native.SystemDefaultFont, 90 )
	group:insert(scoreText)
	scoreText.x = cw/2
	scoreText.y = ch/2 - 450

	signInTxt = display.newText(group, "You need to login or create a Scoredojo account to view or submit highscores!", 23, 0, cw, 200, "Mensch", 33 )
	signInTxt.y = ch-50000

	if (dlc.lives) then
		heart1 = display.newImage(group, "Images/heart.png", 0, 0)
		heart1.x, heart1.y = scoreText.x - heart1.width - 20, scoreText.y + heart1.height

		heart2 = display.newImage(group, "Images/heart.png", 0, 0)
		heart2.x, heart2.y = heart1.x + heart1.width + 20, heart1.y

		heart3 = display.newImage(group, "Images/heart.png", 0, 0)
		heart3.x, heart3.y = heart2.x + heart2.width + 20, heart2.y
	end

	-- local duckBtn = widget.newButton
	-- {
	--    left = cw-210,
	--    top = ch-100,
	--    label = "Duck",
	--    labelAlign = "center",
	--    font = "Arial",
	--    fontSize = 30,
	--    labelColor = { default = {0,0,0}, over = {200,200,200} },
	--    onEvent = onButtonEvent
	-- }
	-- duckBtn.baseLabel = "Default"
	-- duckBtn.id = "duck"
	-- group:insert(duckBtn)

	-- retryBtn = widget.newButton
	-- {
	--    left = cw/2-100*1000,
	--    top = ch/2-100*1000,
	--    label = "Retry",
	--    labelAlign = "center",
	--    font = "Arial",
	--    fontSize = 30,
	--    labelColor = { default = {0,0,0}, over = {200,200,200} },
	--    onEvent = onRetryButtonEvent
	-- }
	-- retryBtn.baseLabel = "Default"
	-- retryBtn.id = "retry"
	-- group:insert(retryBtn)


	function enterframe()
		for i = 1, #picsTable do
			if picsTable[i].display == true then
				picsTable[i].x = cw/2
				picsTable[i].y = ch/2
			elseif picsTable[i].display == false then
				picsTable[i].x = 10000
				picsTable[i].y = 10000
			end
		end

		if newImageCooldown > 0 then
			newImageCooldown = newImageCooldown - 1
		elseif newImageCooldown <= 0 then
			if audioData.toggle == "on" then
				media.playSound("wrong.mp3")
			end
			--audio.play(wrongSound)
			--audio.play(crowdSound)
			if (dlc.lives) then
      			if (lives >= 0) then
      				if (lives == 3) then
      					lives = lives - 1
      					deathWithLife()
						display.remove(heart3)
					elseif (lives == 2) then
						lives = lives - 1
						deathWithLife()
						display.remove(heart2)
					elseif (lives == 1) then
						lives = lives - 1
						display.remove(heart1)
						tooSlow = true
						endGame()
					end
				end
			else
				tooSlow = true
      			endGame()
      			setEnterFrame(nil)
      		end
		end
	end
	setEnterFrame(enterframe)

	function countdownToStart ()
		local readySetGo = 0
		local scaleTime = 500
		local readySetGoTxt = display.newText(group, "Ready!", 0, 0, "DimitriSwank", 80)
		readySetGoTxt.x, readySetGoTxt.y = cw/2, ch/2
		transition.to(readySetGoTxt, {time=scaleTime, xScale = 2, yScale = 2, alpha = 0})
		local function readySetGoFunct ()
			readySetGo = readySetGo + 1
			if readySetGo == 1 then 
				readySetGoTxt.text = "Set!"
				readySetGoTxt.alpha = 1
				readySetGoTxt.xScale, readySetGoTxt.yScale = 1,1
				transition.to(readySetGoTxt, {time=scaleTime, xScale = 2, yScale = 2, alpha = 0})
			elseif readySetGo == 2 then 
				readySetGoTxt.text = "Go!"
				readySetGoTxt.alpha = 1
				readySetGoTxt.xScale, readySetGoTxt.yScale = 1,1
				transition.to(readySetGoTxt, {time=scaleTime, xScale = 2, yScale = 2, alpha = 0})
				
				--llamaBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-600, ch-150, false, 1, nil, nil, "Kitten", "DimitriSwank", 60, onButtonEvent, "llama")
				llamaBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-600, ch-150, false, 1, nil, nil, "Kitten", 240, 240, 240, "DimitriSwank", 55, onButtonEvent, "llama")

				--duckBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-300, ch-150, false, 1, nil, nil, "Puppy", "DimitriSwank", 60, onButtonEvent, "duck")
				duckBtn = displayNewButton(group, "Images/buttonUp.png", "Images/buttonDown.png", cw-300, ch-150, false, 1, nil, nil, "Puppy", 240, 240, 240, "DimitriSwank", 55, onButtonEvent, "duck")

			end
		end
		timer.performWithDelay(750, readySetGoFunct, 2)
	end
	countdownToStart()

	return group
end

return M