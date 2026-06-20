local M = {}

local function abort(message)
	vim.api.nvim_err_writeln(tostring(message))
	vim.cmd("cquit")
end

local function add_mason_runtime()
	local path = vim.fn.stdpath("data") .. "/lazy/mason.nvim"

	if vim.fn.isdirectory(path) == 1 then
		vim.opt.rtp:prepend(path)
	end
end

local function setup_mason()
	add_mason_runtime()

	local ok, mason = pcall(require, "mason")
	if not ok then
		abort(mason)
		return false
	end

	if not mason.has_setup then
		mason.setup()
	end

	return true
end

local function decode(path)
	if vim.fn.filereadable(path) == 0 then
		return nil
	end

	local ok, lines = pcall(vim.fn.readfile, path, "b")
	if not ok or #lines == 0 then
		return nil
	end

	local decoded_ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decoded_ok then
		return nil
	end

	return data
end

local function registry_healthy(root)
	local info = decode(root .. "/info.json")
	if type(info) ~= "table" or type(info.version) ~= "string" or type(info.download_timestamp) ~= "number" then
		return false
	end

	local registry = decode(root .. "/registry.json")
	if type(registry) ~= "table" or vim.tbl_isempty(registry) then
		return false
	end

	return true
end

local function tools()
	local packages = { "shfmt", "stylua" }

	if vim.fn.executable("gem") == 1 then
		vim.list_extend(packages, { "erb-formatter", "erb-lint" })
	end

	if vim.fn.executable("npm") == 1 then
		vim.list_extend(packages, { "markdown-toc", "markdownlint", "markdownlint-cli2", "prettier" })
	end

	table.sort(packages)
	return packages
end

function M.clean_registry()
	local root = vim.fn.stdpath("data") .. "/mason/registries/github/mason-org/mason-registry"

	if vim.fn.isdirectory(root) == 0 or registry_healthy(root) then
		return
	end

	vim.fn.delete(root, "rf")
end

function M.install_tools()
	local registry = M.refresh_registry()
	if not registry then
		return
	end

	local ok, async = pcall(require, "mason-core.async")
	if not ok then
		abort(async)
		return
	end

	local installed, err = pcall(async.run_blocking, function()
		local installers = {}

		for _, name in ipairs(tools()) do
			local ok_package, target = pcall(registry.get_package, name)
			if not ok_package then
				error(target)
			end

			if not target:is_installed() and not target:is_installing() then
				local package_name = name
				local package_target = target

				table.insert(installers, function()
					return async.wait(function(resolve)
						package_target:install({}, function(success, result)
							resolve({
								error = success and nil or result,
								name = package_name,
								success = success,
							})
						end)
					end)
				end)
			end
		end

		local results = { async.wait_all(installers) }
		async.scheduler()

		for _, result in ipairs(results) do
			if not result.success then
				error(("Failed to install %s: %s"):format(result.name, result.error))
			end
		end
	end)

	if not installed then
		abort(err)
	end
end

function M.refresh_registry()
	M.clean_registry()
	if not setup_mason() then
		return
	end

	local ok, registry = pcall(require, "mason-registry")
	if not ok then
		abort(registry)
		return
	end

	local success, errors = registry.refresh()
	if success then
		return registry
	end

	abort(vim.inspect(errors))
end

return M
