-- Shared tuning values for the hill climb game.
-- Both the server (physics, world) and client (HUD) read from here.

local Config = {}

-- World
Config.Gravity = 120          -- lower than default (196) so the buggy can climb steeper hills
Config.RoadLength = 5000      -- total length of the track in studs
Config.SegmentLength = 6      -- length of each road slab; smaller = smoother hills
Config.TrackWidth = 34        -- how wide the road is
Config.StartX = 30            -- where the car spawns along the track

-- Car
Config.WheelSpeed = 60        -- top wheel spin speed (rad/s) at full throttle
Config.MotorTorque = 60000    -- how much grunt the drive wheels have
Config.DriveSign = -1         -- flip to 1 if the car drives backwards (see README)

-- Fuel
Config.MaxFuel = 100
Config.FuelBurn = 5           -- fuel used per second at full throttle
Config.FuelPerCan = 35        -- fuel refilled per can
Config.FuelCanSpacing = 170   -- studs between fuel cans

-- Terrain height profile. Sum of sine waves gives natural rolling hills.
-- The first stretch (x < StartX) is flat so the car has a calm launch pad.
function Config.HeightAt(x)
	if x < Config.StartX then
		return 4
	end
	local t = x - Config.StartX
	return 4
		+ math.sin(t * 0.012) * 16
		+ math.sin(t * 0.027) * 8
		+ math.sin(t * 0.061) * 3
end

return Config
