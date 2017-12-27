require "../../spec_helper"

module SQL::AST
  describe Node do
    describe All do
      it "#to_sql" do
        ast = AST::All.new
        ast.to_sql.should eq "*"
      end
    end

    it "#and" do
      ast = AST::Equal.new(
        AST::Column.new("first_name"),
        AST::String.new("Max")
      ).and(AST::Equal.new(
        AST::Column.new("first_name"),
        AST::String.new("Moritz")
      ))

      expected_ast = AST::And.new(
        AST::Equal.new(
          AST::Column.new("first_name"),
          AST::String.new("Max")
        ),
        AST::Equal.new(
          AST::Column.new("first_name"),
          AST::String.new("Moritz")
        )
      )

      ast.should eq expected_ast
    end

    it "#or" do
      ast = AST::Equal.new(
        AST::Column.new("first_name"),
        AST::String.new("Max")
      ).or(AST::Equal.new(
        AST::Column.new("first_name"),
        AST::String.new("Moritz")
      ))

      expected_ast = AST::Or.new(
        AST::Equal.new(
          AST::Column.new("first_name"),
          AST::String.new("Max")
        ),
        AST::Equal.new(
          AST::Column.new("first_name"),
          AST::String.new("Moritz")
        )
      )

      ast.should eq expected_ast
    end
  end
end
