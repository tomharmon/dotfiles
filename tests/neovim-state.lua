-- Run from the repository root: nvim --headless -u NONE -i NONE -l tests/neovim-state.lua
local root = vim.fn.getcwd()
local config = root .. "/config/nvim"
local temporary = vim.fn.tempname()
local state = temporary .. "/state"
local data = temporary .. "/data"
local original_stdpath = vim.fn.stdpath
local original_lazy = package.loaded["lazy"]
local original_json = vim.g.lazyvim_json
local original_rtp = vim.o.rtp
local options

local function read_json(path)
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
end

local ok, err = xpcall(function()
    for _, path in ipairs(vim.fn.globpath(config, "**/*.lua", false, true)) do
        assert(loadfile(path))
    end
    vim.fn.mkdir(data .. "/lazy/lazy.nvim", "p")
    vim.fn.stdpath = function(kind)
        return ({ config = config, state = state, data = data })[kind] or original_stdpath(kind)
    end
    package.loaded["lazy"] = {
        setup = function(value)
            options = value
        end,
    }

    dofile(config .. "/lua/config/lazy.lua")
    assert(options.lockfile == state .. "/lazy-lock.json")
    assert(vim.g.lazyvim_json == state .. "/lazyvim.json")
    for _, name in ipairs({ "lazy-lock.json", "lazyvim.json" }) do
        assert(vim.deep_equal(read_json(config .. "/" .. name), read_json(state .. "/" .. name)))
        assert(vim.fn.filewritable(state .. "/" .. name) == 1)
        vim.fn.writefile({ '{"preserved":true}' }, state .. "/" .. name)
    end

    dofile(config .. "/lua/config/lazy.lua")
    for _, name in ipairs({ "lazy-lock.json", "lazyvim.json" }) do
        assert(read_json(state .. "/" .. name).preserved)
        assert(not read_json(config .. "/" .. name).preserved)
    end
end, debug.traceback)

vim.fn.stdpath = original_stdpath
package.loaded["lazy"] = original_lazy
vim.g.lazyvim_json = original_json
vim.o.rtp = original_rtp
vim.fn.delete(temporary, "rf")
assert(ok, err)
print("Neovim Lua syntax, JSON snapshots, writable state seeding, and preservation checks passed")
