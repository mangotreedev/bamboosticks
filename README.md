# MangoTree Rails Template: BambooSticks

## Description :speak_no_evil:
BambooSticks is the template we use at MangoTree to generate RoR applications with a basic setup suitable for most web applications.  We hope this template supports you as you begin your application development, just as bamboo sticks support a fledgling plant.

It will take you through a decision tree on which front end framework you want to use, whether or not you want to add devise for authentication, pundit for authorization, and stimulus for JS; so make sure you pay attention while your app is generating!

If you would like to see something added in or want to understand more on why we made certain decisions please don't hesitate to raise an issue!

![Alt text](https://res.cloudinary.com/nico1711/image/upload/v1607220863/bamboo_clqlng.jpg "bamboo_shoots")

## Command to run :running:
`rails new --database postgresql -m https://raw.githubusercontent.com/mangotreedev/bamboosticks/master/bambooSticks.rb YOUR_RAILS_APP_NAME`

## Added gems :gem:
- [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails) - a tool to parse CSS and add vendor prefixes to CSS rules
- [Bullet](https://github.com/flyerhzm/bullet) - a tool to kill N+1 queries
- [Dotenv](https://github.com/bkeepers/dotenv) - shim to load environment variables from .env into ENV in development
- [FontAwesome::Sass](https://github.com/FortAwesome/font-awesome-sass) - a Sass-powered version of FontAwesome for your Ruby projects
- [Pry-byebyg](https://github.com/deivid-rodriguez/pry-byebug) - adds step-by-step debugging and stack navigation capabilities to pry using byebug
- [Pry-rails](https://github.com/rweng/pry-rails) - a small gem which causes rails console to open pry
- [Rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler) - middleware that displays speed badge for every html page
- [Simple Form](https://github.com/heartcombo/simple_form) - rails forms made easy

## FrontEnd Frameworks options :nail_care:
- [Bootstrap](https://getbootstrap.com/) - The most popular HTML, CSS, and JS library in the world.
- [TailwindCSS](https://tailwindcss.com/) - Rapidly build modern websites without ever leaving your HTML.

## Optional gems :gem:
- [Devise](https://github.com/heartcombo/devise) - a flexible authentication solution for Rails based on Warden
- [Pundit](https://github.com/varvet/pundit) - a set of helpers to build a simple, robust and scalable authorization system.
- [Stimulus](https://github.com/stimulusjs/stimulus) - a JavaScript framework built on writing efficient and clean JS using data attributes

## Testing gems :gem:
- [RSpec-Rails](https://github.com/rspec/rspec-rails) - the RSpec testing framework for Rails
- [Database Cleaner Active Record](https://github.com/DatabaseCleaner/database_cleaner-active_record) - clean your ActiveRecord databases
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) - provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
- [Factory Bot for Rails](https://github.com/thoughtbot/factory_bot_rails) - a fixtures replacement with a straightforward definition syntax
- [Timecop](https://github.com/travisjeffery/timecop) - a gem providing "time travel" and "time freezing" capabilities
- [SimpleCov](https://github.com/simplecov-ruby/simplecov) - a code coverage analysis tool for Ruby


## Testing Suite :bowtie:
We've built in a full testing suite revolving around RSpec that gets you off the ground quickly writing tests in no time

## Kitchen Sink :ship:
We've generated a Kitchensink route, action and view to populate with front-end components for you and your team

## Github Actions & Templates :raising_hand:
Added a customized [template](https://github.com/mangotreedev/templates/blob/master/pull_request_template.md) that's automatically added when you create a pull request on github.

Added a customized [template](https://raw.githubusercontent.com/mangotreedev/templates/master/.github/ISSUE_TEMPLATE/request.md) for opening issues in your repo that can be features, support, or bug requests.

Added a continuous integration setup to run with your rails applications and to check that all of the tests you've written with RSpec are passing during your pull requests

## Other changes :zap:
- Replaced stylesheets structure with [this one](https://github.com/mangotreedev/templates/tree/master/)
- Added four type of flashes: notice, alert, info & success
- Added a navbar to play with devise
- Set up JS to play nicely with Turbolinks


Built with love ❤️ By Nico🐺 and Sy🐢

