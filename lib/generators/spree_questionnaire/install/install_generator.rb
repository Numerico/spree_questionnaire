module SpreeQuestionnaire
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
        append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_questionnaire\n"
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_questionnaire\n"
      end

      def add_stylesheets
        store_css_scss = 'app/assets/stylesheets/store/all.css.scss'
        store_css = 'app/assets/stylesheets/store/all.css'
        store = File.exist?(store_css_scss) ? store_css_scss : store_css
        inject_into_file store, " *= require store/spree_questionnaire\n", :before => /\*\//, :verbose => true
        inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_questionnaire\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_questionnaire'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def install_simple_form
        run 'bundle exec rails generate simple_form:install'
      end

    end
  end
end
