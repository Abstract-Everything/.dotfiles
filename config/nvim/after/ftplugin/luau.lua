local buffer_path = vim.api.nvim_buf_get_name(0)

local rojo_project_file = vim.fs.find("default.project.json", {
  upward = true,
  type = "file",
  path = vim.fs.dirname(buffer_path),
})[1]

local project_root = vim.fs.dirname(rojo_project_file)

if not rojo_project_file or not project_root then
  return
end

require("luau-lsp.config").get().sourcemap.rojo_project_file = rojo_project_file

local buffer = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = vim.api.nvim_create_augroup("luau_workspace", { clear = true }),
  buffer = buffer,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "luau-lsp" then
      return
    end

    for _, directory in ipairs(vim.lsp.buf.list_workspace_folders()) do
      if directory == project_root then
        return
      end
    end

    vim.lsp.buf.add_workspace_folder(project_root)

    -- HACK: When calling the add workspace function luau-lsp refuses to receive
    -- further commands stating that the file is not attached, by reloading the
    -- file after a bit it seems to work correctly with the added workspace
    vim.defer_fn(function()
      vim.cmd "e!"
    end, 1000)
  end,
})
