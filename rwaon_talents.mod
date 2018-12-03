return {
    run = function()
        fassert(rawget(_G, "new_mod"), "Vermintide 2 Reworks must be lower than Vermintide Mod Framework in your launcher's load order.")

        new_mod("rwaon_talents", {
            mod_script       = "scripts/mods/rwaon_talents/rwaon_talents",
            mod_data         = "scripts/mods/rwaon_talents/rwaon_talents_data",
            mod_localization = "scripts/mods/rwaon_talents/rwaon_talents_localization"
        })
        return {}
    end,
    packages = {
        "resource_packages/rwaon_talents/rwaon_talents"
    }
}
