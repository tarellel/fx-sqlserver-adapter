# frozen_string_literal: true

require 'fx/trigger'

module Fx
  module Adapters
    class Sqlserver
      # Fetches defined triggers from the sqlserver connection.
      # @api private
      class Triggers
        # The query must return two attributes, name and definition
        TRIGGERS_WITH_DEFINITIONS_QUERY = <<-STR
          SELECT
            t.name AS name,
            m.definition AS definition
          FROM sys.triggers t,
              sys.sql_modules m
          WHERE
            t.type = 'TR'
            AND t.object_id = m.object_id
        STR

        # Wraps #all as a static facade.
        #
        # @return [Array<Fx::Trigger>]
        def self.all(*args)
          new(*args).all
        end

        def initialize(connection)
          @connection = connection
        end

        # All of the triggers that this connection has defined.
        #
        # @return [Array<Fx::Trigger>]
        def all
          triggers_from_sqlserver.map { |trigger| to_fx_trigger(trigger) }
        end

        private

        attr_reader :connection

        def triggers_from_sqlserver
          connection.exec_query(TRIGGERS_WITH_DEFINITIONS_QUERY)
        end

        def to_fx_trigger(result)
          Fx::Trigger.new(result)
        end
      end
    end
  end
end
