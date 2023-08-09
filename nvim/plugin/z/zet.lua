local function file_exists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end

local function get_buffer_by_name(name)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name == name then
            return buf
        end
    end
    return nil
end

local M = {}

function M.zet_rename()
    local dir = vim.fn.expand("%:p:h") .. "/"
    local oldpath = vim.fn.expand("%:p")
    local old = vim.fn.expand("%:p:t:r")
    local new = vim.fn.input("New name: ", old)
    local newpath = dir .. new .. ".md"
    vim.cmd("redraw")
    if file_exists(newpath) then
        vim.print("File already exists")
        return
    end
    local ok, err = os.rename(oldpath, newpath)
    if not ok then
        vim.print("Error: " .. err)
        return
    end
    vim.cmd("keepalt saveas! " .. newpath)
    vim.cmd("bdelete! " .. get_buffer_by_name(oldpath))
    os.execute("cd $HOME/doc/zet/ && sed -i 's/^- @" .. old .. "$/- @" .. new .. "/g' *")
end

return M
