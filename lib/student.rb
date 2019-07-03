class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_reader :name, :grade, :id
  attr_writer :name , :grade

  @@all = []

  def initialize(name,grade,id = 0)
  	@name = name
  	@grade = grade
  	@id= id
  	@@all << self
  end

  def self.all
  	@@all
  end
  
  def self.create_table
  	sql = <<-SQL
  		CREATE TABLE students(
  			id INTEGER PRIMARY KEY,
  			name TEXT,
  			grade INTEGER
  		);
  	SQL

  	DB[:conn].execute(sql)
  end

    def self.drop_table
    sql2 = <<-SQL
      DROP TABLE students
      SQL

    DB[:conn].execute(sql2)
  end

  def save
    sql3 =<<-SQL
    INSERT INTO students (name,grade)
    VALUES (?,?)
    SQL

    DB[:conn].execute(sql3, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(hash)
    name = hash[:name]
    grade = hash[:grade]
    student = Student.new(name,grade)
    student.save
    student
  end


end
