#!/usr/bin/env ruby

require 'json'
require 'open3'

require 'logger'

LOGGER = Logger.new('/tmp/heroku-verify-down.log')
LOGGER.info('Script démarré')
LOGGER.info("VERSION: #{RUBY_VERSION}")
LOGGER.info("PATH: #{ENV['PATH']}")
LOGGER.info("RBENV_ROOT: #{ENV['RBENV_ROOT']}")

HEROKU_APPS = ['webapp-imparato-io-staging']

def check_heroku_status(app_name)
  stdout, stderr, status = Open3.capture3("heroku ps -a #{app_name}")

  LOGGER.info("heroku stdout: #{stdout}")
  LOGGER.info("heroku stderr: #{stderr}")
  if status.success?
    if stdout.include?('No dynos on')
      :no_dynos
    elsif stdout.include?('up')
      :up
    else
      :unknown
    end
  else
    :error
  end
end

def send_urgent_notification(title, message)
  LOGGER.info('send notification')
  script = <<-APPLESCRIPT
    tell application "System Events"
      set frontApp to name of first application process whose frontmost is true
      display dialog "#{message}" with title "#{title}" buttons {"OK"} default button "OK" with icon caution giving up after 86400
      activate application frontApp
    end tell
  APPLESCRIPT

  system 'osascript', '-e', script
end

HEROKU_APPS.each do |app|
  status = check_heroku_status(app)
  LOGGER.info("check status: #{status}")

  case status
  when :up
    send_urgent_notification('Alerte Heroku',
                             "L'application Heroku #{app} est toujours en cours d'exécution. Pensez à l'éteindre si nécessaire.")
  when :error, :unknown
    send_urgent_notification('Erreur Heroku',
                             "Impossible de vérifier le statut de l'application #{app}. Veuillez vérifier vos credentials Heroku.")
  when :no_dynos
    # Cas nominal, ne rien faire
  end
end
