ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Spawnable = false

ENT.Model = Model( "models/props/cs_office/tv_plasma.mdl" )

ENT.MediaPlayerType = "entity"
ENT.IsMediaPlayerEntity = true

function ENT:Initialize()

	if SERVER then
		self:SetModel( self.Model )

		self:SetUseType( SIMPLE_USE )

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )

		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end

		-- Install media player to entity
		local mp = self:InstallMediaPlayer( self.MediaPlayerType )

		-- Network media player ID
		self:SetMediaPlayerID( mp:GetId() )
	end

	-- Apply player config based on model
	self.PlayerConfig = self:GetMediaPlayerConfig()
end

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "MediaPlayerID" )
end

function ENT:OnRemove()
	local mp = self:GetMediaPlayer()
	if mp then
		mp:Remove()
	end
end

function ENT:GetMediaPlayerConfig()
	local model = self:GetModel()
	local MPModelConfigs = list.Get( "MediaPlayerModelConfigs" )
	local config = MPModelConfigs and MPModelConfigs[model] or self.PlayerConfig
	return config
end
