require 'spec_helper'

describe ActiveRecord::ColumnMetadata do
  it 'should have a version number' do
    ActiveRecord::ColumnMetadata::VERSION.should_not be_nil
  end

  def get_comments(table_name)
    ActiveRecord::Base.connection.query(<<-END_SQL, 'Get comments')
      SELECT a.attname,
             pg_catalog.col_description(a.attrelid, a.attnum)
        FROM pg_catalog.pg_attribute a
       WHERE a.attrelid = '#{table_name}'::regclass
         AND a.attnum > 0
         AND NOT a.attisdropped
    ORDER BY a.attname
    END_SQL
  end

  class CreateTableMigration < ActiveRecord::Migration
    def self.up
      create_table(:people) do |t|
        t.string :name
      end
    end
  end

  class AddColumnMigration < ActiveRecord::Migration
    def self.up
      add_column :people, :surname, :string, :metadata => {full_text_search: "double_metaphone"}
    end
  end

  describe 'write should add JSON in comment' do
    it 'with add_column' do
      CreateTableMigration.up
      AddColumnMigration.up
      res = get_comments("people")
      expect(res).to include( ['surname', '{"full_text_search":"double_metaphone"}'])
    end

    class AddColumnMetadataMigration < ActiveRecord::Migration
      def self.up
        column_metadata :people, :name, {completely: "different"}
      end
    end

    it 'with add_column_metadata' do
      CreateTableMigration.up
      AddColumnMetadataMigration.up
      res = get_comments("people")
      expect(res).to include( ['name', '{"completely":"different"}'])
    end
  end

  describe 'read' do
    it '#to_a should return a column comments as an array of arrays' do
      CreateTableMigration.up
      AddColumnMigration.up
      res = ActiveRecord::ColumnMetadata.to_a(:people)
      res.should == [["surname", {"full_text_search"=>"double_metaphone"}]]
    end
  end
end
