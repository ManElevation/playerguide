-- By ManElevation
--GNU
local playerguide_Book_title="Help Guide"

local playerguide_Tab_Text_1="\nFor MissDejavu \nBy ManElevation"                                                                                                              

local playerguide_Tab_1="Guide"

local function playerguide_guide(user,text_to_show)
local text=""
if text_to_show==1 then text=playerguide_Tab_Text_1 end

local form="size[8.5,9]" ..default.gui_bg..default.gui_bg_img..
	"button[0,0;1.5,1;tab1;" .. playerguide_Tab_1 .. "]" ..
	"button_exit[7.5,0; 1,1;tab6;X]" ..
	"label[0,1;"..text .."]"
minetest.show_formspec(user:get_player_name(), "playerguide",form)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="playerguide" then
	if pressed.tab1 then playerguide_guide(player,1) end
	end
end)


minetest.register_tool("playerguide:book", {
	description = serverguide_Book_title,
	inventory_image = "default_book.png",
	on_use = function(itemstack, user, pointed_thing)
	playerguide_guide(user,1)
	return itemstack
	end,
on_place = function(itemstack, placer, pointed_thing)
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	local def = node and minetest.registered_nodes[node.name]
	if not def or not def.buildable_to then
		pos = pointed_thing.above
		node = minetest.get_node_or_nil(pos)
		def = node and minetest.registered_nodes[node.name]
		if not def or not def.buildable_to then return itemstack end
	end
	if minetest.is_protected(pos, placer:get_player_name()) then return itemstack end
	local fdir = minetest.dir_to_facedir(placer:get_look_dir())
	minetest.set_node(pos, {name = "playerguide:guide",param2 = fdir,})
	itemstack:take_item()
	return itemstack
end
})
minetest.register_alias("guide", "playerguide:book")
minetest.register_craft({output = "playerguide:book",recipe = {{"default:stick","default:stick"},}})
minetest.register_on_newplayer(function(player)
player:get_inventory():add_item("main", "playerguide:book")
end)
