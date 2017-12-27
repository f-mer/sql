module SQL
  class Select
    getter ast

    @where_leaf : AST::Node
    @join_leaf : AST::Node

    def initialize(@table : Table, columns : Array(AST::Node))
      @join_leaf = @where_leaf = AST::From.new(@table.ast)
      @ast = AST::Select.new(
        AST::ColumnList.new(columns),
        @where_leaf
      )
    end

    def initialize(@table : Table, all : AST::Node)
      @join_leaf = @where_leaf = AST::From.new(@table.ast)
      @ast = AST::Select.new(all, @where_leaf)
    end

    def self.new(table : Table)
      new(table, AST::All.new)
    end

    def where(node : AST::Node)
      tap { @where_leaf = apply_where(@where_leaf, node) }
    end

    def join(table : AST::Table, condition : AST::Node)
      tap { @where_leaf = @join_leaf = apply_join(@join_leaf, table, condition) }
    end

    def join(table : Table, condition : AST::Node)
      join(table.ast, condition)
    end

    def to_sql
      @ast.to_sql
    end

    private def apply_where(onto : AST::From, node : AST::Node)
      onto.right = AST::Where.new(node)
    end

    private def apply_where(onto : AST::InnerJoin, node : AST::Node)
      onto.right = AST::Where.new(node)
    end

    private def apply_where(onto : AST::Where, node : AST::Node)
      onto.value = AST::And.new(onto.value, node)
    end

    private def apply_where(onto : AST::Binary, node : AST::Node)
      if onto.right.nil?
        onto.right = node
      else
        onto.right = AST::And.new(onto.right.not_nil!, node)
      end
    end

    private def apply_where(onto : AST::Node, node : AST::Node)
      onto
    end

    private def apply_join(onto : AST::Binary, table : AST::Table, condition : AST::Node)
      if onto.right.nil?
        onto.right = AST::InnerJoin.new(
          AST::On.new(table, condition)
        )
      else
        onto.right = AST::InnerJoin.new(
          AST::On.new(table, condition),
          onto.right.not_nil!
        )
      end
    end

    private def apply_join(onto : AST::Node, table : AST::Table, node : AST::Node)
      onto
    end
  end
end
