function love.load()
	json = require("dkjson")
	drawingCanvas = love.graphics.newCanvas(200,200)
	resolutionMult = 1
end

function love.update(dt)
	
end

function love.draw()
	local spacing = 16
	if not hasFile then
		love.graphics.print("Please drop a .json file!",5,5)
		love.graphics.print(resolutionMult.."x Resolution",5,5+spacing*1)
		love.graphics.print("Scroll to change",300,5+spacing*1)
	else
		love.graphics.print("Successfully exported at "..resultScale.." x Resolution",5,5)
		love.graphics.print(resolutionMult.."x Resolution",5,5+spacing*1)
		love.graphics.print("Scroll to change",300,5+spacing*1)
		love.graphics.print("Original Scale: "..(resultDimensions[1]/resultScale).." x "..(resultDimensions[2]/resultScale),5,5+spacing*2)
		love.graphics.print("Scaled Resolution: "..resultDimensions[1].." x "..resultDimensions[2],5,5+spacing*3)
		love.graphics.print(resultName,5,5+spacing*4)
	end
end

function love.filedropped(file)
	hasFile = true
	local data = file:read()
	local shapes = json.decode(data)
	local fileName = file:getFilename()
	fileName = fileName:match("([^\\/]+)$").."_"..tostring(resolutionMult).."x_render"
	
	local width = shapes[1]["data"][3]*resolutionMult
	local height = shapes[1]["data"][4]*resolutionMult
	--love.window.setMode(width,height)
	drawingCanvas = love.graphics.newCanvas(width,height)
	
	love.graphics.setLineWidth(1)
	love.graphics.setCanvas(drawingCanvas)
	love.graphics.clear()
	love.graphics.rectangle("fill",0,0,width,height)
	love.graphics.push()
	love.graphics.scale(resolutionMult,resolutionMult)
		for _,shape in ipairs(shapes) do
			love.graphics.setColor(shape.color[1]/255,shape.color[2]/255,shape.color[3]/255,shape.color[4]/255)
			if     shape.type == 0 then				--Rectangle
				love.graphics.rectangle("fill",shape.data[1],shape.data[2],shape.data[3]-shape.data[1],shape.data[4]-shape.data[2])
			elseif shape.type == 1 then				--Rotated Rectangle
				local x1,y1,x2,y2,angleDeg = unpack(shape.data)
				local cx = (x1 + x2) / 2
				local cy = (y1 + y2) / 2
				local w = math.abs(x2 - x1)
				local h = math.abs(y2 - y1)

				love.graphics.push()
				love.graphics.translate(cx, cy)
				love.graphics.rotate(math.rad(angleDeg))
				love.graphics.rectangle("fill", -w/2, -h/2, w, h)
				love.graphics.pop()
			elseif shape.type == 2 then				--Triangle
				love.graphics.polygon("fill",shape.data)
			elseif shape.type == 3 then				--Ellipse
				love.graphics.ellipse("fill",shape.data[1],shape.data[2],shape.data[3],shape.data[4])
			elseif shape.type == 4 then				--Rotated Ellipse
				love.graphics.push()
				love.graphics.translate(shape.data[1], shape.data[2])
				love.graphics.rotate(math.rad(shape.data[5]))
				love.graphics.ellipse("fill",0,0,shape.data[3],shape.data[4])
				love.graphics.pop()
			elseif shape.type == 5 then				--Circle
				love.graphics.circle("fill",shape.data[1],shape.data[2],shape.data[3])
			elseif shape.type == 6 then				--Line
				love.graphics.line(shape.data)
			elseif shape.type == 7 then				--Quadratic Bezier
				local x1,y1,cx,cy,x2,y2 = unpack(shape.data)
				local points = {}
					local steps = 32 -- more steps = smoother curve
					for i = 0, steps do
						local t = i / steps
						local xt = (1 - t)^2 * x1 + 2 * (1 - t) * t * cx + t^2 * x2
						local yt = (1 - t)^2 * y1 + 2 * (1 - t) * t * cy + t^2 * y2
						table.insert(points, xt)
						table.insert(points, yt)
					end
					love.graphics.line(points)
			end
		end
	love.graphics.pop()
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	
	local img = drawingCanvas:newImageData()
	img:encode("png", fileName..".png")
	resultDimensions = {width,height}
	resultName = fileName..".png"
	resultScale = resolutionMult
	love.draw()
end

function love.wheelmoved( x, y )
	resolutionMult = resolutionMult + y
	resolutionMult = math.max(1,resolutionMult)
end