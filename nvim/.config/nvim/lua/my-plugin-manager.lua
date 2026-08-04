-- Plugin management using vim.pack (Neovim builtin)
-- Lockfile: ~/.config/nvim/nvim-pack-lock.json
-- Plugins installed to: ~/.local/share/nvim/site/pack/core/opt/

-- Tracks plugins loaded via MyAddPlugin() for PackClean
local active_plugins = {}

---Add a plugin (GitHub URL prefix is default)
---@param repo string GitHub repo (user/repo) or full URL
---@param opts? table Options passed to vim.pack.add
function MyAddPlugin(repo, opts)
  local url = repo:match("^https?://") and repo or ("https://github.com/" .. repo)
  local ok, err = pcall(vim.pack.add, {url}, opts)
  if not ok then
    vim.notify("Failed to add plugin: " .. repo .. "\n" .. tostring(err), vim.log.levels.ERROR)
    return
  end
  -- Extract plugin name from repo (e.g. "user/plugin.nvim" -> "plugin.nvim")
  local name = url:match("([^/]+)$")
  if name then
    active_plugins[name] = true
  end
end

-- `:PackList` = list installed plugins
vim.api.nvim_create_user_command("PackList", function()
  local lines = vim.split(vim.inspect(vim.pack.get()), "\n")

  vim.cmd("tabnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  -- Make it a scratch buffer
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
end, {})


-- `:PackClean` = delete plugins installed on disk but no longer in config
vim.api.nvim_create_user_command("PackClean", function()
  local pack_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt"
  local installed = vim.fn.readdir(pack_dir)

  local stale = {}
  for _, name in ipairs(installed) do
    if not active_plugins[name] then
      table.insert(stale, name)
    end
  end

  if #stale == 0 then
    vim.notify("No stale plugins found", vim.log.levels.INFO)
    return
  end

  local msg = "Delete " .. #stale .. " stale plugins?\n"
  for _, name in ipairs(stale) do
    msg = msg .. "  " .. name .. "\n"
  end

  if vim.fn.confirm(msg, "&Yes\n&No", 2) ~= 1 then
    return
  end

  for _, name in ipairs(stale) do
    vim.fn.delete(pack_dir .. "/" .. name, "rf")
  end

  -- Clean lockfile
  local lockfile = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
  local lock_raw = vim.fn.readfile(lockfile)
  if #lock_raw > 0 then
    local lock = vim.json.decode(table.concat(lock_raw, "\n"))
    if lock.plugins then
      for _, name in ipairs(stale) do
        lock.plugins[name] = nil
      end
    end
    local json = vim.fn.json_encode(lock)
    -- Pretty-print with python if available, otherwise write compact
    local result = vim.system({ "python3", "-m", "json.tool", "--sort-keys" }, { stdin = json }):wait()
    if result.code == 0 then
      vim.fn.writefile(vim.split(result.stdout, "\n"), lockfile)
    else
      vim.fn.writefile({ json }, lockfile)
    end
  end

  vim.notify("Deleted " .. #stale .. " stale plugins", vim.log.levels.INFO)
end, {})

-- NOTE: post-install plugins hooks must be listed before PackChanged autocmd registered
local hooks = {
  ["telescope-fzf-native.nvim"] = function(path)
    vim.notify("Building telescope-fzf-native.nvim in " .. path)
    local result = vim.system({ "make" }, { cwd = path }):wait()
    if result.code ~= 0 then
      vim.notify(
        "Failed to build telescope-fzf-native.nvim:\n" .. (result.stderr or "Unknown error"),
        vim.log.levels.ERROR
      )
    end
  end,

  ["nvim-treesitter"] = function(_)
    pcall(vim.cmd, "packadd nvim-treesitter")
    vim.cmd("TSUpdate")
  end,

  ["markdown-preview.nvim"] = function(path)
    vim.system(
      { "npx", "--yes", "yarn", "install" },
      { cwd = path .. "/app" }
    )
  end,
}

local group = vim.api.nvim_create_augroup("MyPackHooks", { clear = true })

-- Build hooks executed on plugins install/update
vim.api.nvim_create_autocmd("PackChanged", {
  group = group,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind == "install" or kind == "update" then
      local hook = hooks[name]
      if hook then
        local path = ev.data.path
        vim.schedule(function()
          local ok, err = pcall(hook, path)
          if not ok then
            vim.notify(
              "Build hook failed for " .. name .. ":\n" .. tostring(err),
              vim.log.levels.ERROR
            )
          else
            vim.notify("Build hook completed for " .. name, vim.log.levels.INFO)
          end
        end)
      end
    end
  end,
})