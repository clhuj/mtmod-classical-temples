

classical_temples = {}

-- materials

local classical_temples_materials = {
    "default:clay",
    "default:desert_sandstone",
    "default:desert_stone",
    "default:sandstone",
    "default:silver_sandstone",
    "default:stone",
}

-- collision boxes

local pediment_collision_boxes = {
    { -0.5,  -0.5, -0.5, 0.5, 0.25, 0.5 },
}

local half_slope_low_collision_boxes = {
    { -0.5, -0.5,  0.0, 0.5, 0.0, 0.5 },
    { -0.5,  0.0, 0.25, 0.5, 0.5, 0.5 },
}

local half_slope_high_collision_boxes = {
    { -0.5, -0.5,  -0.5, 0.5, 0.0, 0.5 },
    { -0.5,  0.0, -0.25, 0.5, 0.5, 0.5 },
}

local low_ridge_collision_boxes = {
    { -0.5,  -0.5, 0.25, 0.5, 0.5, 0.5 },
}

local high_ridge_collision_boxes = {
    { -0.5,  -0.5, -0.25, 0.5, 0.5, 0.5 },
}

local acroterion_collision_boxes = {
        { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
}
-- node definitions

-- default collision box
local classical_temples_nodes_simple = {
    "architrave",
    "architrave_corner",
    "entablature",
    "entablature_corner",
    "entablature_dentils",
    "entablature_dentils_corner",
    "column_base",
    "column_middle",
    "column_capital_0",
    "column_capital_1",
    "column_capital_2",
    "front_top",
}

-- have collision boxes
local classical_temples_nodes_collision = {
    { "front_middle", pediment_collision_boxes },
    { "front_left", pediment_collision_boxes },
    { "front_right", pediment_collision_boxes },
}

-- have collision boxes, topped by roof tiles
local classical_temples_nodes_slopes = {
}

-- have a collision boxes, composed of more than a single element, each with specific combination texture
local classical_temples_nodes_compounds = {
    { "slope_low", half_slope_low_collision_boxes, { "roof_tiles" } },
    { "slope_high", half_slope_high_collision_boxes, { "roof_tiles" } },
    { "slope_high_left", half_slope_high_collision_boxes, { "roof_tiles", nil } },
    { "slope_high_right", half_slope_high_collision_boxes, { "roof_tiles", nil }, "inventory_slope_high_right.png" },
    { "ridge_low", low_ridge_collision_boxes, { "roof_tiles_rotated", "roof_tiles_rotated" } },
    { "ridge_high", high_ridge_collision_boxes, { "roof_tiles_rotated", "roof_tiles_rotated" } },
    { "ridge_high_front", high_ridge_collision_boxes, { "roof_tiles_rotated", "roof_tiles_rotated" } },
    { "acroterion", acroterion_collision_boxes, { "roof_tiles", nil, nil, nil } },
}


-- internal lib

-- https://stackoverflow.com/questions/1426954/split-string-in-lua --
function classical_temples.split_str(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local list_of_separated_items = {}
    for item in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(list_of_separated_items, item)
    end
    return list_of_separated_items
end

-- separate lib name & material name
function classical_temples.split_mod_material(material_full_name)
    return unpack(classical_temples.split_str(material_full_name, ":"))
end

--

function classical_temples.register_node(node_data, material)
    local node_base_name = node_data[1]
    local collision_boxes 
    local material_mod, material_base_name = classical_temples.split_mod_material(material)
    local node_name = material_base_name.."_"..node_base_name

    local parameters = {
        description = node_name:gsub("_"," "),
        paramtype = "light",
        paramtype2 = "facedir",
        drawtype = "mesh",
        mesh = node_base_name..".obj",
        groups = { cracky = 1 },
    }

    if(node_data[2] ~= nil) then
        parameters["collision_box"] = {
            type = "fixed",
            fixed = node_data[2],
        }
    end

    local base_material = material_mod.."_"..material_base_name..".png"
    local tiles = {}
    if(node_data[3] == nil) then
        tiles = { base_material }
    else
        tiles = {}
        for tile_i, tile_type in ipairs(node_data[3]) do
            if(tile_type == nil) then
                tiles[tile_i] = base_material
            else
                tiles[tile_i] = base_material.."^"..tile_type..".png"
            end
        end
    end
    parameters["tiles"] = tiles

    if(node_data[4] ~= nil) then
        parameters["inventory_image"] = node_data[4]
    end
    
    
    minetest.register_node("classical_temples:"..node_name, parameters)
    minetest.register_alias(node_name, "classical_temples:"..node_name)
end

function classical_temples.register_node_for_all_materials(node_data)
    for material_i, material in ipairs(classical_temples_materials) do
        classical_temples.register_node(node_data, material)
    end
end

-- registration loops

for node_i, node_name in ipairs(classical_temples_nodes_simple) do
    classical_temples.register_node_for_all_materials({ node_name })
end

for node_i, node_data in ipairs(classical_temples_nodes_collision) do
    classical_temples.register_node_for_all_materials(node_data)
end

for node_i, node_data in ipairs(classical_temples_nodes_slopes) do
    node_data[3] = { "roof_tiles_top" }
    classical_temples.register_node_for_all_materials(node_data)
end

for node_i, node_data in ipairs(classical_temples_nodes_compounds) do
    classical_temples.register_node_for_all_materials(node_data)
end













