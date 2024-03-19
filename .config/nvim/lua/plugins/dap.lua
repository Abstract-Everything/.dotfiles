return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dr",
        function()
          require("dap").run_last()
        end,
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<leader>dh",
        function()
          require("dap").run_to_cursor()
        end,
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
      },
      {
        "<leader>ds",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<leader>df",
        function()
          require("dap").step_out()
        end,
      },
      {
        "<leader>dt",
        function()
          require("dap").repl.open()
        end,
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").open {}
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },
    },
    -- Without this line, config is not called by lazy automatically
    opts = {},
  },
}
