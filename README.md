<h1 align="center">🏗 sql</h1>

<div align="center">Build sql queries programmatically.</div>

![stability](https://img.shields.io/badge/stability-experimental-orange.svg?style=flat-square)

## Usage
Crystal code
```cr
require "sql"

users = SQL::Table.new("users")
articles = SQL::Table.new("articles")

query = users
  .where(users["name"].qualify.eq("Tom"))
  .join(articles, users["id"].qualify.eq(articles["user_id"].qualify))

query.to_sql
```

Generated SQL
```sql
SELECT * FROM `users` INNER JOIN `articles` ON `users`.`id` = `articles`.`user_id` WHERE `users`.`name` = 'Tom'
```

## Installation
Add this to your application's `shard.yml`:

```yaml
dependencies:
  sql:
    github: f-mer/sql
```
