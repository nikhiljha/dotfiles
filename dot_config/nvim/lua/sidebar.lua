local sidebar = require("sidebar-nvim")
sidebar.setup({
    open = false,
    sections = { "datetime", "files", "git" },
    files = {
        icon = "",
        show_hidden = false,
        ignored_paths = {"%.git$"}
    }
})

