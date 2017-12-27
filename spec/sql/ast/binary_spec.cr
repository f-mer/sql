require "../../spec_helper"

module SQL::AST
  describe QualifiedColumn do
    it "#to_sql" do
      ast = AST::QualifiedColumn.new(
        AST::Table.new("users"),
        AST::Column.new("name")
      )
      ast.to_sql.should eq "`users`.`name`"
    end
  end

  describe Equal do
    it "#to_sql" do
      ast = AST::Equal.new(
        AST::Column.new("name"),
        AST::String.new("Max")
      )
      ast.to_sql.should eq "`name` = 'Max'"
    end
  end

  describe NotEqual do
    it "#to_sql" do
      ast = AST::NotEqual.new(
        AST::Column.new("name"),
        AST::String.new("Max")
      )
      ast.to_sql.should eq "`name` != 'Max'"
    end
  end

  describe GreaterThan do
    it "#to_sql" do
      ast = AST::GreaterThan.new(
        AST::Column.new("age"),
        AST::Integer.new(18)
      )
      ast.to_sql.should eq "`age` > 18"
    end
  end

  describe GreaterThanOrEqual do
    it "#to_sql" do
      ast = AST::GreaterThanOrEqual.new(
        AST::Column.new("age"),
        AST::Integer.new(18)
      )
      ast.to_sql.should eq "`age` >= 18"
    end
  end

  describe LessThan do
    it "#to_sql" do
      ast = AST::LessThan.new(
        AST::Column.new("age"),
        AST::Integer.new(18)
      )
      ast.to_sql.should eq "`age` < 18"
    end
  end

  describe LessThanOrEqual do
    it "#to_sql" do
      ast = AST::LessThanOrEqual.new(
        AST::Column.new("age"),
        AST::Integer.new(18)
      )
      ast.to_sql.should eq "`age` <= 18"
    end
  end

  describe And do
    it "#to_sql" do
      ast = AST::And.new(
        AST::Equal.new(
          AST::Column.new("first_name"),
          AST::String.new("Max")
        ),
        AST::Equal.new(
          AST::Column.new("last_name"),
          AST::String.new("Mustermann")
        )
      )
      ast.to_sql.should eq "`first_name` = 'Max' AND `last_name` = 'Mustermann'"
    end
  end

  describe Or do
    it "#to_sql" do
      ast = AST::Or.new(
        AST::Equal.new(
          AST::Column.new("name"),
          AST::String.new("Max")
        ),
        AST::Equal.new(
          AST::Column.new("name"),
          AST::String.new("Moritz")
        )
      )
      ast.to_sql.should eq "`name` = 'Max' OR `name` = 'Moritz'"
    end
  end

  describe From do
    it "#to_sql" do
      ast = AST::From.new(
        AST::Table.new("users"),
        AST::Where.new(
          AST::Equal.new(
            AST::Column.new("name"),
            AST::String.new("Max")
          )
        )
      )
      ast.to_sql.should eq "FROM `users` WHERE `name` = 'Max'"
    end
  end

  describe Select do
    it "#to_sql" do
      ast = AST::Select.new(
        AST::All.new,
        AST::From.new(
          AST::Table.new("users"),
          AST::InnerJoin.new(
            AST::On.new(
              AST::Table.new("comments"),
              AST::Equal.new(
                AST::QualifiedColumn.new(
                  AST::Table.new("users"),
                  AST::Column.new("id")
                ),
                AST::QualifiedColumn.new(
                  AST::Table.new("comments"),
                  AST::Column.new("user_id")
                ),
              )
            ),
            AST::Where.new(
              AST::Equal.new(
                AST::Column.new("name"),
                AST::String.new("Max")
              )
            )
          )
        )
      )
      ast.to_sql.should eq "SELECT * FROM `users` INNER JOIN `comments` ON `users`.`id` = `comments`.`user_id` WHERE `name` = 'Max'"
    end
  end

  describe On do
    it "#to_sql" do
      ast = AST::On.new(
        AST::Table.new("comments"),
        AST::Equal.new(
          AST::QualifiedColumn.new(
            AST::Table.new("users"),
            AST::Column.new("id")
          ),
          AST::QualifiedColumn.new(
            AST::Table.new("comments"),
            AST::Column.new("user_id")
          ),
        )
      )

      ast.to_sql.should eq "`comments` ON `users`.`id` = `comments`.`user_id`"
    end
  end

  describe InnerJoin do
    it "#to_sql" do
      ast = AST::InnerJoin.new(
        AST::On.new(
          AST::Table.new("comments"),
          AST::Equal.new(
            AST::QualifiedColumn.new(
              AST::Table.new("users"),
              AST::Column.new("id")
            ),
            AST::QualifiedColumn.new(
              AST::Table.new("comments"),
              AST::Column.new("id")
            ),
          )
        )
      )
      ast.to_sql.should eq "INNER JOIN `comments` ON `users`.`id` = `comments`.`id`"
    end
  end

  describe Alias do
    it "#to_sql" do
      ast = AST::Alias.new(
        AST::Column.new("name"),
        AST::Column.new("first_name")
      )
      ast.to_sql.should eq "`name` AS `first_name`"
    end
  end

  describe Insert do
    it "#to_sql" do
      ast = AST::Insert.new(
        AST::Into.new(
          AST::Table.new("users"),
          AST::ColumnList.new([
            Column.new("first_name"),
            Column.new("last_name"),
          ] of AST::Node)
        ),
        AST::Values.new(
          AST::ValueList.new([
            AST::String.new("Max"),
            AST::String.new("Mustermann"),
          ] of AST::Node)
        )
      )
      ast.to_sql.should eq "INSERT INTO `users` (`first_name`, `last_name`) VALUES ('Max', 'Mustermann')"
    end
  end

  describe In do
    it "#to_sql" do
      ast = AST::In.new(
        AST::Column.new("id"),
        AST::ValueList.new([
          AST::Integer.new(1),
          AST::Integer.new(2),
        ] of AST::Node)
      )
      ast.to_sql.should eq "`id` IN (1, 2)"
    end
  end

  describe Insert do
    it "#to_sql" do
      ast = AST::Insert.new(
        AST::Into.new(
          AST::Table.new("users"),
          AST::ColumnList.new([
            AST::Column.new("name"),
            AST::Column.new("age"),
          ] of AST::Node)
        ),
        AST::Values.new(
          AST::ValueList.new([
            AST::String.new("Max"),
            AST::Integer.new(22),
          ])
        )
      )
      ast.to_sql.should eq "INSERT INTO `users` (`name`, `age`) VALUES ('Max', 22)"
    end
  end
end
