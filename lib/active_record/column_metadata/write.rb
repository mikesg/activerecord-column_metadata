require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_record/connection_adapters/abstract/schema_statements'
require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class TableDefinition
      module ColumnMetadata
        def column_metadata(column, hash)
          add_comment(column, hash)
        end

        def add_comment(column, comment)
          @comments ||= []
          @comments << [column, comment]
        end

        def comments
          @comments
        end
      end

      include ColumnMetadata
    end

    class PostgreSQLAdapter < AbstractAdapter
      def add_column_with_metadata(*args)
        add_column_without_metadata(*args)
        options = args.extract_options!
        write_json_comment(args[0], args[1], options[:metadata])
      end
      alias_method_chain :add_column, :metadata

      def column_metadata(table_name, column_name, metadata)
        write_json_comment(table_name, column_name, metadata)
      end

      def write_json_comment(table_name, column_name, comment)
        quoted_comment = comment ? quote(comment.to_json) : 'NULL'
        execute "COMMENT ON COLUMN #{quote_table_name(table_name)}.#{quote_column_name(column_name)} IS #{quoted_comment}"
      end
    end
  end
end
