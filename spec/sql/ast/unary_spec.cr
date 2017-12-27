require "../../spec_helper"

module SQL::AST
  describe Table do
    it "#to_sql" do
      ast = AST::Table.new("users")
      ast.to_sql.should eq "`users`"
    end
  end

  describe Where do
    it "#to_sql" do
      ast = AST::Where.new(
        AST::Equal.new(
          AST::Column.new("name"),
          AST::String.new("Max")
        )
      )
      ast.to_sql.should eq "WHERE `name` = 'Max'"
    end
  end

  describe Column do
    it "#to_sql" do
      ast = AST::Column.new("name")
      ast.to_sql.should eq "`name`"
    end
  end

  describe String do
    it "#to_sql" do
      ast = AST::String.new("Max")
      ast.to_sql.should eq "'Max'"
    end
  end

  describe Integer do
    it "#to_sql" do
      ast = AST::Integer.new(1)
      ast.to_sql.should eq "1"
    end
  end

  describe BindParam do
    it "#to_sql" do
      ast = AST::BindParam.new(1)
      ast.to_sql.should eq "?"
    end
  end
end
