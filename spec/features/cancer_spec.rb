require "rails_helper"

feature "cancer"do

  scenario "go to wiki site and check content" do
    visit cancers_path
    click_on "New Cancer"
    fill_in "Name", with: "Lung carcinoma"
    fill_in "Genes", with: "lkb1"
    click_on "Create Cancer"
    click_on "Lung cancer"
    save_and_open_page
  end

end
