--CCRedirection by : RamiLego4Game--
--Vars--
shell.run("clear")
term.setTextColor(colors.white)
local homeD = "/CCR/"

if not fs.exists(homeD.."Levels") then
	error("Please Change homeD to the Game Path")
end

if not fs.exists(homeD.."log") then
	error("Log not in Path")
else
	os.loadAPI(homeD.."log")
end

if not fs.exists(homeD.."Logs/") then
	fs.makeDir(homeD.."Logs/")
end

local logn = homeD.."Logs/" .. log.bestname("Log",homeD.."Logs/")
local TermW,TermH = term.getSize()

local tScreen = {}
local oScreen = {}
local InterFace = {}
local aExits = 0
local fExit = "nop"
local Tick = os.startTimer(1)

InterFace.cBar = colors.orange
InterFace.cExit = colors.red
InterFace.cBarText = colors.gray

local cG = colors.lightGray
local cW = colors.gray
local cS = colors.black
local cR1 = colors.lightBlue
local cR2 = colors.red
local cR3 = colors.green
local cR4 = colors.yellow

local tArgs = { ... }

log.add("Info","Vars Section Done",logn)
--Functions--
local function printCentred( yc, stg )
	local xc = math.floor((TermW - string.len(stg)) / 2)
	term.setCursorPos(xc,yc)
	--term.clearLine()
	term.write( stg )
end

local function reMap()
	log.add("Info","Screen Clearing Started",logn)
	tScreen = nil
	tScreen = {}
	for x=1,TermW do
		tScreen[x] = {}
		for y=1,TermH-1 do
			tScreen[x][y] = { space = true, wall = false, ground = false, robot = "zz", start = "zz", exit = "zz" }
		end
	end
	log.add("Info","Screen Clearing Done",logn)
end

local function tablecopy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

local function buMap()
	log.add("Info","Screen Backup Started",logn)
	oScreen = nil
	oScreen = {}
	for x=1,TermW do
		oScreen[x] = {}
		for y=1,TermH-1 do
			oScreen[x][y] = tablecopy(tScreen[x][y])
		end
	end
	log.add("Info","Screen Backup Done",logn)
end

local function addRobot(x,y,side,color)
	local obj = tScreen[x][y]
	local data = side..color
	if obj.wall == nil and obj.robot == nil then
		tScreen[x][y].robot = data
	else
		obj.wall = nil
		obj.robot = "zz"
		tScreen[x][y].robot = data
	end
end

local function addStart(x,y,side,color)
	local obj = tScreen[x][y]
	local data = side..color
	if obj.wall == nil and obj.space == nil then
		tScreen[x][y].start = data
	else
		obj.wall = nil
		obj.space = nil
		tScreen[x][y].start = data
	end
	aExits = aExits+1
end

local function addGround(x,y)
	local obj = tScreen[x][y]
	if obj.space == nil and obj.exit == nil and obj.wall == nil and obj.robot == nil and obj.start == nil then
		tScreen[x][y].ground = true
	else
		obj.space = nil
		obj.exit = "zz"
		obj.wall = nil
		obj.robot = "zz"
		obj.start = "zz"
		tScreen[x][y].ground = true
	end
end

local function addExit(x,y,cl)
	local obj = tScreen[x][y]
	if obj.space == nil and obj.ground == nil and obj.wall == nil and obj.robot == nil and obj.start == nil then
		tScreen[x][y].exit = cl
	else
		obj.space = nil
		obj.ground = nil
		obj.wall = nil
		obj.robot = "zz"
		obj.start = "zz"
		tScreen[x][y].exit = cl
	end
end

local function addWall(x,y)
	local obj = tScreen[x][y]
	if obj.space == nil and obj.exit == nil and obj.ground == nil and obj.robot == nil and obj.start == nil then
		tScreen[x][y].wall = true
	else
		obj.space = nil
		obj.exit = nil
		obj.ground = nil
		obj.robot = nil
		obj.start = nil
		tScreen[x][y].wall = true
	end
end

local function loadLevel(nNum)
	log.add("Info","Loading Level#"..tostring(nNum),logn)
	if nNum == nil then return error("nNum == nil") end
	local sDir = homeD.."Levels/"
	local sLevelD = sDir.."Level#"..tostring(nNum)
	if not ( fs.exists(sLevelD) or fs.isDir(sLevelD) ) then return error("Level Not Exists : "..sLevelD) end
	reMap()
	fLevel = fs.open(sLevelD,"r")
	local Line = 0
	local wl = true
	local Lines = 1
	local xSize = string.len(fLevel.readLine())
	while wl do
		local wLine = fLevel.readLine()
		if wLine == nil then
			fLevel.close()
			wl = false
		else
			Lines = Lines + 1
		end
	end
	log.add("Info","Level Size"..Lines.."/"..tostring(xSize),logn)
	if ((Lines + 1) > TermH) or (xSize > TermW) then return error("Level#"..tostring(nNum).." Don't Fit Screen") end
	log.add("Info","Level#"..tostring(nNum).." Lines = "..tostring(Lines),logn)
	fLevel = fs.open(sLevelD,"r")
	for Line=1,Lines do
		sLine = fLevel.readLine()
		local chars = string.len(sLine)
		for char = 1, chars do
			local el = string.sub(sLine,char,char)
			if el == "b" then
				addGround(char,Line)
			elseif el == "c" then
				addStart(char,Line,"a","a")
			elseif el == "d" then
				addStart(char,Line,"a","b")
			elseif el == "e" then
				addStart(char,Line,"a","c")
			elseif el == "f" then
				addStart(char,Line,"a","d")
			elseif el == "g" then
				addStart(char,Line,"b","a")
			elseif el == "h" then
				addStart(char,Line,"b","b")
			elseif el == "i" then
				addStart(char,Line,"b","c")
			elseif el == "j" then
				addStart(char,Line,"b","d")
			elseif el == "k" then
				addStart(char,Line,"c","a")
			elseif el == "l" then
				addStart(char,Line,"c","b")
			elseif el == "m" then
				addStart(char,Line,"c","c")
			elseif el == "n" then
				addStart(char,Line,"c","d")
			elseif el == "o" then
				addStart(char,Line,"d","a")
			elseif el == "p" then
				addStart(char,Line,"d","b")
			elseif el == "q" then
				addStart(char,Line,"d","c")
			elseif el == "r" then
				addStart(char,Line,"d","d")
			elseif el == "s" then
				addExit(char,Line,"a")
			elseif el == "t" then
				addExit(char,Line,"b")
			elseif el == "u" then
				addExit(char,Line,"c")
			elseif el == "v" then
				addExit(char,Line,"d")
			elseif el == "w" then
				addWall(char,Line)
			end
		end
	end
	log.add("Info","Loading Level#"..tostring(nNum).." Done",logn)
end

local function drawMap()
	log.add("Info","Drawing Map",logn)
	for x=1,TermW do
		for y=1,TermH-1 do
		  
			local obj = tScreen[x][y]
			if obj.ground == true then
				paintutils.drawPixel(x,y+1,cG)
			end
			if obj.wall == true then
				paintutils.drawPixel(x,y+1,cW)
			end
		 
		 local ex = tostring(tScreen[x][y].exit)
			if not(ex == "zz" or ex == "nil") then
				if ex == "a" then
					ex = cR1
				elseif ex == "b" then
					ex = cR2
				elseif ex == "c" then
					ex = cR3
				elseif ex == "d" then
					ex = cR4
				else
					return error("Exit Color Out")
				end
				term.setBackgroundColor(cG)
				term.setTextColor(ex)
				term.setCursorPos(x,y+1)
				print("X")
			end
		 
		 local st = tostring(tScreen[x][y].start)
			if not(st == "zz" or st == "nil") then
				local Cr = string.sub(st,2,2)
				if Cr == "a" then
					Cr = cR1
				elseif Cr == "b" then
					Cr = cR2
				elseif Cr == "c" then
					Cr = cR3
				elseif Cr == "d" then
					Cr = cR4
				else
					log.add("Error",st..Cr,logn)
					return error("Start Color Out")
				end
			
				term.setTextColor(Cr)
			term.setBackgroundColor(cG)
				term.setCursorPos(x,y+1)
			
				sSide = string.sub(st,1,1)
				if sSide == "a" then
					print("^")
				elseif sSide == "b" then
					print(">")
				elseif sSide == "c" then
					print("v")
				elseif sSide == "d" then
					print("<")
				else
					print("@")
				end
			end
			
			if obj.space == true then
				paintutils.drawPixel(x,y+1,cS)
			end
			
			local rb = tostring(tScreen[x][y].robot)
			if not(rb == "zz" or rb == "nil") then
				local Cr = string.sub(rb,2,2)
				if Cr == "a" then
					Cr = cR1
				elseif Cr == "b" then
					Cr = cR2
				elseif Cr == "c" then
					Cr = cR3
				elseif Cr == "d" then
					Cr = cR4
				else
					Cr = colors.white
				end
				term.setBackgroundColor(Cr)
				term.setTextColor(colors.white)
				term.setCursorPos(x,y+1)
				sSide = string.sub(rb,1,1)
				if sSide == "a" then
					print("^")
				elseif sSide == "b" then
					print(">")
				elseif sSide == "c" then
					print("v")
				elseif sSide == "d" then
					print("<")
				else
					print("@")
				end
			end
		end
	end
	log.add("Info","Drawing Map Done",logn)
end

local function isBrick(x,y)
	local brb = tostring(oScreen[x][y].robot)
	local bobj = oScreen[x][y]
	if (brb == "zz" or brb == "nil") and not bobj.wall == true then
		return false
	else
		return true
	end
end

local function gRender(bFirst)
	drawMap()
	if bFirst == "start" then
		log.add("Info","Create Instate of Render",logn)
		for x=1,TermW do
			for y=1,TermH-1 do
				local st = tostring(tScreen[x][y].start)
				if not(st == "zz" or st == "nil") then
					local Cr = string.sub(st,2,2)
					local sSide = string.sub(st,1,1)
					addRobot(x,y,sSide,Cr)
				end
			end
		end
		log.add("Info","Create End",logn)
	else
		buMap()
		for x=1,TermW do
			for y=1,TermH-1 do
				local rb = tostring(oScreen[x][y].robot)
				if not(rb == "zz" or rb == "nil") then
					local Cr = string.sub(rb,2,2)
					local sSide = string.sub(rb,1,1)
					local sobj = oScreen[x][y]
					if sobj.space == true then
						tScreen[x][y].robot = "zz"
						if not sSide == "g" then
							addRobot(x,y,"g",Cr)
						end
					elseif sobj.exit == Cr then
						if sSide == "a" or sSide == "b" or sSide == "c" or sSide == "d" then
						tScreen[x][y].robot = "zz"
						addRobot(x,y,"g",Cr)
						aExits = aExits-1
						log.add("Exit","Robot on Exit",logn)
						end
					elseif sSide == "a" then
						local obj = isBrick(x,y-1)
						tScreen[x][y].robot = "zz"
						if not obj == true then
							addRobot(x,y-1,sSide,Cr)
						else
							local obj2 = isBrick(x-1,y)
							local obj3 = isBrick(x+1,y)
							if not obj2 == true and not obj3 == true then
								if Cr == "a" or Cr == "c" then
									addRobot(x,y,"d",Cr)
								elseif Cr == "b" or Cr == "d" then
									addRobot(x,y,"b",Cr)
								end
							elseif obj == true and obj2 == true and obj3 == true then
								addRobot(x,y,"c",Cr)
							else
								if obj3 == true then
									addRobot(x,y,"d",Cr)
								elseif obj2 == true then
									addRobot(x,y,"b",Cr)
								end
							end
						end
					elseif sSide == "b" then
						local obj = isBrick(x+1,y)
						tScreen[x][y].robot = "zz"
						if not obj == true then
							addRobot(x+1,y,sSide,Cr)
						else
							local obj2 = isBrick(x,y-1)
							local obj3 = isBrick(x,y+1)
							if not obj2 == true and not obj3 == true then
								if Cr == "a" or Cr == "c" then
									addRobot(x,y,"a",Cr)
								elseif Cr == "b" or Cr == "d" then
									addRobot(x,y,"c",Cr)
								end
							elseif obj == true and obj2 == true and obj3 == true then
								addRobot(x,y,"d",Cr)
							else
								if obj3 == true then
									addRobot(x,y,"a",Cr)
								elseif obj2 == true then
									addRobot(x,y,"c",Cr)
								end
							end
						end
					elseif sSide == "c" then
						local obj = isBrick(x,y+1)
						tScreen[x][y].robot = "zz"
						if not obj == true then
							addRobot(x,y+1,sSide,Cr)
						else
							local obj2 = isBrick(x-1,y)
							local obj3 = isBrick(x+1,y)
							if not obj2 == true and not obj3 == true then
								if Cr == "a" or Cr == "c" then
									addRobot(x,y,"d",Cr)
								elseif Cr == "b" or Cr == "d" then
									addRobot(x,y,"b",Cr)
								end
							elseif obj == true and obj2 == true and obj3 == true then
								addRobot(x,y,"a",Cr)
							else
								if obj3 == true then
									addRobot(x,y,"d",Cr)
								elseif obj2 == true then
									addRobot(x,y,"b",Cr)
								end
							end
						end
					elseif sSide == "d" then
						local obj = isBrick(x-1,y)
						tScreen[x][y].robot = "zz"
						if not obj == true then
							addRobot(x-1,y,sSide,Cr)
						else
							local obj2 = isBrick(x,y-1)
							local obj3 = isBrick(x,y+1)
							if not obj2 == true and not obj3 == true then
								if Cr == "a" or Cr == "c" then
									addRobot(x,y,"c",Cr)
								elseif Cr == "b" or Cr == "d" then
									addRobot(x,y,"a",Cr)
								end
							elseif obj == true and obj2 == true and obj3 == true then
								addRobot(x,y,"b",Cr)
							else
								if obj3 == true then
									addRobot(x,y,"a",Cr)
								elseif obj2 == true then
									addRobot(x,y,"c",Cr)
								end
							end
						end
					else
						addRobot(x,y,sSide,"g")
					end
				end
			end
		end
	end
end

function InterFace.drawBar()
	term.setTextColor(InterFace.cBarText)
	paintutils.drawLine( 1, 1, TermW-1, 1, InterFace.cBar)
	printCentred( 1, "CCRedirection" )
	term.setBackgroundColor(InterFace.cExit)
	term.setCursorPos(TermW,1)
	write("X")
	term.setBackgroundColor(colors.black)
end

function InterFace.render()
	local id,p1,p2,p3 = os.pullEvent()
	log.add("Event",id,logn)
	if id == "mouse_click" then
		if p3 == 1 then
			if p2 == TermW then
				return "end"
			end
		else
			--local eobj = tScreen[p2][p3]
			local eobj = tScreen[p2][p3-1]
			local erobj = tostring(tScreen[p2][p3-1].robot)
			if (erobj == "zz" or erobj == "nil") and not eobj.wall == true and not eobj.space == true then
				addWall(p2,p3-1)
				drawMap()
			end
		end
	elseif id == "timer" and p1 == Tick then
		gRender("nop")
		Tick = os.startTimer(1)
	end
end

log.add("Info","Functions Section Done",logn)
--Launcher--
local function launch()
	if #tArgs > 0 then
		loadLevel(tArgs[1])
	else
		loadLevel(0)
	end
	local create = true
	drawMap()
	InterFace.drawBar()
	gRender("start")
	
	local NExit = true
	if aExits == 0 then
		NExit = false
	end
	
	while true do
		local isExit = InterFace.render()
		if isExit == "end" or fExit == "yes" then
			break
		end
		if aExits == 0 and NExit == true then
			fExit = "yes"
		end
	end
	log.add("Info","End Of Game",logn)
	os.unloadAPI("log")
	shell.run("clear")
end

--Error Handelling--
isErr,err = pcall(launch)
if not isErr then
	shell.run("clear")
	if logn == nil then
		local homeD = "/CCR/"
		local logn = homeD.."Logs/" .. log.bestname("Log","/CCR/Logs/")
	end
	log.add("Error",err,logn)
	if term.isColor() then
		term.setTextColor(colors.red)
	end
	print("Error, Send ("..logn..") to RamiLego")
	print("The error is : "..err)
	os.unloadAPI("log")
end
