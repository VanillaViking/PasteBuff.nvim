local pastebuff = {
  test = "hello world"
}

---Setup connection with a PasteBuff server
---@param address string
---@param port number
function pastebuff.setup(address, port)
end

local uv = vim.uv
local client = uv.new_tcp()
client:connect("127.0.0.1", 7884, function (err)
  assert(not err, err)
end)


---Get the number of buffers in the connected PasteBuff server
---@return number size
function pastebuff.size()
  local msg = "\"Size\""
  local buf = string.char(0) .. string.char(0) .. string.char(0) .. string.char(string.len(msg)) .. msg

  client:write(buf)

  client:read_start(vim.schedule_wrap(function (err, chunk)
    assert(not err, err)
    if chunk then
      vim.notify(chunk)
    end
  end))
end

---Get the contents of the specified buffer name
---@param buf_name string
function pastebuff.get(buf_name)
  vim.notify(string.format("get: %s", buf_name))
end

---Set the contents of the specified buffer with value
---@param buf_name string
---@param value string
function pastebuff.set(buf_name, value)
  vim.notify("set called")
end

function convert_to_bin(num)
  -- cant be negative
  -- cant be higher than u32::max
  -- is int

end

function isInteger(num)
  return type(num) == "number" and math.floor(num) == num
end

vim.api.nvim_create_user_command(
  "PasteBuffGet",
  "lua require('pastebuff').get(<f-args>)",
  {
    nargs = "*",
    complete = "shellcmd",
  }
)

vim.api.nvim_create_user_command(
  "PasteBuffSet",
  "lua require('pastebuff').set(<f-args>)",
  {
    nargs = "*",
    complete = "shellcmd",
  }
)

return pastebuff
