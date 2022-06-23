require_relative '../../env'

Given(/^I am on the Google Translate page$/) do
  @test_config = YAML.load_file(File.join(File.dirname(__FILE__), "../../test_config.yaml"))
  @browser = Watir::Browser.new :chrome
  @browser.goto @test_config['page_address']
  @browser.window.maximize
  @translate_page = TranslatePage.new(@browser)
  @translate_page.source_text_box.wait_until &:present?
end

When(/^I set the (source|target) language$/) do |source_target|
  if source_target == 'source'
    @translate_page.more_source_languages_button.fire_event :onclick
    @translate_page.source_language_div(@test_config['source_language']).fire_event :onclick
    @translate_page.translate_text_button.fire_event :onclick
    @translate_page.selected_source_language(@test_config['source_language']).wait_until &:present?
  else
    @translate_page.more_target_languages_button.fire_event :onclick
    @translate_page.target_language_div(@test_config['target_language']).fire_event :onclick
    @translate_page.translate_text_button.fire_event :onclick
    @translate_page.selected_target_language(@test_config['target_language']).wait_until &:present?
  end
end

And(/^I enter the source language phrase$/) do
  @translate_page.source_text_box.send_keys(@test_config['source_text'])
  @browser.wait_until { !@translate_page.loading_ellipsis.present? }
end

Then(/^the (source language|target language|keyboard) phrase should be correctly translated$/) do |language|
  if language == 'source language'
    @expected_phrase = @test_config['source_text']
  elsif language == 'target language'
    @expected_phrase = @test_config['target_text']
  else
    @expected_phrase = @test_config['keyboard_phrase']
  end
  actual_phrase = @translate_page.target_text_box.text
  raise "The translated phrase did not match the expected phrase\nExpected: #{@expected_phrase}\nActual: #{actual_phrase}" unless @expected_phrase == actual_phrase
end

When(/^I click the Swap Languages button$/) do
  @translate_page.swap_languages_button.fire_event :onclick
  @browser.wait_until { @translate_page.source_text_box.value == @expected_phrase }
  @browser.wait_until { !@translate_page.loading_ellipsis.present? }
end

When(/^I clear the source language field$/) do
  @translate_page.source_text_box.send_keys [:command, 'a'], :backspace
  @browser.wait_until { @translate_page.empty_target_text_box.present? }
end

And(/^I enter a phrase using the on\-screen keyboard$/) do
  keyboard_phrase = @test_config['keyboard_phrase']
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

After do
  @browser.close
end