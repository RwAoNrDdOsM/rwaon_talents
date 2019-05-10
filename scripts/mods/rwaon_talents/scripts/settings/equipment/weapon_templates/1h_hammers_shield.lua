local mod = get_mod("rwaon_talents")

-- Axe and Shield
------------------------------------------------------------------------------

for _, one_hand_axe_shield_template_1 in ipairs{
    "one_handed_hammer_shield_template_1",
    "one_handed_hammer_shield_template_2",
} do
    local weapon_template = Weapons[one_hand_axe_shield_template_1]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    weapon_template.dodge_count = 2 --1
    --add_weapon_value(action_two, "default", "max_radius", 4.2) --3.5
    change_chain_actions(action_one, "light_attack_bopp", 5, {
        sub_action = "heavy_attack_left",
        start_time = 0.55,
        action = "action_one",
        release_required = "action_two_hold",
        input = "action_one_hold"
    })
    --[[change_chain_actions(action_one, "light_attack_bopp", 6, {
        sub_action = "heavy_attack_left",
        start_time = 0.55,
        action = "action_one",
        auto_chain = true
    })]]
end