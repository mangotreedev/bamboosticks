def setup_devise_authentication
  # Devise install + User
  ########################################
  generate('devise:install')
  generate('devise', 'User')

  # Flashes & Navbar
  ########################################
  file 'app/views/shared/_flashes.html.erb', <<~HTML
    <% if notice %>
      <div class="alert alert-warning alert-dismissible fade show m-1" role="alert">
        <%= notice %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end %>
    <% if alert %>
      <div class="alert alert-danger alert-dismissible fade show m-1" role="alert">
        <%= alert %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end %>
    <% if success %>
      <div class="alert alert-success alert-dismissible fade show m-1" role="alert">
        <%= success %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end %>
    <% if info %>
      <div class="alert alert-primary alert-dismissible fade show m-1" role="alert">
        <%= info %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end %>
  HTML

  run 'curl -L https://raw.githubusercontent.com/mangotreedev/templates/master/_navbar.html.erb > app/views/shared/_navbar.html.erb'

  inject_into_file 'app/views/layouts/application.html.erb', after: '<body>' do
    <<-HTML
      <%= render 'shared/navbar' %>
      <%= render 'shared/flashes' %>
    HTML
  end

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  file 'app/controllers/application_controller.rb', <<~RUBY
    class ApplicationController < ActionController::Base
    #{  "protect_from_forgery with: :exception\n" if Rails.version < "5.2"}  before_action :authenticate_user!
      add_flash_types :info, :success
    end
  RUBY

  # Migrate & Devise views
  ########################################
  rails_command 'db:migrate'
  generate('devise:views')

  # Pages Controller
  ########################################
  run 'rm app/controllers/pages_controller.rb'
  file 'app/controllers/pages_controller.rb', <<~RUBY
    class PagesController < ApplicationController
      skip_before_action :authenticate_user!, only: [ :home, :kitchensink ]

      def home; end

      def kitchensink; end
    end
  RUBY
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

say
say
say '-- Welcome to 🎍 BambooSticks 🎍: A RoR Template! --'
say 'a setup developed by MangoTree 🥭🌴 to support you in your development'
say
say 'Tell us a bit about how you want to set up your app:'
say 'Would you like to implement devise for authentication? [yn] 🤠'
devise_option = pick_simple_option
if devise_option
  say 'Would you like to implement pundit for authorization? [yn] 🧐'
  pundit_option = pick_simple_option
end
say 'Would you like to implement stimulus for javascript? [yn] 🥳'
stimulus_option = pick_simple_option
say


run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    gem 'autoprefixer-rails'
    gem 'font-awesome-sass'
    gem 'simple_form'
  RUBY
end

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

inject_into_file 'Gemfile', after: 'group :development do' do
  <<-RUBY
  gem 'bullet'
  gem 'rack-mini-profiler'
  RUBY
end

gsub_file('Gemfile', /# gem 'redis'/, "gem 'redis'")

# Assets & GitHub Actions/Workflow
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
run 'curl -L https://github.com/mangotreedev/templates/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip'
run 'mv app/assets/templates-master/stylesheets app/assets/stylesheets'
run 'mv app/assets/templates-master/.github .github'
run 'rm -rf app/assets/templates-master'

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Layout
########################################
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

# README
########################################
markdown_file_content = <<-MARKDOWN
# >>PLEASE UPDATE ME<<

Rails app generated with BambooSticks, based on the LeWagon Devise template & Thoughtbot Suspenders.

Developed & Designed by MangoTree Dev Agency
MARKDOWN
file 'README.md', markdown_file_content, force: true

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
  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate('simple_form:install', '--bootstrap')
  generate(:controller, 'pages', 'home kitchensink', '--skip-routes', '--no-test-framework')

  # Routes
  ########################################
  route "root to: 'pages#home'"
  route "get '/kitchensink', to: 'pages#kitchensink' if Rails.env.development?"

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
  setup_devise_authentication if devise_option
  setup_pundit_authorization if pundit_option
  setup_stimulus_framework if stimulus_option

  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

  # Webpacker / Yarn
  ########################################
  run 'yarn add popper.js jquery bootstrap'
  append_file 'app/javascript/packs/application.js', <<~JS


    // ----------------------------------------------------
    // Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
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

  # Database Cleaner & Factory Bot configuration
  inject_into_file 'spec/rails_helper.rb', after: 'RSpec.configure do |config|' do
    <<~RUBY
      # DatabaseCleaner with AR configuration
      config.before(:suite) do
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.clean_with(:truncation)
      end

      config.before do
        DatabaseCleaner.strategy = :transaction
        DatabaseCleaner.start
      end

      config.append_after do
        DatabaseCleaner.clean
      end
      # Factory Bot configuration
      config.include FactoryBot::Syntax::Methods
    RUBY
  end

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
    RUBY
  end

  prepend_file 'spec/spec_helper.rb' do
    <<~RUBY
      require 'simplecov'

      SimpleCov.start 'rails'
    RUBY
  end

  # Dotenv
  ########################################
  run 'touch .env'

  # bin/setup
  ########################################
  run 'rm bin/setup'
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/templates/master/setup > bin/setup'
  run 'chmod +x ./bin/setup'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/mangotreedev/templates/master/.rubocop.yml > .rubocop.yml'


  # Git
  ########################################
  git add: '.'
  git commit: "-m 'ARCH: Base rails app generation using BambooSticks'"

  # Fix puma config
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')
end
