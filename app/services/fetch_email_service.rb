class FetchEmailService < ApplicationService
  def browser
    @browser ||= Watir::Browser.new
  end

  def execute
    Conference.find_each do |conference|
      begin
        conference.fetch_emails(browser) if conference.emails.blank?
      rescue => e
      end
    end
    browser.close
  end
end
