require "capybara/rails"
require "selenium-webdriver"
require "webdrivers"
require_relative "helpers/capybara_helper"

Webdrivers.install_dir = File.expand_path("~/.webdrivers/#{ENV['TEST_ENV_NUMBER']}")
Capybara.default_max_wait_time = 10
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox window-size=1920,1080]
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options,
                                      desired_capabilities: {
                                        "goog:loggingPrefs" => { browser: "ALL" }
                                      })
end

Capybara.javascript_driver = :chrome
Capybara.server = :puma, { Silent: true }
Capybara.server_port = 9887 + ENV["TEST_ENV_NUMBER"].to_i

RSpec.configure do |config|
  config.include CapybaraHelper, type: :system

  config.after(type: :system) do |example|
    if example.exception
      filename = example.location.parameterize

      save_page("#{filename}.html")
      begin
        browser_logs.each { |log| Rails.logger.debug("[Browser] - #{log}") }
      rescue Capybara::NotSupportedByDriverError => error
        Rails.logger.error(error)
      end
    end
  end
end
