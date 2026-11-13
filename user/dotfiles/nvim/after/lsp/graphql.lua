---@type vim.lsp.Config
return {
  -- graphql-lsp ignores the LSP root and looks for the graphql config in its working directory
  -- (or the one given via -c), so start it in the root_dir that was detected.
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { 'graphql-lsp', 'server', '-m', 'stream', '-c', config.root_dir },
      dispatchers,
      { cwd = config.root_dir, env = { NODE_OPTIONS = '--no-deprecation' } }
    )
  end,
}
