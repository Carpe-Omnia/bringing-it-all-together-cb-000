class Dog
  attr_accessor :id, :name, :breed
  def initialize(name:, breed:, id:=nil)
    @name = name
    @breed = breed
    @id = id
  end
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs;"
    DB[:conn].execute(sql)
  end
  def save
  if @id == nil
      sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?);
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    else
      self.update
    end
  end
  def self.create(name, breed)
    stud = self.new(name, breed)
    stud.save
    stud
  end
  def self.find_by_name(name)
    sql = <<-SQL
     SELECT * FROM dogs
     WHERE name = ? ;
    SQL
   row = DB[:conn].execute(sql, name)
   self.new_from_db(row[0])
  end
  def self.new_from_db(row)
    stud = self.new(row[1],row[2],row[0])
    stud
  end
  def self.find_by_name(name)
    sql = <<-SQL
     SELECT * FROM dogs
     WHERE name = ? ;
    SQL
   row = DB[:conn].execute(sql, name)
   self.new_from_db(row[0])
  end
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
end
