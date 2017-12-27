module SQL
  class Attribute
    getter ast

    def initialize(@table : Table, name : String)
      @ast = case name
             when "*" then AST::All.new
             else          AST::Column.new(name)
             end
    end

    def qualify
      return self if qualified?
      @ast = AST::QualifiedColumn.new(@table.ast, @ast)
      self
    end

    def eq(other : AST::Node) : AST::Equal
      AST::Equal.new(@ast, other)
    end

    def eq(other : Attribute) : AST::Equal
      eq(other.ast)
    end

    def eq(other : String) : AST::Equal
      eq(AST::String.new(other))
    end

    def eq(other : Int) : AST::Equal
      eq(AST::Integer.new(other))
    end

    def ne(other : AST::Node) : AST::NotEqual
      AST::NotEqual.new(@ast, other)
    end

    def ne(other : Attribute) : AST::NotEqual
      ne(other.ast)
    end

    def ne(other : String) : AST::NotEqual
      ne(AST::String.new(other))
    end

    def ne(other : Int) : AST::NotEqual
      ne(AST::Integer.new(other))
    end

    def gt(other : AST::Node) : AST::GreaterThan
      AST::GreaterThan.new(@ast, other)
    end

    def gt(other : Attribute) : AST::GreaterThan
      gt(other.ast)
    end

    def gt(other : Int) : AST::GreaterThan
      gt(AST::Integer.new(other))
    end

    def ge(other : AST::Node) : AST::GreaterThanOrEqual
      AST::GreaterThanOrEqual.new(@ast, other)
    end

    def ge(other : Attribute) : AST::GreaterThanOrEqual
      ge(other.ast)
    end

    def ge(other : Int) : AST::GreaterThanOrEqual
      ge(AST::Integer.new(other))
    end

    def lt(other : AST::Node) : AST::LessThan
      AST::LessThan.new(@ast, other)
    end

    def lt(other : Attribute) : AST::LessThan
      lt(other.ast)
    end

    def lt(other : Int) : AST::LessThan
      lt(AST::Integer.new(other))
    end

    def le(other : AST::Node) : AST::LessThanOrEqual
      AST::LessThanOrEqual.new(@ast, other)
    end

    def le(other : Attribute) : AST::LessThanOrEqual
      le(other.ast)
    end

    def le(other : Int) : AST::LessThanOrEqual
      le(AST::Integer.new(other))
    end

    def in(other : AST::ValueList) : AST::In
      AST::In.new(@ast, other)
    end

    def in(other : Array(Int32)) : AST::In
      values = other.reduce([] of AST::Node) do |memo, int|
        memo << AST::Integer.new(int)
      end
      in(AST::ValueList.new(values))
    end

    private def qualified? : Bool
      @ast.class == AST::QualifiedColumn
    end
  end
end
