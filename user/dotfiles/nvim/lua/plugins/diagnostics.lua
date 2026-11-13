-- ###########################
-- ##      DIAGNOSTICS      ##
-- ###########################
do
  -- TODO: check this config
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = false, -- Text shows up at the end of the line
    virtual_lines = true, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  local function href(d)
    local lsp = d.user_data and d.user_data.lsp
    return lsp and lsp.codeDescription and lsp.codeDescription.href
  end

  -- Float with the details of the diagnostics on the current line: source, code and link
  vim.keymap.set('n', '<leader>dd', function()
    vim.diagnostic.open_float {
      scope = 'line',
      header = '',
      suffix = '',
      format = function(d)
        local info = {}
        if d.source then table.insert(info, d.source) end
        if d.code then table.insert(info, tostring(d.code)) end
        local text = d.message
        if #info > 0 then text = text .. '\n[' .. table.concat(info, ': ') .. ']' end
        if href(d) then text = text .. '\n' .. href(d) end
        return text
      end,
    }
  end, { desc = '[D]iagnostic [D]etails' })

  -- Open the documentation link of the diagnostic(s) on the current line
  vim.keymap.set('n', '<leader>do', function()
    local urls = {}
    for _, d in ipairs(vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })) do
      if href(d) then table.insert(urls, href(d)) end
    end
    urls = vim.fn.uniq(urls)
    if #urls == 0 then
      vim.notify('No diagnostic link on this line', vim.log.levels.INFO)
    elseif #urls == 1 then
      vim.ui.open(urls[1])
    else
      vim.ui.select(urls, { prompt = 'Open link' }, function(url)
        if url then vim.ui.open(url) end
      end)
    end
  end, { desc = '[D]iagnostic [O]pen link' })

  -- Dump the raw diagnostic table(s) on the current line
  vim.keymap.set('n', '<leader>dp', function()
    vim.print(vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 }))
  end, { desc = '[D]iagnostic [P]rint raw' })
end
