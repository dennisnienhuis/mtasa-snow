--[[GUIEditor_Window = {}
GUIEditor_Button = {}
GUIEditor_Label = {}
GUIEditor_Edit = {}

GUIEditor_Window[1] = guiCreateWindow(333,285,327,372,"Snow creator",false)
GUIEditor_Button[1] = guiCreateButton(10,322,308,23,"Save snow",false,GUIEditor_Window[1])
GUIEditor_Label[1] = guiCreateLabel(11,349,308,13,"Press 'm' to disable/enable your mouse",false,GUIEditor_Window[1])
guiLabelSetHorizontalAlign(GUIEditor_Label[1],"center",false)



GUIEditor_Button[2] = guiCreateButton(9,41,146,29,"Select point1",false,GUIEditor_Window[1])
GUIEditor_Button[3] = guiCreateButton(9,76,146,29,"Select point2",false,GUIEditor_Window[1])
GUIEditor_Button[4] = guiCreateButton(9,109,146,29,"Select point3",false,GUIEditor_Window[1])
GUIEditor_Button[5] = guiCreateButton(9,143,146,29,"Select point4",false,GUIEditor_Window[1])
GUIEditor_Edit[1] = guiCreateEdit(162,46,140,21,"banaan",false,GUIEditor_Window[1])
GUIEditor_Edit[2] = guiCreateEdit(162,79,140,21,"",false,GUIEditor_Window[1])
GUIEditor_Edit[3] = guiCreateEdit(162,112,140,21,"",false,GUIEditor_Window[1])
GUIEditor_Edit[4] = guiCreateEdit(162,145,140,21,"",false,GUIEditor_Window[1])
GUIEditor_Label[2] = guiCreateLabel(11,19,308,18,"Road texture creating:",false,GUIEditor_Window[1])
GUIEditor_Label[3] = guiCreateLabel(11,175,308,18,"Walkways texture creating:",false,GUIEditor_Window[1])




GUIEditor_Button[6] = guiCreateButton(9,195,146,29,"Select point1",false,GUIEditor_Window[1])
GUIEditor_Button[7] = guiCreateButton(9,227,146,29,"Select point2",false,GUIEditor_Window[1])
GUIEditor_Button[8] = guiCreateButton(9,259,146,29,"Select point3",false,GUIEditor_Window[1])
GUIEditor_Button[9] = guiCreateButton(9,290,146,29,"Select point4",false,GUIEditor_Window[1])
GUIEditor_Edit[5] = guiCreateEdit(162,200,140,21,"",false,GUIEditor_Window[1])
GUIEditor_Edit[6] = guiCreateEdit(162,230,140,21,"",false,GUIEditor_Window[1])
GUIEditor_Edit[7] = guiCreateEdit(162,261,140,21,"",false,GUIEditor_Window[1])
GUIEditor_Edit[8] = guiCreateEdit(162,293,140,21,"",false,GUIEditor_Window[1])
 





bindKey ( "m", "down", function ()
showCursor ( not isCursorShowing() )
end)
]]--
function putPlayerInPosition(timeslice)
	local cx,cy,cz,ctx,cty,ctz = getCameraMatrix()
	ctx,cty = ctx-cx,cty-cy
setPedRotation(localPlayer,-(math.deg(math.atan2(ctx,cty))), true )
	timeslice = timeslice*0.1
	local mult = timeslice/math.sqrt(ctx*ctx+cty*cty)
	ctx,cty = ctx*mult,cty*mult
	if getKeyState("w") then abx,aby = abx+ctx,aby+cty end
	if getKeyState("s") then abx,aby = abx-ctx,aby-cty end
	if getKeyState("d") then abx,aby = abx+cty,aby-ctx end
	if getKeyState("a") then abx,aby = abx-cty,aby+ctx end
	if getKeyState("space") then abz = abz+0.2 end
	if getKeyState("rctrl") then abz = abz-0.2 end
	setElementPosition(localPlayer,abx,aby,abz)
end





function setAirBrake(status)
	if status == true then
		abx,aby,abz = getElementPosition(localPlayer)
		addEventHandler("onClientPreRender",root,putPlayerInPosition)
	elseif status == false then
		abx,aby,abz = nil
		removeEventHandler("onClientPreRender",root,putPlayerInPosition)
	end
end











 -- SETTINGS --
--[[
local distance = 200 -- how much units far away the flakes will drop
local flakes = 1000 -- how much flakes will draw
local fallspeed = 2000 -- how much ms the falkes will fall down
local delay = 300 -- deley between spawning a flake
local snowFlakesPerTime = 100 -- how much flakes will drop in the delay

]]--


local distance = 200 -- how much units far away the flakes will drop
local flakes = 1000 -- how much flakes will draw
local fallspeed = 2000 -- how much ms the falkes will fall down
local delay = 50 -- deley between spawning a flake
local snowFlakesPerTime = 20 -- how much flakes will drop in the delay

--END SETTINGS --





--VARIABLES--

local screenWidth, screenHeight = guiGetScreenSize ( ) 
local flakeTable = {}
local starttick
local currenttick
local allflakes = 0
--END VARIABLES--



addEventHandler ( "onClientRender", root, function ()
local x,y,z = getElementPosition ( localPlayer )


	if not starttick then
		starttick = getTickCount()
	end
		currenttick = getTickCount()
	if currenttick - starttick >= delay then
		starttick = false
			if allflakes >= flakes then
				allflakes = 0
			end
		for i=1, snowFlakesPerTime do
			allflakes = allflakes + 1
		
			local startX, startY = getRandomPositionArroundElement ( localPlayer , math.random(distance) )
			local startZ = getGroundPosition (startX, startY, z) + 20
			local endX,endY,endZ = startX, startY,getGroundPosition (startX, startY, startZ)
			addFlake (allflakes,startX, startY, startZ, endX, endY, endZ)
		end
	end

	for i=1, flakes do
		if flakeTable[i] then
			local mcx, mcy, mcz = getCameraMatrix()
			local drawingX, drawingY, drawingZ = unpack(flakeTable[i].renderPos)
			local x3D, y3D = getScreenFromWorldPosition (drawingX, drawingY, drawingZ)

			if x3D and y3D then
				if isLineOfSightClear (mcx , mcy, mcz, drawingX, drawingY, drawingZ, true, true, true, true, true, false, false, nil) then
					local size = getDistanceBetweenPoints3D (x, y, z, drawingX, drawingY, drawingZ)
					
					if size <= distance then
						--dxDrawLine3D (x, y, z, drawingX, drawingY, drawingZ)
						local drawsize = (-(15/distance)*size)+15
						dxDrawImage ( x3D, y3D, drawsize,drawsize,"flakes/flake1.png")
					end
				end
			end

			if flakeTable[i].polate == true then
				local now = getTickCount()
				local elapsedTime = now - flakeTable[i].startTime
				local duration = flakeTable[i].endTime - flakeTable[i].startTime
				local progress = elapsedTime / duration
	
				local polX, polY, polZ = unpack(flakeTable[i].startPos)
				local polX2, polY2, polZ2 = unpack(flakeTable[i].endPos)
				local renderX, renderY, renderZ = interpolateBetween (polX, polY, polZ,polX2, polY2, polZ2, progress, "Linear")
				flakeTable[i].renderPos = { renderX, renderY, renderZ }

				if now >= flakeTable[i].endTime then
					flakeTable[i] = nil
				end
			end
		end
	end
end)







function addFlake ( index,startX, startY, startZ, endX, endY, endZ)
	if isLineOfSightClear (endX, endY, endZ+1, endX, endY, endZ+10, true, true, false, true, true, false, false, nil) then
		flakeTable[index] = {}
		flakeTable[index].startPos = {startX, startY, startZ}
		flakeTable[index].renderPos = {startX, startY, startZ}
		flakeTable[index].startTime = getTickCount()
		flakeTable[index].endPos = {endX, endY, endZ}
		flakeTable[index].endTime = flakeTable[index].startTime + fallspeed
		flakeTable[index].polate = true
	end
end








function getRandomPositionArroundElement ( element , meters )
	if not element or not isElement ( element ) then
		return false
	end
		local posX , posY , posZ = getElementPosition ( element )
		local rotation = math.random ( 360 )
		posX = posX - math.sin ( math.rad ( rotation ) ) * meters
		posY = posY + math.cos ( math.rad ( rotation ) ) * meters
	return posX , posY
end






