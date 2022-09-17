module IsaGrabBagEntities

using ..Ahorn, Maple
@mapdef Entity "isaBag/waterBoost" WaterBoost(x::Integer, y::Integer, boostEnabled::Bool=true)
@mapdef Entity "isaBag/zipline" Zipline(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Entity "isaBag/baddyFollow" BadelineFriend(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])

const placements = Ahorn.PlacementDict(
	"Water Boost (IsaGrabBag)" => Ahorn.EntityPlacement(
		WaterBoost,
		"rectangle",
		Dict{String, Any}(
			"boostEnabled" => true
		)
	),
	"Badeline Friend (IsaGrabBag)" => Ahorn.EntityPlacement(
		BadelineFriend,
		"rectangle"
	),
	"Zipline (IsaGrabBag)" => Ahorn.EntityPlacement(
		Zipline,
		"rectangle"
	)
)

Ahorn.nodeLimits(entity::Zipline) = 0, 2

sprite = "isafriend/helperimage.png"

function Ahorn.selection(entity::BadelineFriend)
	x, y = Ahorn.position(entity)
	return Ahorn.getSpriteRectangle("baddyAhorn.png", x, y)
	
end
function Ahorn.selection(entity::WaterBoost)
	x, y = Ahorn.position(entity)
	return Ahorn.getSpriteRectangle(sprite, x, y)
	
end

function Ahorn.selection(entity::Zipline)

	nodes = get(entity.data, "nodes", ())
    x, y = Ahorn.position(entity)

    res = [Ahorn.Rectangle(x - 8, y - 8, 16, 24)]
    
    for node in nodes
        nx, ny = Int.(node)
        
        newRes = Ahorn.Rectangle(nx - 8, y - 8, 16, 24)

        push!(res, newRes)
    end

    return res
end
function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity::WaterBoost, room::Maple.Room)
	Ahorn.drawSprite(ctx, sprite, 0, 0)
end
function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity::BadelineFriend, room::Maple.Room)
	Ahorn.drawSprite(ctx, "isafriend/baddyAhorn.png", 0, 0)
end
function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity::Zipline, room::Maple.Room)
    
    ex, ey = Ahorn.position(entity)
	
	ey = ey - 1
	
	nodes = get(entity.data, "nodes", ())
	
	minx = ex
	maxx = ex
    
    for node in nodes
        nx, ny = Int.(node)
		
		if nx < minx
			minx = nx
		end
		if nx > maxx
			maxx = nx
		end
    end
	
	minx = minx - 10
	maxx = maxx + 10
	
	Ahorn.drawRectangle(ctx, minx - ex, -2, maxx - minx, 4, (0.0, 0.0, 0.0, 1.0), (0.0, 0.0, 0.0, 0.0))
	
	Ahorn.drawRectangle(ctx, minx - ex - 1, -4, 4, 8, (0.0, 0.0, 0.0, 1.0), (0.0, 0.0, 0.0, 0.0))
	Ahorn.drawRectangle(ctx, maxx - ex - 3, -4, 4, 8, (0.0, 0.0, 0.0, 1.0), (0.0, 0.0, 0.0, 0.0))
	
	
	Ahorn.drawRectangle(ctx, minx - ex, -1, maxx - minx, 1, (0.8, 0.84, 0.9, 1.0), (0.0, 0.0, 0.0, 0.0))
	Ahorn.drawRectangle(ctx, minx - ex, 0, maxx - minx, 1, (0.55, 0.5, 0.6, 1.0), (0.0, 0.0, 0.0, 0.0))
	
	Ahorn.drawRectangle(ctx, minx - ex - 0, -3, 2, 6, (0.8, 0.84, 0.9, 1.0), (0.0, 0.0, 0.0, 0.0))
	Ahorn.drawRectangle(ctx, maxx - ex - 2, -3, 2, 6, (0.8, 0.84, 0.9, 1.0), (0.0, 0.0, 0.0, 0.0))
    
    for node in nodes
        nx, ny = Int.(node)
		
		Ahorn.drawSprite(ctx, "isafriend/objects/zipline/handle_end.png", nx - ex, 4)
    end
	
	Ahorn.drawSprite(ctx, "isafriend/objects/zipline/handle.png", 0, 4)
end

end