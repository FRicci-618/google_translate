class TranslatePage

  def initialize(browser)
    @browser = browser
  end

  def more_source_languages_button
    @browser.button(aria_label: 'More source languages')
  end

  def more_target_languages_button
    @browser.button(aria_label: 'More target languages')
  end

  def source_language_div(language)
    @browser.divs(class: 'vSUSRc')[0].div(class: 'Llmcnf', text: language)
  end

  def target_language_div(language)
    @browser.divs(class: 'vSUSRc')[2].div(class: 'Llmcnf', text: language)
  end

  def selected_source_language(language)
    @browser.divs(class: 'akczyd')[0].button(aria_selected: true, text: language)
  end

  def selected_target_language(language)
    @browser.divs(class: 'akczyd')[1].button(aria_selected: true, text: language)
  end

  def source_text_box
    @browser.textarea(aria_label: 'Source text')
  end

  def target_text_box
    @browser.span(class: 'Q4iAWc')
  end

  def empty_target_text_box
    @browser.div(text: 'Translation')
  end

  def swap_languages_button
    @browser.button(aria_label: 'Swap languages (Cmd+Shift+S)')
  end

  def on_screen_keyboard_button
    @browser.a(class: 'ita-kd-inputtool-icon')
  end

  def keyboard_key(input)
    @browser.span(class: 'vk-cap', text: input)
  end

  def keyboard_caps
    @browser.span(class: 'vk-sf-c16')
  end

  def keyboard_close
    @browser.div(class: 'vk-sf-cl')
  end

  def loading_ellipsis
    @browser.span(text: '...')
  end

end