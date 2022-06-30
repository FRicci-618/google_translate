require_relative '../../env'

Given(/^I am on the Google Translate page$/) do
  BROWSER = Watir::Browser.new :chrome
  @browser = BROWSER
  @browser.goto TEST_CONFIG['page_address']
  @browser.window.maximize
  @translate_page = TranslatePage.new(@browser)
  @translate_page.source_text_box.wait_until &:present?
end

When(/^I set the (source|target) language$/) do |source_target|
  if source_target == 'source'
    @translate_page.more_source_languages_button.fire_event :onclick
    @translate_page.source_language_div(TEST_CONFIG['source_language']).fire_event :onclick
    @translate_page.translate_text_button.fire_event :onclick
    @translate_page.selected_source_language(TEST_CONFIG['source_language']).wait_until &:present?
  else
    @translate_page.more_target_languages_button.fire_event :onclick
    @translate_page.target_language_div(TEST_CONFIG['target_language']).fire_event :onclick
    @translate_page.translate_text_button.fire_event :onclick
    @translate_page.selected_target_language(TEST_CONFIG['target_language']).wait_until &:present?
  end
end

And(/^I enter the source language phrase$/) do
  @translate_page.source_text_box.send_keys(TEST_CONFIG['source_text'])
  @browser.wait_until { !@translate_page.loading_ellipsis.present? }
end

Then(/^the (source language|target language|keyboard) phrase should be correctly translated$/) do |language|
  if language == 'source language'
    @expected_phrase = TEST_CONFIG['source_text']
  elsif language == 'target language'
    @expected_phrase = TEST_CONFIG['target_text']
  else
    @expected_phrase = TEST_CONFIG['keyboard_phrase']
  end
  actual_phrase = @translate_page.target_text_box.text
  raise "The translated phrase did not match the expected phrase\nExpected: #{@expected_phrase}\nActual: #{actual_phrase}" unless @expected_phrase == actual_phrase
end

When(/^I click the Swap Languages button$/) do
  @translate_page.swap_languages_button.fire_event :onclick
  @browser.wait_until { @translate_page.source_text_box.value == TEST_CONFIG['target_text'] }
  @browser.wait_until { !@translate_page.loading_ellipsis.present? }
end

When(/^I clear the source language field$/) do
  @translate_page.source_text_box.send_keys [:command, 'a'], :backspace
  @browser.wait_until { @translate_page.empty_target_text_box.present? }
end

And(/^I enter a phrase using the on\-screen keyboard$/) do
  keyboard_phrase = TEST_CONFIG['keyboard_phrase']
  @translate_page.on_screen_keyboard_button.fire_event :onclick
  keyboard_phrase.chars.each do |c|
    @translate_page.keyboard_caps.fire_event :onclick if (c == c.upcase || !c.match?(/[[:alpha:]]/))
    @translate_page.keyboard_key(c).fire_event :onclick
    @browser.wait_until { @translate_page.source_text_box.value.chars.last == c }
  end
  @translate_page.keyboard_close.fire_event :onclick
  @browser.wait_until { !@translate_page.loading_ellipsis.present? }
  @browser.wait_until { @translate_page.source_text_box.value == keyboard_phrase }
end

Given(/^I have entered a phrase on the Google Translate page$/) do
  @browser = BROWSER
  @translate_page = TranslatePage.new(@browser)
  @browser.wait_until { @translate_page.source_text_box.value.length > 0 }
end

BeforeAll do
  TEST_CONFIG= YAML.load_file(File.join(File.dirname(__FILE__), "../../test_config.yaml"))
end

AfterAll do
  BROWSER.close
end