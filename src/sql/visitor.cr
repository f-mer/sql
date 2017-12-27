module SQL
  class Visitor
    def visit(node : AST::Select)
      "SELECT #{visit(node.left)} #{visit(node.right)}"
    end

    def visit(node : AST::All)
      "*"
    end

    def visit(node : AST::From)
      "FROM #{visit(node.left)} #{visit(node.right)}"
    end

    def visit(node : AST::Table)
      quote(node.value)
    end

    def visit(node : AST::Where)
      "WHERE #{visit(node.value)}"
    end

    def visit(node : AST::Equal)
      "#{visit(node.left)} = #{visit(node.right)}"
    end

    def visit(node : AST::NotEqual)
      "#{visit(node.left)} != #{visit(node.right)}"
    end

    def visit(node : AST::GreaterThan)
      "#{visit(node.left)} > #{visit(node.right)}"
    end

    def visit(node : AST::GreaterThanOrEqual)
      "#{visit(node.left)} >= #{visit(node.right)}"
    end

    def visit(node : AST::LessThan)
      "#{visit(node.left)} < #{visit(node.right)}"
    end

    def visit(node : AST::LessThanOrEqual)
      "#{visit(node.left)} <= #{visit(node.right)}"
    end

    def visit(node : AST::Column)
      quote(node.value)
    end

    def visit(node : AST::String)
      "'#{node.value}'"
    end

    def visit(node : AST::Integer)
      node.value.to_s
    end

    def visit(node : AST::InnerJoin)
      ::String.build do |io|
        io << "INNER JOIN #{visit(node.left)}"
        io << " #{visit(node.right)}" if node.right
      end
    end

    def visit(node : AST::On)
      "#{visit(node.left)} ON #{visit(node.right)}"
    end

    def visit(node : AST::QualifiedColumn)
      "#{visit(node.left)}.#{visit(node.right)}"
    end

    def visit(node : AST::ColumnList)
      visit_all(node.value).join(", ")
    end

    def visit(node : AST::And)
      "#{visit(node.left)} AND #{visit(node.right)}"
    end

    def visit(node : AST::Or)
      "#{visit(node.left)} OR #{visit(node.right)}"
    end

    def visit(node : AST::Alias)
      "#{visit(node.left)} AS #{visit(node.right)}"
    end

    def visit(node : AST::Insert)
      "INSERT #{visit(node.left)} #{visit(node.right)}"
    end

    def visit(node : AST::Into)
      "INTO #{visit(node.left)} (#{visit(node.right)})"
    end

    def visit(node : AST::Values)
      ::String.build do |io|
        io << "VALUES (#{visit(node.left)})"
        io << " #{visit(node.right)}" if node.right
      end
    end

    def visit(node : AST::ValueList)
      visit_all(node.value).join(", ")
    end

    def visit(node : AST::In)
      "#{visit(node.left)} IN (#{visit(node.right)})"
    end

    def visit(node : AST::BindParam)
      "?"
    end

    def visit(node : AST::Unary); end

    def visit(node : Nil); end

    private def quote(str)
      "`#{str}`"
    end

    private def visit_all(nodes : Array(AST::Node))
      nodes.map { |node| visit(node) }
    end
  end
end
