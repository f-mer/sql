require "../spec_helper"

module SQL
  describe Table do
    describe "#select" do
      it "should accept single column name" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::Column.new("id"),
          AST::From.new(
            AST::Table.new("users")
          )
        )
        relation.select("id").ast.should eq expected_ast
      end

      it "should accept *" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::All.new,
          AST::From.new(
            AST::Table.new("users")
          )
        )
        relation.select("*").ast.should eq expected_ast
      end

      it "should accept multiple column names" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::ColumnList.new([
            AST::Column.new("first_name"),
            AST::Column.new("last_name"),
          ] of AST::Node),
          AST::From.new(
            AST::Table.new("users")
          )
        )
        relation.select(["first_name", "last_name"]).ast.should eq expected_ast
      end

      it "should accept a single attribute" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::ColumnList.new([
            AST::QualifiedColumn.new(
              AST::Table.new("users"),
              AST::Column.new("first_name"),
            ),
          ] of AST::Node),
          AST::From.new(
            AST::Table.new("users")
          )
        )
        relation.select(relation["first_name"].qualify).ast.should eq expected_ast
      end

      it "should accept multiple attributes" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::ColumnList.new([
            AST::QualifiedColumn.new(
              AST::Table.new("users"),
              AST::Column.new("first_name"),
            ),
            AST::QualifiedColumn.new(
              AST::Table.new("users"),
              AST::Column.new("last_name"),
            ),
          ] of AST::Node),
          AST::From.new(
            AST::Table.new("users")
          )
        )
        relation.select([
          relation["first_name"].qualify,
          relation["last_name"].qualify,
        ]).ast.should eq expected_ast
      end
    end

    describe "#[]" do
      it "should return an Attribute" do
        relation = Table.new("users")
        relation["id"].class.should eq Attribute
      end
    end
  end
end
