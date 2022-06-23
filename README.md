# Google Translate Automated Tests

This project contains a series of tests to automate the Google Translate application.

The following tests can be found in `google_translate.feature`:
1. Translate a phrase and verify the result
2. Translate a phrase, then swap languages and verify the result
3. Translate a phrase, swap languages, then enter a phrase on the on-screen keyboard and verify the result

The tests use the values found in the config file `test_config.yaml`.

To run the tests, assuming you have `ruby-2.6.5`, `Google Chrome v103.x`, and `ChromeDriver 103.x`,  installed, run the following command:

`cucumber features/ --color -r features -f pretty --publish-quiet`