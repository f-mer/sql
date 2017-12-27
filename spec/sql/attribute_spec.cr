require "../spec_helper"

module SQL
  describe Attribute do
    describe "#eq" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::Equal.new(
          AST::Column.new("id"),
          AST::Integer.new(10),
        )
        relation["id"].eq(10).should eq expected_ast
      end
    end

    describe "#ne" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::NotEqual.new(
          AST::Column.new("id"),
          AST::Integer.new(10),
        )
        relation["id"].ne(10).should eq expected_ast
      end
    end

    describe "#gt" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::GreaterThan.new(
          AST::Column.new("age"),
          AST::Integer.new(18),
        )
        relation["age"].gt(18).should eq expected_ast
      end
    end

    describe "#ge" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::GreaterThanOrEqual.new(
          AST::Column.new("age"),
          AST::Integer.new(18),
        )
        relation["age"].ge(18).should eq expected_ast
      end
    end

    describe "#lt" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::LessThan.new(
          AST::Column.new("age"),
          AST::Integer.new(18),
        )
        relation["age"].lt(18).should eq expected_ast
      end
    end

    describe "#le" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::LessThanOrEqual.new(
          AST::Column.new("age"),
          AST::Integer.new(18),
        )
        relation["age"].le(18).should eq expected_ast
      end
    end

    describe "#qualify" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::QualifiedColumn.new(
          AST::Table.new("users"),
          AST::Column.new("id"),
        )
        relation["id"].qualify.ast.should eq expected_ast
        relation["id"].qualify.qualify.ast.should eq expected_ast
        relation["id"].qualify.qualify.qualify.ast.should eq expected_ast
      end
    end

    describe "#in" do
      it "#ast" do
        relation = Table.new("users")
        expected_ast = AST::In.new(
          AST::Column.new("id"),
          AST::ValueList.new([
            AST::Integer.new(1),
            AST::Integer.new(2),
          ] of AST::Node)
        )
        relation["id"].in([1, 2]).should eq expected_ast
      end
    end
  end
end
