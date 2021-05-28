module CapybaraHelper
  module_function

  def browser_logs
    page.driver.browser.manage.logs.get("browser").map(&:to_s)
  end

  def grant_browser_clipboard_permissions
    page.driver.browser.execute_cdp(
      "Browser.grantPermissions",
      origin: page.server_url,
      permissions: %w[clipboardReadWrite clipboardSanitizedWrite]
    )
  end

  def read_clipboard_text
    page.evaluate_async_script("navigator.clipboard.readText().then(arguments[0])")
  end
end
