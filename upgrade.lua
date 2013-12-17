local M = {}

function M.new()
	local group = display.newGroup()
	native.setKeyboardFocus( nil )

	local store = require( "store" )

	-- local function buy()
	-- 		-- enable Fortumo plugin  
	-- 	local fortumo = require("plugin.fortumo")
	-- 	-- initiate Fortumo payment object
	-- 	local request = fortumo.newPaymentRequest();
	-- 	-- set the product name to be displayed to the user
	-- 	 request:setDisplayString("Upgrade");
	-- 	-- associate the payment with your Fortumo account
	-- 	 request:setService("f1f6c9e1616bd59b5ea4da59b305fb6d", "961e68855a6a9bbc2ec9529c8a9783f0");
	-- 	-- set unique product identifier
	-- 	 request:setProductName("UPGRADE");
	-- 	 -- non-consumable products (by product name) can be restored even after app uninstall
	-- 	 request:setConsumable(false)
	-- 	 -- launch the payment flow
	-- 	 fortumo.makePayment(request, onPaymentComplete)
		 
	-- 	-- And once the payment has been completed, we’ll receive the payment result
	-- 	function onPaymentComplete(response)
	-- 		local dlc = Load("DLC")
	-- 		dlc.lives = true
	-- 		dlc.morePics = true
	-- 		Save(dlc, "DLC")
	-- 	end
	-- end

	--local function handleButtonEvent(event)
	    --local phase = event.phase 

	    --if "ended" == phase then
			function onPaymentComplete(response)
				native.showAlert("Fortumo", "Result=" .. response.billingStatus)
			end
			
			local request = fortumo.newPaymentRequest()
			
			request:setDisplayString("Upgrade")
			request:setService("f1f6c9e1616bd59b5ea4da59b305fb6d", "80bb752c34dd62dd9a8d940925d60f3b")
			request:setProductName("your_product_code_here")
			request:setConsumable(false)
			
			fortumo.makePayment(request, onPaymentComplete)
	    --end
	--end

	local bg = display.newImage(group, "Images/bg.png", 0, 0)
	bg:rotate(0)
	bg.x = cw/2
	bg.y = ch/2

	local upgradeBtn = displayNewButton(group, "Images/upgradeBtn.png", "Images/upgradeBtn.png", cw/2 - 250, cw/2 - 150, false, 1, nil, nil, "", 240, 240, 240, "DimitriSwank", 80, buy, nil)


	return group
end

return M