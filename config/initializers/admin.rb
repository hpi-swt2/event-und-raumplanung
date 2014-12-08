# Be sure to restart your server when you modify this file.

Rails.application.config.admin =  YAML.load_file("#{Rails.root}/config/config.yml")