def setup_frontend_framework_layout(devise_option)
  if devise_option
    inject_into_file 'app/views/layouts/application.html.erb', after: '<body>' do
      <<-HTML

        <%= render 'shared/navbar' %>
        <%= render 'shared/flashes' %>
      HTML
    end
  else
    inject_into_file 'app/views/layouts/application.html.erb', after: '<body>' do
      <<-HTML

        <%= render 'shared/flashes' %>
      HTML
    end
  end

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
    class ApplicationController < ActionController::Base
      add_flash_types :info, :success
    end
  RUBY
end

def install_bootstrap_last_version(devise_option, use_last_version)
  # Flashes & Navbar
  ########################################
  run 'mkdir app/views/shared'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/bootstrap/layout/_navbar.html.erb > app/views/shared/_navbar.html.erb' if devise_option
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/bootstrap/layout/_flashes.html.erb > app/views/shared/_flashes.html.erb'

  # Webpacker / Yarn
  ########################################
  run 'yarn add yarn add @popperjs/core bootstrap'

  append_file 'app/javascript/packs/application.js', <<~JS

    // ----------------------------------------------------
    // Note: ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------

    // External imports
    import "bootstrap";

    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';

    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // initSelect2();
    });
  JS

  inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
    <<~JS
      const webpack = require('webpack');
      // Preventing Babel from transpiling NodeModules packages
      environment.loaders.delete('nodeModules');
      // Bootstrap 4 has a dependency over jQuery & Popper.js:
      environment.plugins.prepend('Provide',
        new webpack.ProvidePlugin({
          Popper: ['popper.js', 'default']
        })
      );
    JS
  end
end

def install_bootstrap_old_version(devise_option, use_last_version)
  # Flashes & Navbar
  ########################################
  run 'mkdir app/views/shared'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/bootstrap/layout-v4.6/_navbar.html.erb > app/views/shared/_navbar.html.erb' if devise_option
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/bootstrap/layout-v4.6/_flashes.html.erb > app/views/shared/_flashes.html.erb'

  # Webpacker / Yarn
  ########################################
  run 'yarn add popper.js jquery bootstrap@4.6'

  append_file 'app/javascript/packs/application.js', <<~JS

    // ----------------------------------------------------
    // Note: ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------

    // External imports
    import "bootstrap";

    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';

    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // initSelect2();
    });
  JS

  inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
    <<~JS
      const webpack = require('webpack');
      // Preventing Babel from transpiling NodeModules packages
      environment.loaders.delete('nodeModules');
      // Bootstrap 4 has a dependency over jQuery & Popper.js:
      environment.plugins.prepend('Provide',
        new webpack.ProvidePlugin({
          $: 'jquery',
          jQuery: 'jquery',
          Popper: ['popper.js', 'default']
        })
      );
    JS
  end
end

def setup_bootstrap_framework(devise_option, use_last_version)
  if use_last_version
    install_bootstrap_last_version(devise_option, use_last_version)
  else
    install_bootstrap_old_version(devise_option, use_last_version)
  end
end

def setup_tailwind_framework(devise_option)
  # Flashes & Navbar
  ########################################
  run 'mkdir app/views/shared'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/tailwind/layout/_navbar.html.erb > app/views/shared/_navbar.html.erb' if devise_option
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/tailwind/layout/_flashes.html.erb > app/views/shared/_flashes.html.erb'

  # Setup + Dependencies
  ########################################
  run 'yarn add tailwindcss@latest postcss@latest autoprefixer@latest'

  # Config
  ########################################
  remove_file 'postcss.config.js'

  file 'postcss.config.js', <<-JS
    module.exports = {
      plugins: [
        require('tailwindcss')('./app/javascript/stylesheets/tailwind.config.js'),
        require('postcss-import'),
        require('postcss-flexbugs-fixes'),
        require('postcss-preset-env')({
          autoprefixer: {
            flexbox: 'no-2009'
          },
          stage: 3
        })
      ]
    }
  JS

  run 'mkdir app/javascript/stylesheets'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/tailwind/config/tailwind.config.js > app/javascript/stylesheets/tailwind.config.js'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/tailwind/config/_fonts.scss > app/javascript/stylesheets/_fonts.scss'
  run 'touch app/javascript/stylesheets/application.scss'

  append_file 'app/javascript/stylesheets/application.scss', <<~SCSS
    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";

    @import "fonts";
  SCSS

  append_file 'app/javascript/packs/application.js', <<~JS

    // ----------------------------------------------------
    // Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------

    // Tailwind import
    import "../stylesheets/application"

    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';
    import initAlerts from '../components/initAlerts';

    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // initSelect2();
      initAlerts();
    });
  JS
end

def setup_vanilla_frontend(devise_option)
  # Flashes & Navbar
  ########################################
  run 'mkdir app/views/shared'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/vanilla-scss/layout/_navbar.html.erb > app/views/shared/_navbar.html.erb' if devise_option
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/vanilla-scss/layout/_flashes.html.erb > app/views/shared/_flashes.html.erb'

  append_file 'app/javascript/packs/application.js', <<~JS

    // ----------------------------------------------------
    // Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
    // WRITE YOUR OWN JS STARTING FROM HERE 👇
    // ----------------------------------------------------

    // Internal imports, e.g:
    // import { initSelect2 } from '../components/init_select2';
    import initAlerts from '../components/initAlerts';

    document.addEventListener('turbolinks:load', () => {
      // Call your functions here, e.g:
      // initSelect2();
      initAlerts();
    });
  JS
end

def setup_devise_authentication
  # Devise install + User
  ########################################
  generate('devise:install')
  generate('devise', 'User')

  # Migrate + Views
  ########################################
  rails_command 'db:migrate'
  run "spring stop" # Fix hangtime
  run 'rails generate devise:views' unless options['api']

  # App controller
  inject_into_file 'app/controllers/application_controller.rb', after: 'ActionController::Base' do
    <<-RUBY
      #{  "protect_from_forgery with: :exception\n" if Rails.version < "5.2"} \n  before_action :authenticate_user!
    RUBY
  end

  # Pages Controller
  ########################################
  unless options['api']
    run 'rm app/controllers/pages_controller.rb'
    file 'app/controllers/pages_controller.rb', <<~RUBY
      class PagesController < ApplicationController
        skip_before_action :authenticate_user!, only: [ :home, :kitchensink ]

        def home; end

        def kitchensink; end
      end
    RUBY
  end
end

def setup_pundit_authorization
  # Pundit install
  ########################################
  generate('pundit:install')

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
    class ApplicationController < ActionController::Base
    #{  "protect_from_forgery with: :exception\n" if Rails.version < "5.2"}  before_action :authenticate_user!
      add_flash_types :info, :success

      include Pundit

      # Pundit: white-list approach.
      after_action :verify_authorized, except: :index, unless: :skip_pundit?
      after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

      # Uncomment when you *really understand* Pundit!
      # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      # def user_not_authorized
      #   flash[:alert] = "You are not authorized to perform this action."
      #   redirect_to(root_path)
      # end

      private

      def skip_pundit?
        devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
      end
    end
  RUBY
end

def setup_stimulus_framework
  # Stimulus Setup
  ########################################
  run 'rails webpacker:install:stimulus'
  run 'yarn add @hotwired/stimulus-webpack-helpers'
  run 'rm -rf app/javascript/controllers/index.js'
  run 'touch app/javascript/controllers/index.js'

  append_file 'app/javascript/controllers/index.js', <<~JS
    // Load all the controllers within this directory and all subdirectories.
    // Controller files must be named *_controller.js.

    import { Application } from "@hotwired/stimulus"
    import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

    const application = Application.start()
    const context = require.context("controllers", true, /_controller\.js$/)
    application.load(definitionsFromContext(context))
  JS

  gsub_file 'app/javascript/controllers/hello_controller.js', 'from "stimulus"', 'from "@hotwired/stimulus"'
end

def pick_simple_option
  option = ask '>> '

  case option
  when 'y' then return true
  when 'n' then return false
  else
    say 'Error - please pick a valid [yn] choice'
    pick_simple_option
  end
end

def pick_framework
  option = ask 'pick a number'
  case option
  when '1' then return 'bootstrap'
  when '2' then return 'tailwind'
  when '3' then return 'no-framework'
  else
    say 'Invalid - please pick a number from the list'
    pick_framework
  end
end

def pick_bootstrap_version
  option = ask '>> '

  case option
  when '1' then return true
  when '2' then return false
  else
    say 'Invalid - please pick a number from the list'
    pick_bootstrap_version
  end
end

say
say
say '-- Welcome to 🎍 BambooSticks 🎍: A RoR Template! --'
say 'a setup developed by MangoTree 🥭🌴 to support you in your development'

if options['api']
  say '🤖 You added the API option 🤖'
end

say 'Tell us a bit about how you want to set up your app:'
say

bootstrap_option = false
tailwind_option = false
no_framework_option = false

unless options['api']
  say 'Which UI framework would you like to use? 🏗'
  say '1 - Bootstrap'
  say '2 - Tailwind'
  say '3 - No framework, thanks!'
  selected_framework = pick_framework

  bootstrap_option = selected_framework == 'bootstrap'
  tailwind_option = selected_framework == 'tailwind'
  no_framework_option = selected_framework == 'no-framework'

  if bootstrap_option
    say "Which version of Bootstrap do you want to use?"
    say '1 - Bootstrap v5.0'
    say '2 - Bootstrap v4.6'
    bootstrap_last_version = pick_bootstrap_version
  end
end

say 'Would you like to implement devise for authentication? [yn] 🤠'
devise_option = pick_simple_option
if devise_option
  say 'Would you like to implement pundit for authorization? [yn] 🧐'
  pundit_option = pick_simple_option
end

unless options['api']
  say 'Would you like to implement stimulus for javascript? [yn] 🥳'
  stimulus_option = pick_simple_option
  say
end

run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    gem 'autoprefixer-rails'
    gem 'font-awesome-sass'
    gem 'simple_form'
  RUBY
end unless options['api']

inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    gem 'devise'
  RUBY
end if devise_option

inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    gem 'pundit'

  RUBY
end if pundit_option

inject_into_file 'Gemfile', after: 'group :development, :test do' do
  <<-RUBY

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'

  # Testing Suite
  gem 'rspec-rails'
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'timecop'
  gem 'simplecov'
  RUBY
end

inject_into_file 'Gemfile', after: "gem 'selenium-webdriver'" do
  <<-RUBY

  gem 'capybara-screenshot'
  RUBY
end

inject_into_file 'Gemfile', after: 'group :development do' do
  <<-RUBY

  gem 'bullet'
  # Comment in when ready to see page load times
  # gem 'rack-mini-profiler'
  RUBY
end

gsub_file('Gemfile', /# gem 'redis'/, "gem 'redis'")

# Assets & GitHub Actions/Workflow
########################################
run 'rm -rf vendor'
run 'curl -L https://github.com/mangotreedev/bamboosticks/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip'

unless options['api']
  run 'rm -rf app/assets/stylesheets'

  run 'mv app/assets/bamboosticks-master/bootstrap/stylesheets app/assets/stylesheets' if bootstrap_option
  run 'mv app/assets/bamboosticks-master/vanilla-scss/stylesheets app/assets/stylesheets' if no_framework_option

  if tailwind_option
    run 'mv app/assets/bamboosticks-master/tailwind/stylesheets app/assets/stylesheets'
    run 'mv app/assets/bamboosticks-master/tailwind/config/simple_form_tailwind.rb config/initializers/simple_form_tailwind.rb'
  end

  if tailwind_option || no_framework_option
    run 'mkdir -p app/javascript/components'
    run 'mv app/assets/bamboosticks-master/tailwind/javascript/initAlerts.js app/javascript/components/initAlerts.js'
  end
end

run 'mv app/assets/bamboosticks-master/.github .github'
run 'rm -rf app/assets/bamboosticks-master'
run 'rm -rf app/assets' if options['api']

if !devise_option && !options['api']
  run 'rm -rf app/assets/stylesheets/components/_navbar.scss'
  gsub_file('app/assets/stylesheets/components/_index.scss', '@import "navbar";', '')
end

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')


# Layout
########################################
unless options['api']
  if Rails.version < "6"
    scripts = <<~HTML
      <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload', defer: true %>
          <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
    HTML
    gsub_file('app/views/layouts/application.html.erb', "<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>", scripts)
  end
  gsub_file('app/views/layouts/application.html.erb', "<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>", "<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload', defer: true %>")
  style = <<~HTML
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
  HTML
  gsub_file('app/views/layouts/application.html.erb', "<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>", style)
end

# README
########################################
run 'rm -rf README.md'
run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/project_readme.md > README.md'

# Generators
########################################
generators = <<~RUBY
  config.generators do |generate|
    generate.assets false
    generate.helper false
    generate.test_framework :test_unit, fixture: false
  end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Spring Stop
  ########################################
  run "spring stop" # Fix pesky hangtime

  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'

  generate('simple_form:install', '--bootstrap') if bootstrap_option

  unless options['api']
    generate(:controller, 'pages', 'home kitchensink', '--skip-routes', '--no-test-framework')

    # Routes
    ########################################
    route "root to: 'pages#home'"
    route "get '/kitchensink', to: 'pages#kitchensink' if Rails.env.development?"
  end

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT
    # Ignore .env file containing credentials.
    .env*
    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
    # Ignore all coverage reports generated by simplecov
    /coverage/*
  TXT

  # Options Setup
  ########################################
  setup_frontend_framework_layout(devise_option) unless options['api']
  setup_bootstrap_framework(devise_option, bootstrap_last_version) if bootstrap_option
  setup_tailwind_framework(devise_option) if tailwind_option
  setup_vanilla_frontend(devise_option) if no_framework_option
  setup_devise_authentication if devise_option
  setup_pundit_authorization if pundit_option
  setup_stimulus_framework if stimulus_option

  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

  # Bullet Configuration
  ########################################
  inject_into_file 'config/environments/development.rb', after: 'config.file_watcher = ActiveSupport::EventedFileUpdateChecker' do
    <<~RUBY

      # Bullet for development setup
      config.after_initialize do
        Bullet.enable = true
        Bullet.rails_logger = true
      end
    RUBY
  end

  # Testing Suite Configuration (RSpec+)
  ########################################
  # RSpec configuration
  run 'rm -rf test'
  generate('rspec:install')

  # Capybara configuration for rails helper
  inject_into_file 'spec/rails_helper.rb', after: "require 'spec_helper'" do
    <<~RUBY

    require 'capybara/rspec'
    require 'capybara-screenshot/rspec'

    RUBY
  end

  # Database Cleaner & Factory Bot configuration
  inject_into_file 'spec/rails_helper.rb', after: 'RSpec.configure do |config|' do
    <<~RUBY
      # DatabaseCleaner with AR configuration
      config.before(:suite) do
        DatabaseCleaner.clean_with(:truncation)
      end

      config.before(:each) do
        DatabaseCleaner.strategy = :transaction
      end

      config.before(:each, :js => true) do
        DatabaseCleaner.strategy = :truncation
      end

      config.before(:each) do
        DatabaseCleaner.start
      end

      config.after(:each) do
        DatabaseCleaner.clean
      end
      # Factory Bot configuration
      config.include FactoryBot::Syntax::Methods
    RUBY
  end

  # Adjust transactional_fixtures for database cleaner config above
  gsub_file 'spec/rails_helper.rb', 'config.use_transactional_fixtures = true', 'config.use_transactional_fixtures = false'

  # Shoulda Matchers configuration
  append_file 'spec/rails_helper.rb' do
    <<~RUBY
      # Shoulda Matchers configuration
      Shoulda::Matchers.configure do |config|
        config.integrate do |with|
          with.test_framework :rspec
          with.library :rails
        end
      end

      # Capybara save screenshot on failure in tmp folder
      Capybara::Screenshot.autosave_on_failure = true

      # Comment in :selenium, to view tests manually
      # Comment in :selenium_chrome_headless to run all tests with selenium as opposed to :rack_test
      # Capybara.default_driver = :selenium
      # Capybara.default_driver = :selenium_chrome_headless
      Capybara.javascript_driver = :selenium_chrome_headless
    RUBY
  end

  prepend_file 'spec/spec_helper.rb' do
    <<~RUBY
      require 'simplecov'

      SimpleCov.start 'rails'
    RUBY
  end

  # Database YML config for CI
  ########################################
  gsub_file('config/database.yml',
            /\n# As with config\/credentials.yml, you never want to store sensitive information,/,
            "  host: 127.0.0.1\n  username: postgres\n  password: postgres\
            \n\n# As with config\/credentials.yml, you never want to store sensitive information,")

  # Dotenv
  ########################################
  run 'touch .env'

  # bin/setup
  ########################################
  run 'rm bin/setup'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/setup > bin/setup'
  run 'chmod +x ./bin/setup'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/.rubocop.yml > .rubocop.yml'

  # Fix puma config
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'ARCH: Base rails app generation using BambooSticks'"
end
