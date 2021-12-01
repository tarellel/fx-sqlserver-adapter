# frozen_string_literal: true

require_relative 'sqlserver/connection'
require_relative 'sqlserver/functions'
require_relative 'sqlserver/triggers'

module Fx
  # F(x) database adapters.
  #
  module Adapters
    # Sqlserver adapter class to be used with F(x)
    #
    class Sqlserver
      # Creates an instance of the F(x) Sqlserver adapter.
      #
      # To use this adapter is required to configure via {Fx.configure},
      # explicitly setting it accordingly with the example below.
      #
      # @param [#connection] connectable An object that returns the connection
      #   for F(x) to use. Defaults to `ActiveRecord::Base`.
      #
      # @example
      #  Fx.configure do |config|
      #    config.adapter = Fx::Adapters::Sqlserver.new
      #  end
      def initialize(connectable = ActiveRecord::Base)
        @connectable = connectable
      end

      # Returns an array of functions in the database.
      #
      # This collection of functions is used by the [Fx::SchemaDumper] to
      # populate the `schema.rb` file.
      #
      # @return [Array<Fx::Function>]
      def functions
        Functions.all(connection)
      end

      # Returns an array of triggers in the database.
      #
      # This collection of triggers is used by the [Fx::SchemaDumper] to
      # populate the `schema.rb` file.
      #
      # @return [Array<Fx::Trigger>]
      def triggers
        Triggers.all(connection)
      end

      # Creates a function in the database.
      #
      # This is typically called in a migration via
      # {Fx::Statements::Function#create_function}.
      #
      # @param sql_definition The SQL schema for the function.
      #
      # @return [void]
      def create_function(sql_definition)
        execute sql_definition
      end

      # Creates a trigger in the database.
      #
      # This is typically called in a migration via
      # {Fx::Statements::Trigger#create_trigger}.
      #
      # @param sql_definition The SQL schema for the trigger.
      #
      # @return [void]
      def create_trigger(sql_definition)
        execute sql_definition
      end

      # Updates a function in the database.
      #
      # This is typically called in a migration via
      # {Fx::Statements::Function#update_function}.
      #
      # @param name The name of the function.
      # @param sql_definition The SQL schema for the function.
      #
      # @return [void]
      def update_function(name, sql_definition)
        drop_function(name)
        create_function(sql_definition)
      end

      # Updates a trigger in the database.
      #
      # The existing trigger is dropped and recreated using the supplied `on`
      # and `version` parameter.
      #
      # This is typically called in a migration via
      # {Fx::Statements::Function#update_trigger}.
      #
      # @param name The name of the trigger.
      # @param on The associated table for the trigger to drop
      # @param sql_definition The SQL schema for the function.
      #
      # @return [void]
      def update_trigger(name, on:, sql_definition:)
        drop_trigger(name, on: on)
        create_trigger(sql_definition)
      end

      # Drops the function from the database
      #
      # This is typically called in a migration via
      # {Fx::Statements::Function#drop_function}.
      #
      # @param name The name of the function to drop
      #
      # @return [void]
      def drop_function(name, *_opts, on: '', **_options)
        execute <<~SQL
          DROP FUNCTION IF EXISTS #{name};
          DROP PROCEDURE IF EXISTS #{name};
        SQL
      end

      # Drops the trigger from the database
      #
      # This is typically called in a migration via
      # {Fx::Statements::Trigger#drop_trigger}.
      #
      # @param name The name of the trigger to drop
      # @param on The associated table for the trigger to drop
      #
      # @return [void]
      def drop_trigger(name, *_opts, on: '', **_options)
        execute <<~SQL
          DROP TRIGGER IF EXISTS #{name};
          GO
        SQL
      end

      private

      attr_reader :connectable

      delegate :execute, to: :connection

      def connection
        Connection.new(connectable.connection)
      end
    end
  end
end
