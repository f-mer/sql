module SQL
  describe Select do
    describe "#where" do
      it "should accept an ast" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::All.new,
          AST::From.new(
            AST::Table.new("users"),
            AST::Where.new(
              AST::Equal.new(
                AST::Column.new("name"),
                AST::String.new("Max")
              )
            )
          )
        )
        relation.where(relation["name"].eq("Max")).ast.should eq expected_ast
      end

      it "should chain wheres" do
        relation = Table.new("users")
        expected_ast = AST::Select.new(
          AST::All.new,
          AST::From.new(
            AST::Table.new("users"),
            AST::Where.new(
              AST::And.new(
                AST::Equal.new(
                  AST::Column.new("first_name"),
                  AST::String.new("Max")
                ),
                AST::And.new(
                  AST::Equal.new(
                    AST::Column.new("last_name"),
                    AST::String.new("Moritz")
                  ),
                  AST::Equal.new(
                    AST::Column.new("active"),
                    AST::Integer.new(1)
                  )
                )
              )
            )
          )
        )
        relation
          .where(relation["first_name"].eq("Max"))
          .where(relation["last_name"].eq("Moritz"))
          .where(relation["active"].eq(1))
          .ast.should eq expected_ast
      end
    end

    describe "#join" do
      it "should accept a table" do
        users = Table.new("users")
        comments = Table.new("comments")
        expected_ast = AST::Select.new(
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
                  )
                )
              )
            )
          )
        )
        join_condition = users["id"].qualify.eq(comments["user_id"].qualify)
        users.join(comments, join_condition).ast.should eq expected_ast
      end

      it "should chain joins" do
        users = Table.new("users")
        comments = Table.new("comments")
        followers = Table.new("followers")
        expected_ast = AST::Select.new(
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
                  )
                )
              ),
              AST::InnerJoin.new(
                AST::On.new(
                  AST::Table.new("followers"),
                  AST::Equal.new(
                    AST::QualifiedColumn.new(
                      AST::Table.new("users"),
                      AST::Column.new("id")
                    ),
                    AST::QualifiedColumn.new(
                      AST::Table.new("followers"),
                      AST::Column.new("user_id")
                    )
                  )
                )
              )
            )
          )
        )

        users_join_condition = users["id"].qualify.eq(comments["user_id"].qualify)
        followers_join_condition = users["id"].qualify.eq(followers["user_id"].qualify)
        users.join(comments, users_join_condition)
             .join(followers, followers_join_condition)
             .ast.should eq expected_ast
      end
    end

    it "should handle mixed #where and #join" do
      users = Table.new("users")
      comments = Table.new("comments")
      followers = Table.new("followers")
      expected_ast = AST::Select.new(
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
                )
              )
            ),
            AST::InnerJoin.new(
              AST::On.new(
                AST::Table.new("followers"),
                AST::Equal.new(
                  AST::QualifiedColumn.new(
                    AST::Table.new("users"),
                    AST::Column.new("id")
                  ),
                  AST::QualifiedColumn.new(
                    AST::Table.new("followers"),
                    AST::Column.new("user_id")
                  )
                )
              ),
              AST::Where.new(
                AST::Equal.new(
                  AST::QualifiedColumn.new(
                    AST::Table.new("users"),
                    AST::Column.new("name"),
                  ),
                  AST::String.new("Max")
                )
              )
            )
          )
        )
      )

      users_join_condition = users["id"].qualify.eq(comments["user_id"].qualify)
      followers_join_condition = users["id"].qualify.eq(followers["user_id"].qualify)
      where_condition = users["name"].qualify.eq("Max")
      users.where(where_condition)
           .join(comments, users_join_condition)
           .join(followers, followers_join_condition)
           .ast.should eq expected_ast
      users.join(comments, users_join_condition)
           .where(where_condition)
           .join(followers, followers_join_condition)
           .ast.should eq expected_ast
      users.join(comments, users_join_condition)
           .join(followers, followers_join_condition)
           .where(where_condition)
           .ast.should eq expected_ast
    end
  end
end
