local mod = get_mod("rwaon_talents")

-- Axe and Shield
------------------------------------------------------------------------------

for _, one_hand_axe_shield_template_1 in ipairs{
    "one_hand_axe_shield_template_1",
} do
    local weapon_template = Weapons[one_hand_axe_shield_template_1]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    weapon_template.dodge_count = 2 --1
end
