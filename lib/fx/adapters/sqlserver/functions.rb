# frozen_string_literal: true

require 'fx/function'

module Fx
  module Adapters
    class Sqlserver
      # Fetches defined functions from the sqlserver connection.
      # @api private
      class Functions
        # The SQL query used by F(x) to retrieve the functions considered
        # dumpable into `db/schema.rb`.
        FUNCTIONS_WITH_DEFINITIONS_QUERY = <<-STR
          SELECT
            routine_name AS name,
            routine_definition AS definition
          FROM INFORMATION_SCHEMA.ROUTINES
          WHERE routine_type = 'FUNCTION'
        STR

        # Wraps #all as a static facade.
        #
        # @return [Array<Fx::Function>]
        def self.all(*args)
          new(*args).all
        end

        def initialize(connection)
          @connection = connection
        end

        # All of the functions that this connection has defined.
        #
        # @return [Array<Fx::Function>]
        def all
          functions_from_sqlserver.map { |function| to_fx_function(function) }
        end

        private

        attr_reader :connection

        def functions_from_sqlserver
          connection.exec_query(FUNCTIONS_WITH_DEFINITIONS_QUERY)
        end

        def to_fx_function(result)
          Fx::Function.new(result)
        end
      end
    end
  end
end
