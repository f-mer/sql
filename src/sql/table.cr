module SQL
  class Table
    getter ast

    def initialize(@name : String)
      @ast = AST::Table.new(@name)
    end

    def [](name : String) : Attribute
      Attribute.new(self, name)
    end

    def self.new(table : Table, columns : Array(String))
      attributes = columns.map { |column| table[column] }
      new(table, attributes)
    end

    def select
      Select.new(self)
    end

    def select(nodes : Array(AST::Node))
      Select.new(self, nodes)
    end

    def select(attributes : Array(Attribute))
      self.select(attributes.map(&.ast))
    end

    def select(columns : Array(String))
      attributes = columns.map { |column| self[column] }
      self.select(attributes)
    end

    def select(node : AST::Node)
      Select.new(self, node)
    end

    def select(attributes : Attribute)
      self.select(attributes.ast)
    end

    def select(column : String)
      attribute = self[column]
      self.select(attribute)
    end

    def where(node : AST::Node)
      self.select.where(node)
    end

    def join(table : Table, condition : AST::Node)
      self.select.join(table, condition)
    end
  end
end
