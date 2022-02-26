--
-- Mod: FS22_AnimalInspector
--
-- Author: JTSage
-- source: https://github.com/jtsage/FS22_Animal_Inspector

AnimalInspector= {}

local AnimalInspector_mt = Class(AnimalInspector)


-- default options
AnimalInspector.displayMode     = 1 -- 1: top left, 2: top right (default), 3: bot left, 4: bot right, 5: custom
AnimalInspector.displayMode5X   = 0.2
AnimalInspector.displayMode5Y   = 0.2

AnimalInspector.debugMode       = false

AnimalInspector.menuTextSizes = { 8, 10, 12, 14, 16 }

AnimalInspector.isEnabledVisible           = true
AnimalInspector.isEnabledShowCount         = true
AnimalInspector.isEnabledShowFood          = true
AnimalInspector.isEnabledShowFoodTypes     = true
AnimalInspector.isEnabledShowProductivity  = true
AnimalInspector.isEnabledShowReproduction  = true
AnimalInspector.isEnabledShowPuberty       = true
AnimalInspector.isEnabledShowHealth        = true
AnimalInspector.isEnabledShowOutputs       = true

AnimalInspector.setValueTimerFrequency  = 60
AnimalInspector.setValueTextMarginX     = 15
AnimalInspector.setValueTextMarginY     = 10
AnimalInspector.setValueTextSize        = 12
AnimalInspector.isEnabledTextBold       = false

AnimalInspector.colorHomeName      = {0.182, 0.493, 0.875, 1}
AnimalInspector.colorDataName      = {0.850, 0.850, 0.850, 1}
AnimalInspector.colorSep           = {1.000, 1.000, 1.000, 1}

AnimalInspector.setStringTextSep         = " | "
AnimalInspector.setStringTextIndent      = "    "


function AnimalInspector:new(mission, i18n, modDirectory, modName)
	local self = setmetatable({}, AnimalInspector_mt)

	self.myName            = "AnimalInspector"
	self.isServer          = mission:getIsServer()
	self.isClient          = mission:getIsClient()
	self.isMPGame          = g_currentMission.missionDynamicInfo.isMultiplayer
	self.mission           = mission
	self.i18n              = i18n
	self.modDirectory      = modDirectory
	self.modName           = modName
	self.gameInfoDisplay   = mission.hud.gameInfoDisplay
	self.inputHelpDisplay  = mission.hud.inputHelp
	self.speedMeterDisplay = mission.hud.speedMeter
	self.ingameMap         = mission.hud.ingameMap

	self.debugTimerRuns = 0
	self.inspectText    = {}
	self.boxBGColor     = { 544, 20, 200, 44 }
	self.bgName         = 'dataS/menu/blank.png'

	local modDesc       = loadXMLFile("modDesc", modDirectory .. "modDesc.xml");
	self.version        = getXMLString(modDesc, "modDesc.version");
	delete(modDesc)

	self.display_data = { }

	self.fill_color_CB = {
		{ 1.00, 0.76, 0.04, 1 },
		{ 0.98, 0.75, 0.15, 1 },
		{ 0.96, 0.73, 0.20, 1 },
		{ 0.94, 0.72, 0.25, 1 },
		{ 0.92, 0.71, 0.29, 1 },
		{ 0.90, 0.69, 0.33, 1 },
		{ 0.87, 0.68, 0.37, 1 },
		{ 0.85, 0.67, 0.40, 1 },
		{ 0.83, 0.66, 0.43, 1 },
		{ 0.81, 0.65, 0.46, 1 },
		{ 0.78, 0.64, 0.49, 1 },
		{ 0.76, 0.62, 0.52, 1 },
		{ 0.73, 0.61, 0.55, 1 },
		{ 0.70, 0.60, 0.57, 1 },
		{ 0.67, 0.59, 0.60, 1 },
		{ 0.64, 0.58, 0.63, 1 },
		{ 0.61, 0.56, 0.65, 1 },
		{ 0.57, 0.55, 0.68, 1 },
		{ 0.53, 0.54, 0.71, 1 },
		{ 0.49, 0.53, 0.73, 1 },
		{ 0.45, 0.52, 0.76, 1 },
		{ 0.39, 0.51, 0.78, 1 },
		{ 0.33, 0.50, 0.81, 1 },
		{ 0.24, 0.49, 0.84, 1 },
		{ 0.05, 0.48, 0.86, 1 }
	}
	self.fill_color = {
		{ 1.00, 0.00, 0.00, 1 },
		{ 1.00, 0.15, 0.00, 1 },
		{ 1.00, 0.22, 0.00, 1 },
		{ 0.99, 0.29, 0.00, 1 },
		{ 0.98, 0.34, 0.00, 1 },
		{ 0.98, 0.38, 0.00, 1 },
		{ 0.96, 0.43, 0.00, 1 },
		{ 0.95, 0.47, 0.00, 1 },
		{ 0.93, 0.51, 0.00, 1 },
		{ 0.91, 0.55, 0.00, 1 },
		{ 0.89, 0.58, 0.00, 1 },
		{ 0.87, 0.62, 0.00, 1 },
		{ 0.84, 0.65, 0.00, 1 },
		{ 0.81, 0.69, 0.00, 1 },
		{ 0.78, 0.72, 0.00, 1 },
		{ 0.75, 0.75, 0.00, 1 },
		{ 0.71, 0.78, 0.00, 1 },
		{ 0.67, 0.81, 0.00, 1 },
		{ 0.63, 0.84, 0.00, 1 },
		{ 0.58, 0.87, 0.00, 1 },
		{ 0.53, 0.89, 0.00, 1 },
		{ 0.46, 0.92, 0.00, 1 },
		{ 0.38, 0.95, 0.00, 1 },
		{ 0.27, 0.98, 0.00, 1 },
		{ 0.00, 1.00, 0.00, 1 }
	}

	self.settingsNames = {
		{"displayMode", "int"},
		{"displayMode5X", "float"},
		{"displayMode5Y", "float"},
		{"debugMode", "bool"},
		{"isEnabledVisible", "bool"},
		{"isEnabledVisible", "bool"},
		{"isEnabledShowCount", "bool"},
		{"isEnabledShowFood", "bool"},
		{"isEnabledShowFoodTypes", "bool"},
		{"isEnabledShowProductivity", "bool"},
		{"isEnabledShowReproduction", "bool"},
		{"isEnabledShowOutputs", "bool"},
		{"isEnabledShowPuberty", "bool"},
		{"isEnabledShowHealth", "bool"},
		{"setValueTimerFrequency", "int"},
		{"setValueTextMarginX", "int"},
		{"setValueTextMarginY", "int"},
		{"setValueTextSize", "int"},
		{"isEnabledTextBold", "bool"},
		{"colorHomeName", "color"},
		{"colorDataName", "color"},
		{"colorSep", "color"},
		{"setStringTextSep", "string"},
		{"setStringTextIndent", "string"},
	}

	return self
end

function AnimalInspector:makeFillColor(percentage, flip)
	local colorIndex = math.floor(percentage/4) + 1
	local colorTab = nil

	if percentage == 100 then colorIndex = 25 end

	if not flip then colorIndex = 26 - colorIndex end

	if g_gameSettings:getValue('useColorblindMode') then
		colorTab = self.fill_color_CB[colorIndex]
	else
		colorTab = self.fill_color[colorIndex]
	end

	if colorTab ~= nil then
		return colorTab
	else
		return {1,1,1,1}
	end
end

function AnimalInspector:updateAnimals()
	local new_data_table = {}

	if g_currentMission == nil or g_currentMission.husbandrySystem == nil then
		-- This is in case you sell your last animal placeable, otherwise it'll display old stats forever?
		self.display_data = {}
		return
	end

	local myHusbandries = g_currentMission.husbandrySystem:getPlaceablesByFarm(self.mission:getFarmId())

	local sortOrder = {}
	local function sorter(a,b) return a[2] < b[2] end

	for v=1, #myHusbandries do
		local thisHusbName = myHusbandries[v]:getName()
		if ( string.sub(thisHusbName, -1) ~= "_") then
			table.insert(sortOrder, {v, thisHusbName})
		end
	end

	table.sort(sortOrder, sorter)

	for _, sortEntry in ipairs(sortOrder) do
		local thisHusb = myHusbandries[sortEntry[1]]
		local thisNumClusters = thisHusb:getNumOfClusters()

		if thisHusb:getAnimalTypeIndex() ~= AnimalType.HORSE and thisNumClusters > 0 then
			local dispFood = {}
			local dispOuts = {}
			local dispRoot = {
				productivty  = 0,
				foodTypes    = {},
				outTypes     = {},
				name         = thisHusb:getName(),
				totalAnimals = thisHusb:getNumOfAnimals(),
				maxAnimals   = thisHusb:getMaxNumOfAnimals(),
				totalFood    = math.ceil((thisHusb:getTotalFood() / thisHusb:getFoodCapacity()) * 100)
			}

			if thisHusb.getFoodInfos ~= nil then
				local thisFood = thisHusb:getFoodInfos()
				for _, thisFoodInfo in ipairs(thisFood) do
					table.insert(dispFood, {
						title    = thisFoodInfo.title,
						percent  = math.ceil(thisFoodInfo.ratio * 100)
					})
				end
				dispRoot.foodTypes = {unpack(dispFood)}
			end

			if thisHusb.getConditionInfos ~= nil then
				local thisCond = thisHusb:getConditionInfos()

				dispRoot.productivity = math.ceil(thisCond[1]["ratio"] * 100)

				if #thisCond > 1 then
					for v=2, #thisCond do
						local thisCondInfo = thisCond[v]
						table.insert(dispOuts, {
							title     = thisCondInfo.title,
							percent   = math.ceil(thisCondInfo.ratio * 100),
							fillLevel = math.floor(thisCondInfo.value),
							invert    = thisCondInfo.invertedBar
						})
					end

					dispRoot.outTypes = {unpack(dispOuts)}
				end
			end

			local clus_totalAnimals    = 0
			local clus_healthPercTotal = 0
			local clus_nonBreedAnimals = 0
			local clus_breedAnimals    = 0
			local clus_breedPercTotal  = 0

			for w=1, thisNumClusters do
				local thisCluster    = thisHusb:getCluster(w)
				local thisNumAnimals = thisCluster:getNumAnimals()
				local subType        = g_currentMission.animalSystem:getSubTypeByIndex(thisCluster:getSubTypeIndex())

				clus_totalAnimals    = clus_totalAnimals + thisNumAnimals
				clus_healthPercTotal = clus_healthPercTotal + ( thisNumAnimals * math.ceil( thisCluster:getHealthFactor() * 100))

				if subType.supportsReproduction then
					if ( thisCluster.age < subType.reproductionMinAgeMonth ) then
						clus_nonBreedAnimals = clus_nonBreedAnimals + thisNumAnimals
					else
						clus_breedAnimals   = clus_breedAnimals + thisNumAnimals
						clus_breedPercTotal = clus_breedPercTotal + ( thisNumAnimals * math.ceil( thisCluster:getReproductionFactor() * 100))
					end
				end
			end

			dispRoot.healthFactor   = math.ceil(clus_healthPercTotal / clus_totalAnimals)
			dispRoot.breedFactor    = math.ceil(clus_breedPercTotal / clus_breedAnimals)
			dispRoot.underageFactor = math.ceil((clus_nonBreedAnimals / clus_totalAnimals) * 100)

			table.insert(new_data_table, dispRoot)
		end
	end

	self.display_data = {unpack(new_data_table)}
end

function AnimalInspector:openConstructionScreen()
	-- hack for construction screen showing blank box.
	g_animalInspector.inspectBox:setVisible(false)
end

function AnimalInspector:draw()
	if not self.isClient then
		return
	end

	if self.inspectBox ~= nil then
		local info_text = self.display_data
		local overlayH, dispTextH, dispTextW = 0, 0, 0
		local linesPerEntry = 4.5


		if not ( g_animalInspector.isEnabledShowHealth or g_animalInspector.isEnabledShowReproduction or g_animalInspector.isEnabledShowPuberty) then
			linesPerEntry = linesPerEntry - 1
		end
		if not g_animalInspector.isEnabledShowFoodTypes then
			linesPerEntry = linesPerEntry - 1
		end
		if not g_animalInspector.isEnabledShowOutputs then
			linesPerEntry = linesPerEntry - 1
		end

		if #info_text == 0 or not g_animalInspector.isEnabledVisible or g_sleepManager:getIsSleeping()  then
			-- we have no entries, hide the overlay and leave
			-- also if we hid it on purpose
			self.inspectBox:setVisible(false)
			return
		elseif g_gameSettings:getValue("ingameMapState") == 4 and g_animalInspector.displayMode % 2 ~= 0 and g_currentMission.inGameMenu.hud.inputHelp.overlay.visible then
			-- Left side display hide on big map with help open
			self.inspectBox:setVisible(false)
			return
		else
			-- we have entries, lets get the overall height of the box and unhide
			self.inspectBox:setVisible(true)
			dispTextH = self.inspectText.size * ( #info_text * linesPerEntry )
			overlayH = dispTextH + ( 2 * self.inspectText.marginHeight)
		end

		setTextBold(g_animalInspector.isEnabledTextBold)
		setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_TOP)

		-- overlayX/Y is where the box starts
		local overlayX, overlayY = self:findOrigin()
		-- dispTextX/Y is where the text starts (sort of)
		local dispTextX, dispTextY = self:findOrigin()

		if ( g_animalInspector.displayMode == 2 ) then
			-- top right (subtract both margins)
			dispTextX = dispTextX - self.marginWidth
			dispTextY = dispTextY - self.marginHeight
			overlayY  = overlayY - overlayH
		elseif ( g_animalInspector.displayMode == 3 ) then
			-- bottom left (add x width, add Y height)
			dispTextX = dispTextX + self.marginWidth
			dispTextY = dispTextY - self.marginHeight + overlayH
		elseif ( g_animalInspector.displayMode == 4 ) then
			-- bottom right (subtract x width, add Y height)
			dispTextX = dispTextX - self.marginWidth
			dispTextY = dispTextY - self.marginHeight + overlayH
		else
			-- top left (add X width, subtract Y height)
			dispTextX = dispTextX + self.marginWidth
			dispTextY = dispTextY - self.marginHeight
			overlayY  = overlayY - overlayH
		end

		if ( g_animalInspector.displayMode % 2 == 0 ) then
			setTextAlignment(RenderText.ALIGN_RIGHT)
		else
			setTextAlignment(RenderText.ALIGN_LEFT)
		end

		if g_currentMission.hud.sideNotifications ~= nil and g_animalInspector.displayMode == 2 then
			if #g_currentMission.hud.sideNotifications.notificationQueue > 0 then
				local deltaY = g_currentMission.hud.sideNotifications:getHeight()
				dispTextY = dispTextY - deltaY
				overlayY  = overlayY - deltaY
			end
		end

		self.inspectText.posX = dispTextX
		self.inspectText.posY = dispTextY

		for _, dText in ipairs(info_text) do

			local thisTextLine  = {}
			local firstRun      = true

			table.insert(thisTextLine, {"colorHomeName", dText.name .. ": ", false, true})

			if ( g_animalInspector.isEnabledShowProductivity ) then
				local fillColor    = self:makeFillColor(dText.productivity, true)
				firstRun = false

				table.insert(thisTextLine, {"colorDataName", g_i18n:getText("statistic_productivity") .. ": ", false, true})
				table.insert(thisTextLine, {"rawFillColor", tostring(dText.productivity) .. "%", fillColor})
			end

			if ( g_animalInspector.isEnabledShowCount ) then
				local fillColor    = self:makeFillColor(math.ceil((dText.totalAnimals / dText.maxAnimals) * 100), false)
				if not firstRun then
					table.insert(thisTextLine, {false, false, false})
				else
					firstRun = false
				end

				table.insert(thisTextLine, {"colorDataName", g_i18n:getText("ui_numAnimals") .. ": ", false, true})
				table.insert(thisTextLine, {"rawFillColor", tostring(dText.totalAnimals), fillColor})
				table.insert(thisTextLine, {"colorSep", " / ", false, true})
				table.insert(thisTextLine, {"rawFillColor", tostring(dText.maxAnimals), fillColor})
			end

			if ( g_animalInspector.isEnabledShowFood ) then
				if not firstRun then
					table.insert(thisTextLine, {false, false, false})
				else
					firstRun = false
				end

				local fillColor    = self:makeFillColor(dText.totalFood, true)

				table.insert(thisTextLine, {"colorDataName", g_i18n:getText("ui_animalFood") .. ": ", false, true})
				table.insert(thisTextLine, {"rawFillColor", tostring(dText.totalFood) .. "%", fillColor})
			end

			dispTextY, dispTextW = self:renderLine(thisTextLine, dispTextX, dispTextY, dispTextW)

			thisTextLine = {}
			firstRun     = true

			if ( g_animalInspector.isEnabledShowHealth or g_animalInspector.isEnabledShowReproduction or g_animalInspector.isEnabledShowPuberty) then
				if ( g_animalInspector.displayMode % 2 ~= 0 ) then
					table.insert(thisTextLine, {"colorHomeName", g_animalInspector.setStringTextIndent, false})
				end

				if g_animalInspector.isEnabledShowHealth then
					firstRun = false

					local fillColor    = self:makeFillColor(dText.healthFactor, true)

					table.insert(thisTextLine, {"colorDataName", g_i18n:getText("hud_animalInspector_avgHealth") .. ": ", false, true})
					table.insert(thisTextLine, {"rawFillColor", tostring(dText.healthFactor) .. "%", fillColor})
				end

				if g_animalInspector.isEnabledShowPuberty then
					if not firstRun then
						table.insert(thisTextLine, {false, false, false})
					else
						firstRun = false
					end

					local fillColor    = self:makeFillColor(dText.underageFactor, false)

					table.insert(thisTextLine, {"colorDataName", g_i18n:getText("hud_animalInspector_tooYoung") .. ": ", false, true})
					table.insert(thisTextLine, {"rawFillColor", tostring(dText.underageFactor) .. "%", fillColor})
				end

				if g_animalInspector.isEnabledShowReproduction then
					if not firstRun then
						table.insert(thisTextLine, {false, false, false})
					else
						firstRun = false
					end

					local fillColor    = self:makeFillColor(dText.breedFactor, true)

					table.insert(thisTextLine, {"colorDataName", g_i18n:getText("hud_animalInspector_avgBreed") .. ": ", false, true})
					table.insert(thisTextLine, {"rawFillColor", tostring(dText.breedFactor) .. "%", fillColor})
				end

				if ( g_animalInspector.displayMode % 2 ~= 0 ) then
					table.insert(thisTextLine, {"colorHomeName", g_animalInspector.setStringTextIndent, false})
				end

				dispTextY, dispTextW = self:renderLine(thisTextLine, dispTextX, dispTextY, dispTextW)
			end

			thisTextLine = {}
			firstRun     = true

			if ( g_animalInspector.isEnabledShowFoodTypes ) then
				if ( g_animalInspector.displayMode % 2 ~= 0 ) then
					table.insert(thisTextLine, {"colorHomeName", g_animalInspector.setStringTextIndent, false})
				end

				for _, foodType in pairs(dText.foodTypes) do
					if not firstRun then
						table.insert(thisTextLine, {false, false, false})
					else
						firstRun = false
					end

					local fillColor    = self:makeFillColor(foodType.percent, true)

					table.insert(thisTextLine, {"colorDataName", foodType.title .. ": ", false, true})
					table.insert(thisTextLine, {"rawFillColor", tostring(foodType.percent) .. "%", fillColor})
				end

				if ( g_animalInspector.displayMode % 2 ~= 0 ) then
					table.insert(thisTextLine, {"colorHomeName", g_animalInspector.setStringTextIndent, false})
				end

				dispTextY, dispTextW = self:renderLine(thisTextLine, dispTextX, dispTextY, dispTextW)
			end

			thisTextLine = {}
			firstRun     = true

			if ( g_animalInspector.isEnabledShowOutputs ) then
				if ( g_animalInspector.displayMode % 2 ~= 0 ) then
					table.insert(thisTextLine, {"colorHomeName", g_animalInspector.setStringTextIndent, false})
				end

				for _, outType in pairs(dText.outTypes) do
					if not firstRun then
						table.insert(thisTextLine, {false, false, false})
					else
						firstRun = false
					end

					local fillColor    = self:makeFillColor(outType.percent, (not outType.invert))

					table.insert(thisTextLine, {"colorDataName", outType.title .. ": ", false, true})
					table.insert(thisTextLine, {"rawFillColor", tostring(outType.fillLevel) .. " (" .. tostring(outType.percent) .. "%)", fillColor})
				end

				if ( g_animalInspector.displayMode % 2 ~= 0 ) then
					table.insert(thisTextLine, {"colorHomeName", g_animalInspector.setStringTextIndent, false})
				end

				dispTextY, dispTextW = self:renderLine(thisTextLine, dispTextX, dispTextY, dispTextW)
			end

			-- Margin bottom for each entry
			dispTextY = dispTextY - ( self.inspectText.size / 2 )
		end

		-- update overlay background
		if g_animalInspector.displayMode % 2 == 0 then
			self.inspectBox.overlay:setPosition(overlayX - ( dispTextW + ( 2 * self.inspectText.marginWidth ) ), overlayY)
		else
			self.inspectBox.overlay:setPosition(overlayX, overlayY)
		end

		self.inspectBox.overlay:setDimension(dispTextW + (self.inspectText.marginWidth * 2), overlayH)

		-- reset text render to "defaults" to be kind
		setTextColor(1,1,1,1)
		setTextAlignment(RenderText.ALIGN_LEFT)
		setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
		setTextBold(false)
	end
end

function AnimalInspector:renderLine(thisTextLine, dispTextX, dispTextY, dispTextW)
	local fullTextSoFar = ""

	if ( g_animalInspector.displayMode % 2 ~= 0 ) then
		for _, thisLine in ipairs(thisTextLine) do
			-- future note: thisLine[4] is not nil and is true for the facility name

			if thisLine[1] == false then
				fullTextSoFar = self:renderSep(dispTextX, dispTextY, fullTextSoFar)
			elseif thisLine[1] == "rawFillColor" then
				setTextColor(unpack(thisLine[3]))
				fullTextSoFar = self:renderText(dispTextX, dispTextY, fullTextSoFar, thisLine[2])
			else
				self:renderColor(thisLine[1])
				fullTextSoFar = self:renderText(dispTextX, dispTextY, fullTextSoFar, thisLine[2])
			end
		end
	else
		for i = #thisTextLine, 1, -1 do
			-- future note: thisTextLine[i][4] is not nil and is true for the facility name

			if thisTextLine[i][1] == false then
				fullTextSoFar = self:renderSep(dispTextX, dispTextY, fullTextSoFar)
			elseif thisTextLine[i][1] == "rawFillColor" then
				setTextColor(unpack(thisTextLine[i][3]))
				fullTextSoFar = self:renderText(dispTextX, dispTextY, fullTextSoFar, thisTextLine[i][2])
			else
				self:renderColor(thisTextLine[i][1])
				fullTextSoFar = self:renderText(dispTextX, dispTextY, fullTextSoFar, thisTextLine[i][2])
			end
		end
	end

	local newDispTextY  = dispTextY - self.inspectText.size
	local tmpW          = getTextWidth(self.inspectText.size, fullTextSoFar)
	local newDispTextW  = dispTextW

	if tmpW > dispTextW then newDispTextW = tmpW end

	return newDispTextY, newDispTextW
end

function AnimalInspector:update(dt)
	if not self.isClient then
		return
	end

	if g_updateLoopIndex % g_animalInspector.setValueTimerFrequency == 0 then
		-- Lets not be rediculous, only update the vehicles "infrequently"
		self:updateAnimals()
	end
end

function AnimalInspector:renderColor(name)
	-- fall back to white if it's not known
	local colorString = Utils.getNoNil(g_animalInspector[name], {1,1,1,1})

	setTextColor(unpack(colorString))
end

function AnimalInspector:renderText(x, y, fullTextSoFar, text)
	local newX = x

	if g_animalInspector.displayMode % 2 == 0 then
		newX = newX - getTextWidth(self.inspectText.size, fullTextSoFar)
	else
		newX = newX + getTextWidth(self.inspectText.size, fullTextSoFar)
	end

	renderText(newX, y, self.inspectText.size, text)
	return text .. fullTextSoFar
end

function AnimalInspector:renderSep(x, y, fullTextSoFar)
	self:renderColor("colorSep")
	return self:renderText(x, y, fullTextSoFar, g_animalInspector.setStringTextSep)
end

function AnimalInspector:onStartMission(mission)
	-- Load the mod, make the box that info lives in.
	print("~~" .. self.myName .." :: version " .. self.version .. " loaded.")
	if not self.isClient then
		return
	end

	-- Just call both, load fails gracefully if it doesn't exists.
	self:loadSettings()
	self:saveSettings()

	if ( g_animalInspector.debugMode ) then
		print("~~" .. self.myName .." :: onStartMission")
	end

	self:createTextBox()
end

function AnimalInspector:findOrigin()
	local tmpX = 0
	local tmpY = 0

	if ( g_animalInspector.displayMode == 2 ) then
		-- top right display
		tmpX, tmpY = self.gameInfoDisplay:getPosition()
		tmpX = 1
		tmpY = tmpY - 0.012
	elseif ( g_animalInspector.displayMode == 3 ) then
		-- Bottom left, correct origin.
		tmpX = 0.01622
		tmpY = 0 + self.ingameMap:getHeight() + 0.01622
		if g_gameSettings:getValue("ingameMapState") > 1 then
			tmpY = tmpY + 0.032
		end
	elseif ( g_animalInspector.displayMode == 4 ) then
		-- bottom right display
		tmpX = 1
		tmpY = 0.01622
		if g_currentMission.inGameMenu.hud.speedMeter.overlay.visible then
			tmpY = tmpY + self.speedMeterDisplay:getHeight() + 0.032
			if g_modIsLoaded["FS22_EnhancedVehicle"] then
				tmpY = tmpY + 0.03
			end
		end
	elseif ( g_animalInspector.displayMode == 5 ) then
		tmpX = g_animalInspector.displayMode5X
		tmpY = g_animalInspector.displayMode5Y
	else
		-- top left display
		tmpX = 0.014
		tmpY = 0.945
		if g_currentMission.inGameMenu.hud.inputHelp.overlay.visible then
			tmpY = tmpY - self.inputHelpDisplay:getHeight() - 0.012
		end
	end

	return tmpX, tmpY
end

function AnimalInspector:createTextBox()
	-- make the box we live in.
	if ( g_animalInspector.debugMode ) then
		print("~~" .. self.myName .." :: createTextBox")
	end

	local baseX, baseY = self:findOrigin()

	local boxOverlay = nil

	self.marginWidth, self.marginHeight = self.gameInfoDisplay:scalePixelToScreenVector({ 8, 8 })

	if ( g_animalInspector.displayMode % 2 == 0 ) then -- top right
		boxOverlay = Overlay.new(self.bgName, baseX, baseY - self.marginHeight, 1, 1)
	else -- default to 1
		boxOverlay = Overlay.new(self.bgName, baseX, baseY + self.marginHeight, 1, 1)
	end

	local boxElement = HUDElement.new(boxOverlay)

	self.inspectBox = boxElement

	self.inspectBox:setUVs(GuiUtils.getUVs(self.boxBGColor))
	self.inspectBox:setColor(unpack(SpeedMeterDisplay.COLOR.GEARS_BG))
	self.inspectBox:setVisible(false)
	self.gameInfoDisplay:addChild(boxElement)

	self.inspectText.marginWidth, self.inspectText.marginHeight = self.gameInfoDisplay:scalePixelToScreenVector({g_animalInspector.setValueTextMarginX, g_animalInspector.setValueTextMarginY})
	self.inspectText.size = self.gameInfoDisplay:scalePixelToScreenHeight(g_animalInspector.setValueTextSize)
end

function AnimalInspector:delete()
	-- clean up on remove
	if self.inspectBox ~= nil then
		self.inspectBox:delete()
	end
end

function AnimalInspector:saveSettings()
	local savegameFolderPath = ('%smodSettings/FS22_AnimalExplorer/savegame%d'):format(getUserProfileAppPath(), g_currentMission.missionInfo.savegameIndex)
	local savegameFile = savegameFolderPath .. "/animalInspector.xml"

	if ( not fileExists(savegameFile) ) then
		createFolder(('%smodSettings/FS22_AnimalExplorer'):format(getUserProfileAppPath()))
		createFolder(savegameFolderPath)
	end

	local key = "animalInspector"
	local xmlFile = createXMLFile(key, savegameFile, key)

	for _, setting in pairs(g_animalInspector.settingsNames) do
		if ( setting[2] == "bool" ) then
			setXMLBool(xmlFile, key .. "." .. setting[1] .. "#value", g_animalInspector[setting[1]])
		elseif ( setting[2] == "string" ) then
			setXMLString(xmlFile, key .. "." .. setting[1] .. "#value", g_animalInspector[setting[1]])
		elseif ( setting[2] == "int" ) then
			setXMLInt(xmlFile, key .. "." .. setting[1] .. "#value", g_animalInspector[setting[1]])
		elseif ( setting[2] == "float" ) then
			setXMLFloat(xmlFile, key .. "." .. setting[1] .. "#value", g_animalInspector[setting[1]])
		elseif ( setting[2] == "color" ) then
			local r, g, b, a = unpack(g_animalInspector[setting[1]])
			setXMLFloat(xmlFile, key .. "." .. setting[1] .. "#r", r)
			setXMLFloat(xmlFile, key .. "." .. setting[1] .. "#g", g)
			setXMLFloat(xmlFile, key .. "." .. setting[1] .. "#b", b)
			setXMLFloat(xmlFile, key .. "." .. setting[1] .. "#a", a)
		end
	end

	saveXMLFile(xmlFile)
	print("~~" .. g_animalInspector.myName .." :: saved config file")
end

function AnimalInspector:loadSettings()
	local savegameFolderPath = ('%smodSettings/FS22_AnimalExplorer/savegame%d'):format(getUserProfileAppPath(), g_currentMission.missionInfo.savegameIndex)
	local key = "animalInspector"

	if fileExists(savegameFolderPath .. "/animalInspector.xml") then
		print("~~" .. self.myName .." :: loading config file")
		local xmlFile = loadXMLFile(key, savegameFolderPath .. "/animalInspector.xml")

		for _, setting in pairs(self.settingsNames) do
			if ( setting[2] == "bool" ) then
				g_animalInspector[setting[1]] = Utils.getNoNil(getXMLBool(xmlFile, key .. "." .. setting[1] .. "#value"), g_animalInspector[setting[1]])
			elseif ( setting[2] == "string" ) then
				g_animalInspector[setting[1]] = Utils.getNoNil(getXMLString(xmlFile, key .. "." .. setting[1] .. "#value"), g_animalInspector[setting[1]])
			elseif ( setting[2] == "int" ) then
				g_animalInspector[setting[1]] = Utils.getNoNil(getXMLInt(xmlFile, key .. "." .. setting[1] .. "#value"), g_animalInspector[setting[1]])
			elseif ( setting[2] == "float" ) then
				g_animalInspector[setting[1]] = Utils.getNoNil(getXMLFloat(xmlFile, key .. "." .. setting[1] .. "#value"), g_animalInspector[setting[1]])
			elseif ( setting[2] == "color" ) then
				local r, g, b, a = unpack(g_animalInspector[setting[1]])
				r = Utils.getNoNil(getXMLFloat(xmlFile, key .. "." .. setting[1] .. "#r"), r)
				g = Utils.getNoNil(getXMLFloat(xmlFile, key .. "." .. setting[1] .. "#g"), g)
				b = Utils.getNoNil(getXMLFloat(xmlFile, key .. "." .. setting[1] .. "#b"), b)
				a = Utils.getNoNil(getXMLFloat(xmlFile, key .. "." .. setting[1] .. "#a"), a)
				g_animalInspector[setting[1]] = {r, g, b, a}
			end
		end

		delete(xmlFile)

		g_animalInspector.inspectText.size = g_animalInspector.gameInfoDisplay:scalePixelToScreenHeight(g_animalInspector.setValueTextSize)
	end
end

function AnimalInspector:registerActionEvents()
	local _, reloadConfig = g_inputBinding:registerActionEvent('AnimalInspector_reload_config', self,
		AnimalInspector.actionReloadConfig, false, true, false, true)
	g_inputBinding:setActionEventTextVisibility(reloadConfig, false)
	local _, toggleVisible = g_inputBinding:registerActionEvent('AnimalInspector_toggle_visible', self,
		AnimalInspector.actionToggleVisible, false, true, false, true)
	g_inputBinding:setActionEventTextVisibility(toggleVisible, false)
end

function AnimalInspector:actionReloadConfig()
	local thisModEnviroment = getfenv(0)["g_animalInspector"]
	if ( thisModEnviroment.debugMode ) then
		print("~~" .. thisModEnviroment.myName .." :: reload settings from disk")
	end
	thisModEnviroment:loadSettings()
end

function AnimalInspector:actionToggleVisible()
	local thisModEnviroment = getfenv(0)["g_animalInspector"]
	if ( thisModEnviroment.debugMode ) then
		print("~~" .. thisModEnviroment.myName .." :: toggle display on/off")
	end
	thisModEnviroment.isEnabledVisible = (not thisModEnviroment.isEnabledVisible)
	thisModEnviroment:saveSettings()
end

function AnimalInspector.initGui(self)
	local boolMenuOptions = {
		"Visible", "ShowCount", "ShowFood", "ShowFoodTypes", "ShowProductivity",
		"ShowReproduction", "ShowOutputs","ShowPuberty", "ShowHealth", "TextBold"
	}

	if not g_animalInspector.createdGUI then -- Skip if we've already done this once
		g_animalInspector.createdGUI = true

		self.menuOption_DisplayMode = self.checkInvertYLook:clone()
		self.menuOption_DisplayMode.target = g_animalInspector
		self.menuOption_DisplayMode.id = "animalInspector_DisplayMode"
		self.menuOption_DisplayMode:setCallback("onClickCallback", "onMenuOptionChanged_DisplayMode")
		self.menuOption_DisplayMode:setDisabled(false)

		local settingTitle = self.menuOption_DisplayMode.elements[4]
		local toolTip = self.menuOption_DisplayMode.elements[6]

		self.menuOption_DisplayMode:setTexts({
			g_i18n:getText("setting_animalInspector_DisplayMode1"),
			g_i18n:getText("setting_animalInspector_DisplayMode2"),
			g_i18n:getText("setting_animalInspector_DisplayMode3"),
			g_i18n:getText("setting_animalInspector_DisplayMode4")
		})

		settingTitle:setText(g_i18n:getText("setting_animalInspector_DisplayMode"))
		toolTip:setText(g_i18n:getText("toolTip_animalInspector_DisplayMode"))

		self.menuOption_TextSize = self.checkInvertYLook:clone()
		self.menuOption_TextSize.target = g_animalInspector
		self.menuOption_TextSize.id = "animalInspector_setValueTextSize"
		self.menuOption_TextSize:setCallback("onClickCallback", "onMenuOptionChanged_setValueTextSize")
		self.menuOption_TextSize:setDisabled(false)

		settingTitle = self.menuOption_TextSize.elements[4]
		toolTip = self.menuOption_TextSize.elements[6]

		local textSizeTexts = {}
		for _, size in ipairs(g_animalInspector.menuTextSizes) do
			table.insert(textSizeTexts, tostring(size) .. " px")
		end
		self.menuOption_TextSize:setTexts(textSizeTexts)

		settingTitle:setText(g_i18n:getText("setting_animalInspector_TextSize"))
		toolTip:setText(g_i18n:getText("toolTip_animalInspector_TextSize"))


		for _, optName in pairs(boolMenuOptions) do
			local fullName = "menuOption_" .. optName

			self[fullName]           = self.checkInvertYLook:clone()
			self[fullName]["target"] = g_animalInspector
			self[fullName]["id"]     = "animalInspector_" .. optName
			self[fullName]:setCallback("onClickCallback", "onMenuOptionChanged_boolOpt")
			self[fullName]:setDisabled(false)

			local settingTitle = self[fullName]["elements"][4]
			local toolTip      = self[fullName]["elements"][6]

			self[fullName]:setTexts({g_i18n:getText("ui_no"), g_i18n:getText("ui_yes")})

			settingTitle:setText(g_i18n:getText("setting_animalInspector_" .. optName))
			toolTip:setText(g_i18n:getText("toolTip_animalInspector_" .. optName))
		end

		local title = TextElement.new()
		title:applyProfile("settingsMenuSubtitle", true)
		title:setText(g_i18n:getText("title_animalInspector"))

		self.boxLayout:addElement(title)
		self.boxLayout:addElement(self.menuOption_DisplayMode)
		for _, value in ipairs(boolMenuOptions) do
			local thisOption = "menuOption_" .. value
			self.boxLayout:addElement(self[thisOption])
		end
		self.boxLayout:addElement(self.menuOption_TextSize)
	end

	self.menuOption_DisplayMode:setState(g_animalInspector.displayMode)
	for _, value in ipairs(boolMenuOptions) do
		local thisMenuOption = "menuOption_" .. value
		local thisRealOption = "isEnabled" .. value
		self[thisMenuOption]:setIsChecked(g_animalInspector[thisRealOption])
	end

	local textSizeState = 3 -- backup value for it set odd in the xml.
	for idx, textSize in ipairs(g_animalInspector.menuTextSizes) do
		if g_animalInspector.setValueTextSize == textSize then
			textSizeState = idx
		end
	end
	self.menuOption_TextSize:setState(textSizeState)
end

function AnimalInspector:onMenuOptionChanged_DisplayMode(state)
	self.displayMode = state
	AnimalInspector:saveSettings()
end

function AnimalInspector:onMenuOptionChanged_setValueTextSize(state)
	self.setValueTextSize = g_animalInspector.menuTextSizes[state]
	self.inspectText.size = self.gameInfoDisplay:scalePixelToScreenHeight(self.setValueTextSize)
	AnimalInspector:saveSettings()
end

function AnimalInspector:onMenuOptionChanged_boolOpt(state, info)
	local thisOption = "isEnabled" .. string.sub(info.id,17)
	self[thisOption] = state == CheckedOptionElement.STATE_CHECKED
	AnimalInspector:saveSettings()
end