return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "lua",
          "bash",
          "python",
          "json",
          "javascript",
          "typescript",
        },

        highlight = {
          enable = true,
        },

        indent = {
          enable = true,
        },

        auto_install = true,
      })
    end,
  },
}
