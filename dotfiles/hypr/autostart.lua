-- Track Linux v0.1 — Hyprland autostart
--
-- Only start infrastructure that must live for the graphical session.
-- Notifications (mako), portals, PipeWire and WirePlumber use their normal
-- D-Bus/systemd activation paths and are not manually spawned here.

hl.on("hyprland.start", function()
    -- GUI privilege/password prompts.
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
end)
